package cdrive.service

import cdrive.dao.*
import std.collection.*

public class FileService {
    private let db: DbConnector
    private let storage: StorageService

    public init(db: DbConnector, storage: StorageService) {
        this.db = db
        this.storage = storage
    }

    // List files in a directory
    public func listFiles(parentPath: String): String {
        let safePath = if (parentPath.size == 0) { "/" } else { parentPath }
        return db.queryToJson(
            "SELECT f.id::text, f.name, f.path, f.s3_key, f.size::text, f.content_type, "
            + "f.is_directory::text, f.parent_path, COALESCE(f.etag, ''), f.created_at::text, f.updated_at::text "
            + "FROM files f WHERE f.parent_path = ? AND f.path != '/' "
            + "ORDER BY f.is_directory DESC, f.name ASC",
            [safePath],
            ["id", "name", "path", "s3_key", "size", "content_type",
             "is_directory", "parent_path", "etag", "created_at", "updated_at"]
        )
    }

    // Upload a file
    public func uploadFile(parentPath: String, fileName: String, data: Array<Byte>, contentType: String): String {
        let safePath = if (parentPath.size == 0) { "/" } else { parentPath }
        let filePath = if (safePath == "/") { "/${fileName}" } else { "${safePath}/${fileName}" }
        let s3Key = "files${filePath}"

        // Upload to S3
        let etag = storage.uploadFile(s3Key, data, contentType)

        // Check if file already exists
        let existing = db.queryFirstValue(
            "SELECT id::text FROM files WHERE path = ?", [filePath]
        )

        if (existing.size > 0) {
            // Update existing
            db.execute(
                "UPDATE files SET size = ?, content_type = ?, etag = ?, updated_at = NOW() WHERE path = ?",
                [Int64(data.size), contentType, etag, filePath]
            )
            return "{\"success\":true,\"message\":\"File updated\",\"path\":\"${escapeJson(filePath)}\"}"
        } else {
            // Insert new
            db.execute(
                "INSERT INTO files (name, path, s3_key, size, content_type, is_directory, parent_path, etag) "
                + "VALUES (?, ?, ?, ?, ?, FALSE, ?, ?)",
                [fileName, filePath, s3Key, Int64(data.size), contentType, safePath, etag]
            )
            return "{\"success\":true,\"message\":\"File uploaded\",\"path\":\"${escapeJson(filePath)}\"}"
        }
    }

    // Create a directory
    public func createDirectory(parentPath: String, dirName: String): String {
        let safePath = if (parentPath.size == 0) { "/" } else { parentPath }
        let dirPath = if (safePath == "/") { "/${dirName}" } else { "${safePath}/${dirName}" }
        let s3Key = "dirs${dirPath}/"

        let existing = db.queryFirstValue(
            "SELECT id::text FROM files WHERE path = ?", [dirPath]
        )
        if (existing.size > 0) {
            return jsonFail("Directory already exists")
        }

        db.execute(
            "INSERT INTO files (name, path, s3_key, is_directory, parent_path) VALUES (?, ?, ?, TRUE, ?)",
            [dirName, dirPath, s3Key, safePath]
        )
        return jsonOk("Directory created")
    }

    // Delete a file or directory
    public func deleteFile(fileId: Int64): String {
        // Get file info
        let info = db.queryToJson(
            "SELECT f.path, f.s3_key, f.is_directory::text FROM files f WHERE f.id = ?",
            [fileId],
            ["path", "s3_key", "is_directory"]
        )
        if (info == "[]") {
            return jsonFail("File not found")
        }

        // Parse the response to get s3_key and is_directory
        let s3Key = extractJsonField(info, "s3_key")
        let isDir = extractJsonField(info, "is_directory")
        let path = extractJsonField(info, "path")

        if (isDir == "true" || isDir == "t") {
            // Delete all children files from S3 and DB
            let children = db.queryToJson(
                "SELECT f.s3_key, f.is_directory::text FROM files f WHERE f.parent_path LIKE ? OR f.parent_path = ?",
                ["${path}/%", path],
                ["s3_key", "is_directory"]
            )
            // Delete children from DB
            db.execute("DELETE FROM files WHERE parent_path LIKE ? OR parent_path = ?", ["${path}/%", path])
        } else {
            // Delete from S3
            try {
                storage.deleteFile(s3Key)
            } catch (_: Exception) {
                // Ignore S3 deletion errors
            }
        }

        // Delete the file/directory record
        db.execute("DELETE FROM files WHERE id = ?", [fileId])
        return jsonOk("Deleted successfully")
    }

