//
//  File.swift
//
//
//  Created by Nguyen Quoc Huy on 5/22/23.
//

import Fluent
import Vapor

final class Acronym: Model {
    static let schema = "acronyms"
    @Parent(key: "userID")
    var user: User
    @ID(key: .id)
    var id: UUID?

    @Field(key: "short")
    var short: String

    @Field(key: "long")
    var long: String

    @Siblings(
      through: AcronymCategoryPivot.self,
      from: \.$acronym,
      to: \.$category)
    var categories: [Category]

    init() {}

    init(id: UUID? = nil, short: String, long: String, userID: User.IDValue) {
        self.id = id
        self.short = short
        self.long = long
        self.$user.id = userID
    }

    enum CodingKeys: String, CodingKey {
        case short
        case long
    }
}

extension Acronym: Content {}
