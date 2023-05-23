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

    app.get("api", "acronyms") { req -> EventLoopFuture<[Acronym]> in
        Acronym.query(on: req.db).all()
    }

    app.get("api", "acronyms", ":acronymID") { req -> EventLoopFuture<Acronym> in
        Acronym.find(req.parameters.get("acronymID"), on: req.db)
            .unwrap(or: Abort(.notFound))
    }

    app.put("api", "acronyms", ":acronymID") { req -> EventLoopFuture<Acronym> in
        let updatedAcronym = try req.content.decode(Acronym.self)
        return Acronym.find(req.parameters.get("acronymID"), on: req.db).unwrap(or: Abort(.notFound)).flatMap { acronym in
            acronym.short = updatedAcronym.short
            acronym.long = updatedAcronym.long
            return acronym.save(on: req.db).map { acronym }
        }
    }

    app.delete("api", "acronyms", ":acronymID") { request -> EventLoopFuture<HTTPStatus> in
        Acronym.find(request.parameters.get("acronymID"), on: request.db).unwrap(or: Abort(.notFound)).flatMap { acronym in
            acronym.delete(on: request.db).transform(to: .noContent)
        }
    }

    app.get("api", "acronyms", "search") { req -> EventLoopFuture<[Acronym]> in
        guard let searchTerm = req.query[String.self, at: "term"] else {
            throw Abort(.badRequest)
        }

        return Acronym.query(on: req.db).group(.or) { or in
            or.filter(\.$short == searchTerm)
            or.filter(\.$long == searchTerm)
        }.all()
    }

    app.get("api", "acronyms", "first") { req -> EventLoopFuture<Acronym> in
        Acronym.query(on: req.db).first().unwrap(or: Abort(.notFound))
    }
    app.get("api", "acronyms", "sorted") { req in
        Acronym.query(on: req.db).sort(\.$short, .ascending).all()
    }
//    try app.register(collection: TodoController())
}
