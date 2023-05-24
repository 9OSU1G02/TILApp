import Fluent
import Vapor

func routes(_ app: Application) throws {
    app.get { req in
        "It works!"
    }

    app.get("hello") { req -> String in
        "Hello, world!"
    }
    let acronymsController = AcronymsController()
    try app.register(collection: acronymsController)
    let usersController = UsersController()
    try app.register(collection: usersController)
}
