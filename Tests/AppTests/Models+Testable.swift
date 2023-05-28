//
//  File.swift
//
//
//  Created by Nguyen Quoc Huy on 5/28/23.
//

@testable import App
import Fluent

extension User {
    static func create(name: String = "Huy", username: String = "9OSU1G02", on database: Database) throws -> User {
        let user = User(name: name, username: username)
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