    // Download a file - returns (bytes, contentType, fileName)
    public func downloadFile(fileId: Int64): (Array<Byte>, String, String) {
        let info = db.queryToJson(
            "SELECT f.s3_key, f.content_type, f.name FROM files f WHERE f.id = ? AND f.is_directory = FALSE",
            [fileId],
            ["s3_key", "content_type", "name"]
        )
        if (info == "[]") {
            return (Array<Byte>(), "", "")
        }

        let s3Key = extractJsonField(info, "s3_key")
        let contentType = extractJsonField(info, "content_type")
        let name = extractJsonField(info, "name")

        let (bytes, _) = storage.downloadFile(s3Key)
        return (bytes, contentType, name)
    }

    // Get file info
    public func getFileInfo(fileId: Int64): String {
        return db.queryToJson(
            "SELECT f.id::text, f.name, f.path, f.s3_key, f.size::text, f.content_type, "
            + "f.is_directory::text, f.parent_path, COALESCE(f.etag, ''), f.created_at::text, f.updated_at::text "
            + "FROM files f WHERE f.id = ?",
            [fileId],
            ["id", "name", "path", "s3_key", "size", "content_type",
             "is_directory", "parent_path", "etag", "created_at", "updated_at"]
        )
    }

    // Get storage stats
    public func getStats(): String {
        let totalFiles = db.queryFirstValue(
            "SELECT COUNT(*)::text FROM files WHERE is_directory = FALSE", []
        )
        let totalDirs = db.queryFirstValue(
            "SELECT COUNT(*)::text FROM files WHERE is_directory = TRUE AND path != '/'", []
        )
        let totalSize = db.queryFirstValue(
            "SELECT COALESCE(SUM(size), 0)::text FROM files WHERE is_directory = FALSE", []
        )
        return "{\"totalFiles\":${totalFiles},\"totalDirs\":${totalDirs},\"totalSize\":${totalSize}}"
    }

    // Rename a file
    public func renameFile(fileId: Int64, newName: String): String {
        let info = db.queryToJson(
            "SELECT f.parent_path, f.is_directory::text FROM files f WHERE f.id = ?",
            [fileId],
            ["parent_path", "is_directory"]
        )
        if (info == "[]") {
            return jsonFail("File not found")
        }
        let parentPath = extractJsonField(info, "parent_path")
        let newPath = if (parentPath == "/") { "/${newName}" } else { "${parentPath}/${newName}" }

        db.execute(
            "UPDATE files SET name = ?, path = ?, updated_at = NOW() WHERE id = ?",
            [newName, newPath, fileId]
        )
        return jsonOk("Renamed successfully")
    }

    // Search files
    public func searchFiles(query: String): String {
        return db.queryToJson(
            "SELECT f.id::text, f.name, f.path, f.s3_key, f.size::text, f.content_type, "
            + "f.is_directory::text, f.parent_path, COALESCE(f.etag, ''), f.created_at::text, f.updated_at::text "
            + "FROM files f WHERE LOWER(f.name) LIKE LOWER(?) AND f.path != '/' "
            + "ORDER BY f.is_directory DESC, f.name ASC LIMIT 50",
            ["%${query}%"],
            ["id", "name", "path", "s3_key", "size", "content_type",
             "is_directory", "parent_path", "etag", "created_at", "updated_at"]
        )
    }
}

// Helper to extract a field value from a JSON array string like [{"key":"value",...}]
func extractJsonField(json: String, field: String): String {
    let searchKey = "\"${field}\":\""
    let bytes = json.toArray()
    let keyBytes = searchKey.toArray()
    let keyLen = keyBytes.size

    var i: Int64 = 0
    while (i + keyLen < bytes.size) {
        var matched = true
        for (k in 0..keyLen) {
            if (bytes[i + k] != keyBytes[k]) {
                matched = false
                break
            }
        }
        if (matched) {
            let start = i + keyLen
            var end = start
            while (end < bytes.size && bytes[end] != 34) {
                if (bytes[end] == 92 && end + 1 < bytes.size) {
                    end += 2
                } else {
                    end += 1
                }
            }
            return String.fromUtf8(bytes[start..end])
        }
        i += 1
    }
    return ""
}
