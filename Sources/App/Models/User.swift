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
    @Field(key: "password")
    var password: String

    @Field(key: "name")
    var name: String
    @Field(key: "username")
    var username: String

    @Children(for: \Acronym.$user)
    var acronyms: [Acronym]

    init() {}
    init(id: UUID? = nil, name: String, username: String, password: String) {
        self.id = id
        self.name = name
        self.username = username
        self.password = password
    }

    final class Public: Content {
        var id: UUID?
        var name: String
        var username: String

        init(id: UUID?, name: String, username: String) {
            self.id = id
            self.name = name
            self.username = username
        }
    }
}

extension User {
    func convertToPublic() -> User.Public {
        return User.Public(id: id, name: name, username: username)
    }
}

extension EventLoopFuture where Value: User {
    func convertToPublic() -> EventLoopFuture<User.Public> {
        return self.map { user in
            user.convertToPublic()
        }
    }
}

extension Collection where Element: User {
    // 6
    func convertToPublic() -> [User.Public] {
        // 7
        return map { $0.convertToPublic() }
    }
}

// 8
extension EventLoopFuture where Value == [User] {
    // 9
    func convertToPublic() -> EventLoopFuture<[User.Public]> {
        // 10
        return map { $0.convertToPublic() }
    }
}

extension User: ModelAuthenticatable {
    static var usernameKey: KeyPath<User, Field<String>> {
        \User.$username
    }
    
    static var passwordHashKey: KeyPath<User, Field<String>> {
        \User.$password
    }
    
    func verify(password: String) throws -> Bool {
        try Bcrypt.verify(password, created: self.password)
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

@propertyWrapper
struct Uppercased {
    var value: String

    var wrappedValue: String {
        get {
            value.uppercased()
        }
        set {
            value = newValue
        }
    }

    init(wrappedValue: String) {
        self.value = wrappedValue
    }
}
