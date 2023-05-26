//
//  File.swift
//
//
//  Created by Nguyen Quoc Huy on 5/25/23.
//

import Fluent

struct CreateCategory: Migration {
    func prepare(on database: FluentKit.Database) -> NIOCore.EventLoopFuture<Void> {
        database.schema("categories")
            .id()
            .field("name", .string, .required)
            .create()
    }

    func revert(on database: FluentKit.Database) -> NIOCore.EventLoopFuture<Void> {
        database.schema("categories").delete()
    }
}
