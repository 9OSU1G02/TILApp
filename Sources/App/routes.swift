import Fluent
import Vapor

func routes(_ app: Application) throws {
    app.get { req in
        "It works!"
    }

    app.get("hello") { req -> String in
        "Hello, world!"
    }

    app.post("api", "acronyms") { req -> EventLoopFuture<Acronym> in
        let acronym = try req.content.decode(Acronym.self)
        return acronym.save(on: req.db).map { acronym }
    }
//    try app.register(collection: TodoController())
}
