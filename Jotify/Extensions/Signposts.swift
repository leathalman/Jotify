//
//  Signposts.swift
//  Jotify
//
//  Thin wrapper around os_signpost for profiling transitions and setup
//  steps in Instruments. Open Instruments → "os_signpost" (or the
//  Animation Hitches template, which surfaces signposts in the same
//  timeline), pick the "com.jotify.perf" subsystem, and the named
//  intervals below will appear as labeled ranges.
//

import os

enum Signposts {
    static let log = OSLog(subsystem: "com.jotify.perf", category: "transitions")

    @discardableResult
    static func begin(_ name: StaticString) -> OSSignpostID {
        let id = OSSignpostID(log: log)
        os_signpost(.begin, log: log, name: name, signpostID: id)
        return id
    }

    static func end(_ name: StaticString, id: OSSignpostID) {
        os_signpost(.end, log: log, name: name, signpostID: id)
    }

    static func measure<T>(_ name: StaticString, _ work: () throws -> T) rethrows -> T {
        let id = begin(name)
        defer { end(name, id: id) }
        return try work()
    }
}
