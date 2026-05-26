package cdrive.route

import cdrive.service.*
import cdrive.util.*
import cdrive.dao.*
import stdx.net.http.*
import stdx.encoding.url.*

public func registerFileRoutes(server: Server, fileSvc: FileService) {
    // List files in directory
    server.distributor.register("/api/files", {
        ctx =>
            if (ctx.request.method == "GET") {
                let parentPath = ctx.request.url.queryForm.get("path") ?? "/"
                jsonResponse(ctx, fileSvc.listFiles(parentPath))
            } else {
                notAllowed(ctx)
            }
    })

    // Upload file (accepts raw body with headers for metadata)
    server.distributor.register("/api/upload", {
        ctx =>
            if (ctx.request.method == "POST") {
                let parentPath = ctx.request.url.queryForm.get("path") ?? "/"
                let fileName = ctx.request.url.queryForm.get("name") ?? "unnamed"
                let decodedName = decodeURIComponent(fileName)
                let contentType = ctx.request.headers.getFirst("x-content-type") ?? "application/octet-stream"
                let data = readBodyBytes(ctx)
                if (data.size == 0) {
                    jsonResponse(ctx, jsonFail("Empty file"))
                } else {
                    try {
                        let result = fileSvc.uploadFile(parentPath, decodedName, data, contentType)
                        jsonResponse(ctx, result)
                    } catch (ex: Exception) {
                        jsonResponse(ctx, jsonFail("Upload failed: ${ex}"))
                    }
                }
            } else {
                notAllowed(ctx)
            }
    })

    // Create directory
    server.distributor.register("/api/mkdir", {
        ctx =>
            if (ctx.request.method == "POST") {
                let f = parseForm(readBody(ctx))
                let parentPath = f.get("path") ?? "/"
                let dirName = f.get("name") ?? ""
                if (dirName.size == 0) {
                    jsonResponse(ctx, jsonFail("Directory name is required"))
                } else {
                    try {
                        jsonResponse(ctx, fileSvc.createDirectory(parentPath, dirName))
                    } catch (ex: Exception) {
                        jsonResponse(ctx, jsonFail("Failed: ${ex}"))
                    }
                }
            } else {
                notAllowed(ctx)
            }
    })

    // Delete file/directory
    server.distributor.register("/api/delete", {
        ctx =>
            if (ctx.request.method == "POST") {
                let f = parseForm(readBody(ctx))
                let id = parseInt64Or(f.get("id") ?? "0", 0)
                if (id == 0) {
                    jsonResponse(ctx, jsonFail("Invalid file ID"))
                } else {
                    try {
                        jsonResponse(ctx, fileSvc.deleteFile(id))
                    } catch (ex: Exception) {
                        jsonResponse(ctx, jsonFail("Delete failed: ${ex}"))
                    }
                }
            } else {
                notAllowed(ctx)
            }
    })

    // Download file
    server.distributor.register("/api/download", {
        ctx =>
            if (ctx.request.method == "GET") {
                let id = parseInt64Or(ctx.request.url.queryForm.get("id") ?? "0", 0)
                if (id == 0) {
                    errorResponse(ctx, 400, "Invalid file ID")
                } else {
                    try {
                        let (bytes, contentType, name) = fileSvc.downloadFile(id)
                        if (name.size == 0) {
                            errorResponse(ctx, 404, "File not found")
                        } else {
                            ctx.responseBuilder
                                .status(200)
                                .header("content-type", contentType)
                                .header("content-disposition", "attachment; filename=\"${name}\"")
                                .body(bytes)
                        }
                    } catch (ex: Exception) {
                        errorResponse(ctx, 500, "Download failed")
                    }
                }
            } else {
                notAllowed(ctx)
            }
    })

    // Preview file (inline display)
    server.distributor.register("/api/preview", {
        ctx =>
            if (ctx.request.method == "GET") {
                let id = parseInt64Or(ctx.request.url.queryForm.get("id") ?? "0", 0)
                if (id == 0) {
                    errorResponse(ctx, 400, "Invalid file ID")
                } else {
                    try {
                        let (bytes, contentType, name) = fileSvc.downloadFile(id)
                        if (name.size == 0) {
                            errorResponse(ctx, 404, "File not found")
                        } else {
                            ctx.responseBuilder
                                .status(200)
                                .header("content-type", contentType)
                                .header("content-disposition", "inline; filename=\"${name}\"")
                                .body(bytes)
                        }
                    } catch (ex: Exception) {
                        errorResponse(ctx, 500, "Preview failed")
                    }
                }
            } else {
                notAllowed(ctx)
            }
    })

    // Rename file
    server.distributor.register("/api/rename", {
        ctx =>
            if (ctx.request.method == "POST") {
                let f = parseForm(readBody(ctx))
                let id = parseInt64Or(f.get("id") ?? "0", 0)
                let newName = f.get("name") ?? ""
                if (id == 0 || newName.size == 0) {
                    jsonResponse(ctx, jsonFail("Invalid parameters"))
                } else {
                    try {
                        jsonResponse(ctx, fileSvc.renameFile(id, newName))
                    } catch (ex: Exception) {
                        jsonResponse(ctx, jsonFail("Rename failed: ${ex}"))
                    }
                }
            } else {
                notAllowed(ctx)
            }
    })

    // Search files
    server.distributor.register("/api/search", {
        ctx =>
            if (ctx.request.method == "GET") {
                let query = ctx.request.url.queryForm.get("q") ?? ""
                if (query.size == 0) {
                    jsonResponse(ctx, "[]")
                } else {
                    jsonResponse(ctx, fileSvc.searchFiles(query))
                }
            } else {
                notAllowed(ctx)
            }
    })

    // Get stats
    server.distributor.register("/api/stats", {
        ctx =>
            if (ctx.request.method == "GET") {
                try {
                    jsonResponse(ctx, fileSvc.getStats())
                } catch (ex: Exception) {
                    jsonResponse(ctx, "{\"totalFiles\":0,\"totalDirs\":0,\"totalSize\":0}")
                }
            } else {
                notAllowed(ctx)
            }
    })

    // Get file info
    server.distributor.register("/api/file", {
        ctx =>
            if (ctx.request.method == "GET") {
                let id = parseInt64Or(ctx.request.url.queryForm.get("id") ?? "0", 0)
                if (id == 0) {
                    jsonResponse(ctx, "[]")
                } else {
                    jsonResponse(ctx, fileSvc.getFileInfo(id))
                }
            } else {
                notAllowed(ctx)
            }
    })
}

func decodeURIComponent(s: String): String {
    try {
        return URL.parse("http://x/?n=${s}").queryForm.get("n") ?? s
    } catch (_: Exception) {
        return s
    }
}
