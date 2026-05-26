package cdrive.service

import std.fs.*
import std.io.*
import std.collection.*

// Seed the cloud drive with project source files
public func seedProjectFiles(fileSvc: FileService): Unit {
    println("  Seeding project source files...")
    let projectRoot = ".."
    var count: Int64 = 0

    // Create top-level directories
    fileSvc.createDirectory("/", "project-source")

    // Seed key project files
    let filesToSeed = ArrayList<(String, String)>()

    // Collect files to seed
    collectProjectFiles(projectRoot, filesToSeed)

    for (item in filesToSeed) {
        let (relativePath, fullPath) = item
        try {
            let data = readFileBytes(fullPath)
            if (data.size > 0 && data.size < 5 * 1024 * 1024) {
                let contentType = guessContentType(relativePath)
                // Extract directory parts and file name
                let parts = splitPath(relativePath)
                let dirPath = parts[0]
                let fileName = parts[1]

                // Ensure parent directories exist
                ensureDirectories(fileSvc, "/project-source", dirPath)

                let parentPath = if (dirPath.size == 0) {
                    "/project-source"
                } else {
                    "/project-source/${dirPath}"
                }
                fileSvc.uploadFile(parentPath, fileName, data, contentType)
                count += 1
            }
        } catch (ex: Exception) {
            // Skip files that can't be read
        }
    }
    println("  Seeded ${count} project source files")
}

func collectProjectFiles(root: String, result: ArrayList<(String, String)>): Unit {
    // Seed specific important directories
    let dirs = ["s3client/src", "s3client/src/core", "s3client/src/util",
                "example/src", "cdrive/src", "cdrive/src/dao", "cdrive/src/service",
                "cdrive/src/route", "cdrive/src/util", "cdrive/src/web", "cdrive/sql",
                "cdrive/static"]

    // Seed root files
    let rootFiles = ["README.md", "Update.md"]
    for (f in rootFiles) {
        let fullPath = "${root}/${f}"
        if (isFileExists(fullPath)) {
            result.add((f, fullPath))
        }
    }

    // Seed config files
    let configFiles = ["s3client/cjpm.toml", "example/cjpm.toml", "cdrive/cjpm.toml",
                       "cdrive/docker-compose.yml"]
    for (f in configFiles) {
        let fullPath = "${root}/${f}"
        if (isFileExists(fullPath)) {
            result.add((f, fullPath))
        }
    }

    // Seed source files from directories
    for (d in dirs) {
        let dirPath = "${root}/${d}"
        try {
            let entries = Directory.readFrom(Path(dirPath))
            for (entry in entries) {
                let name = entry.name
                let ext = getExtension(name)
                if (ext == "cj" || ext == "toml" || ext == "sql" || ext == "sh" ||
                    ext == "md" || ext == "html" || ext == "yml" || ext == "yaml") {
                    let fullPath = "${dirPath}/${name}"
                    let relativePath = "${d}/${name}"
                    if (isFileExists(fullPath)) {
                        result.add((relativePath, fullPath))
                    }
                }
            }
        } catch (_: Exception) {
            // Directory doesn't exist yet, skip
        }
    }

    // Also seed shell scripts
    let scripts = ["example/start-server.sh", "example/test-client.sh", "cdrive/start.sh"]
    for (f in scripts) {
        let fullPath = "${root}/${f}"
        if (isFileExists(fullPath)) {
            result.add((f, fullPath))
        }
    }
}

func readFileBytes(path: String): Array<Byte> {
    return File.readFrom(Path(path))
}

func isFileExists(path: String): Bool {
    try {
        let p = Path(path)
        return exists(p) && !p.isDirectory()
    } catch (_: Exception) {
        return false
    }
}

func getExtension(name: String): String {
    let bytes = name.toArray()
    var lastDot: Int64 = -1
    for (i in 0..bytes.size) {
        if (bytes[i] == 46) { lastDot = i }
    }
    if (lastDot < 0 || lastDot == bytes.size - 1) { return "" }
    return String.fromUtf8(bytes[(lastDot + 1)..bytes.size])
}

func splitPath(path: String): (String, String) {
    let bytes = path.toArray()
    var lastSlash: Int64 = -1
    for (i in 0..bytes.size) {
        if (bytes[i] == 47) { lastSlash = i }
    }
    if (lastSlash < 0) {
        return ("", path)
    }
    let dir = String.fromUtf8(bytes[0..lastSlash])
    let name = String.fromUtf8(bytes[(lastSlash + 1)..bytes.size])
    return (dir, name)
}

func ensureDirectories(fileSvc: FileService, basePath: String, relativePath: String): Unit {
    if (relativePath.size == 0) { return }

    let bytes = relativePath.toArray()
    var current = basePath
    var start: Int64 = 0

    for (i in 0..bytes.size) {
        if (bytes[i] == 47) {
            if (i > start) {
                let segment = String.fromUtf8(bytes[start..i])
                fileSvc.createDirectory(current, segment)
                current = "${current}/${segment}"
            }
            start = i + 1
        }
    }
    // Last segment
    if (start < bytes.size) {
        let segment = String.fromUtf8(bytes[start..bytes.size])
        fileSvc.createDirectory(current, segment)
    }
}

func guessContentType(name: String): String {
    let ext = getExtension(name)
    if (ext == "cj") { return "text/plain; charset=utf-8" }
    if (ext == "toml") { return "text/plain; charset=utf-8" }
    if (ext == "md") { return "text/markdown; charset=utf-8" }
    if (ext == "html") { return "text/html; charset=utf-8" }
    if (ext == "css") { return "text/css; charset=utf-8" }
    if (ext == "js") { return "application/javascript; charset=utf-8" }
    if (ext == "json") { return "application/json; charset=utf-8" }
    if (ext == "sql") { return "text/sql; charset=utf-8" }
    if (ext == "sh") { return "text/x-shellscript; charset=utf-8" }
    if (ext == "yml" || ext == "yaml") { return "text/yaml; charset=utf-8" }
    if (ext == "txt") { return "text/plain; charset=utf-8" }
    if (ext == "xml") { return "application/xml; charset=utf-8" }
    if (ext == "png") { return "image/png" }
    if (ext == "jpg" || ext == "jpeg") { return "image/jpeg" }
    if (ext == "gif") { return "image/gif" }
    if (ext == "svg") { return "image/svg+xml" }
    if (ext == "pdf") { return "application/pdf" }
    if (ext == "zip") { return "application/zip" }
    return "application/octet-stream"
}
