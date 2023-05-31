//
//  File.swift
//
//
//  Created by Nguyen Quoc Huy on 5/28/23.
//

@testable import App
import Fluent
import Vapor

extension User {
    static func create(
        name: String = "Luke",
        username: String? = nil,
        on database: Database
    ) throws -> User {
        let createUsername: String
        // 2
        if let suppliedUsername = username {
            createUsername = suppliedUsername
            // 3
        } else {
            createUsername = UUID().uuidString
        }

        // 4
        let password = try Bcrypt.hash("password")
        let user = User(
            name: name,
            username: createUsername,
            password: password
        )
        try user.save(on: database).wait()
        return user
    }
}

extension Acronym {
    static func create(short: String = "TIL", long: String = "Today I Learned", user: User? = nil, on database: Database) throws -> Acronym {
        var acronymsUser = user
        if acronymsUser == nil {
            acronymsUser = try User.create(on: database)
        }
        let acronym = Acronym(short: short, long: long, userID: acronymsUser!.id!)
        try acronym.save(on: database).wait()
        return acronym
    }
}
