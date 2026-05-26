package cdrive.web

import std.fs.*
import std.io.*

public func loadHtmlPage(): String {
    let bytes = File.readFrom(Path("static/index.html"))
    return String.fromUtf8(bytes)
}
