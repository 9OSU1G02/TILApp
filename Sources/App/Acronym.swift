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
  
    @ID(key: .id)
    var id: UUID?
  
    @Field(key: "short")
    var short: String
  
    @Field(key: "long")
    var long: String
  
    init() {}
  
    init(id: UUID? = nil, short: String, long: String) {
        self.id = id
        self.short = short
        self.long = long
    }

    enum CodingKeys: String, CodingKey {
        case short
        case long
    }
}

extension Acronym: Content {}
