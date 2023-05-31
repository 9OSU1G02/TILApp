import Vapor
import Fluent

final class Token: Model, Content {
  static let schema = "tokens"

  @ID
  var id: UUID?

  @Field(key: "value")
  var value: String

  @Parent(key: "userID")
  var user: User

  init() {}

  init(id: UUID? = nil, value: String, userID: User.IDValue) {
    self.id = id
    self.value = value
    self.$user.id = userID
  }
}

extension Token {
  // 1
  static func generate(for user: User) throws -> Token {
    // 2
    let random = [UInt8].random(count: 16).base64
    // 3
    return try Token(value: random, userID: user.requireID())
  }
}

extension Token: ModelTokenAuthenticatable {
    static let valueKey = \Token.$value
    static let userKey = \Token.$user
    var isValid: Bool {
        return true
    }
}
