//
//  File.swift
//
//
//  Created by Nguyen Quoc Huy on 5/24/23.
//

import Fluent
import Vapor

final class User: Model, Content {
    static let schema = "users"
    @ID(key: .id)
    var id: UUID?

    @Field(key: "name")
    var name: String
    @Field(key: "username")
    var username: String
    
    @Children(for: \Acronym.$user)
    var acronyms: [Acronym]
    
    init() {}
    init(id: UUID? = nil, name: String, username: String) {
        self.id = id
        self.name = name
        self.username = username
    }
}

final class Student {
    @Uppercased(wrappedValue: "haha")
    var name: String
    init(name: String) {
        self.name = name
    }
    init() {
        print("---> default")
    }
}

@propertyWrapper // 1
struct Uppercased {
    var value: String // 2
    
    var wrappedValue: String {    // 3
        get {
            value.uppercased()
        }
        set {
            value = newValue
        }
    }
        // 4
    init(wrappedValue: String)  {
        self.value = wrappedValue
    }
}
