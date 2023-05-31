//
//  File.swift
//
//
//  Created by Nguyen Quoc Huy on 5/24/23.
//

import Fluent

struct CreateUser: Migration {
    func prepare(on database: FluentKit.Database) -> NIOCore.EventLoopFuture<Void> {
        database.schema("users").id().field("name", .string, .required).field("password", .string, .required).field("username", .string, .required).unique(on: "username").create()
    }

    func revert(on database: FluentKit.Database) -> NIOCore.EventLoopFuture<Void> {
        database.schema("users").delete()
    }
}
