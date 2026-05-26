package cdrive

import cdrive.dao.*
import cdrive.service.*
import cdrive.route.*
import cdrive.util.*
import cdrive.web.*
import stdx.net.http.*
import std.convert.*

main(): Unit {
    let dbUrl = envOr("CDRIVE_DB_URL",
        "opengauss://gaussdb:Root%40123456@127.0.0.1:15432/omm?sslmode=disable")
    let s3Endpoint = envOr("CDRIVE_S3_ENDPOINT", "http://127.0.0.1:9000")
    let s3AccessKey = envOr("CDRIVE_S3_ACCESS_KEY", "sunrise2026")
    let s3SecretKey = envOr("CDRIVE_S3_SECRET_KEY", "sunrise2026")
    let s3Bucket = envOr("CDRIVE_S3_BUCKET", "cdrive")
    let host = envOr("CDRIVE_HOST", "0.0.0.0")
    let port = UInt16(parseInt64Or(envOr("CDRIVE_PORT", "8080"), 8080))

    println("╔══════════════════════════════════════════╗")
    println("║          CDrive Cloud Storage            ║")
    println("╚══════════════════════════════════════════╝")
    println()
    println("  DB  : ${dbUrl}")
    println("  S3  : ${s3Endpoint}")
    println("  URL : http://${host}:${port}")
    println()

    // Initialize services
    let db = DbConnector(dbUrl)
    let storage = StorageService(s3Endpoint, s3AccessKey, s3SecretKey, s3Bucket)
    let fileSvc = FileService(db, storage)

    // Load HTML page
    let htmlPage = loadHtmlPage()

    // Seed project source files
    let seedDone = envOr("CDRIVE_SKIP_SEED", "false")
    if (seedDone != "true") {
        try {
            seedProjectFiles(fileSvc)
        } catch (ex: Exception) {
            println("  Warning: Seed failed: ${ex}")
        }
    }

    // Create and configure server
    let server = ServerBuilder().addr(host).port(port).build()

    // Serve frontend
    server.distributor.register("/", {
        ctx => ctx.responseBuilder.status(200)
            .header("content-type", "text/html; charset=utf-8")
            .body(htmlPage)
    })

    // Register API routes
    registerFileRoutes(server, fileSvc)

    println("  Server started at http://${host}:${port}")
    println("  Press Ctrl+C to stop")
    println()

    server.serve()
}
