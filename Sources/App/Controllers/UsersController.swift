//
//  File.swift
//  
//
//  Created by Nguyen Quoc Huy on 5/24/23.
//

import Fluent
import Vapor

struct UsersController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let usersRoutes = routes.grouped("api", "users")
        usersRoutes.post(use: createHandler)
        usersRoutes.get(use: getAllHandler)
        usersRoutes.get(":userID", use: getHandler)
        usersRoutes.get(":userID","acronyms", use: getAcronymsHandler(_:))
    }
    
    func createHandler(_ req: Request) throws -> EventLoopFuture<User> {
        let user = try req.content.decode(User.self)
        return user.save(on: req.db).map { user }
    }
    
    func getAllHandler(_ req: Request) -> EventLoopFuture<[User]> {
        User.query(on: req.db).all()
    }
    
    func getHandler(_ req: Request) -> EventLoopFuture<User> {
        User.find(req.parameters.get("userID"), on: req.db).unwrap(or: Abort(.notFound))
    }
    
    func getAcronymsHandler(_ req: Request) -> EventLoopFuture<[Acronym]> {
        User.find(req.parameters.get("userID"), on: req.db).unwrap(or: Abort(.notFound))
            .flatMap { user in
                user.$acronyms.get(on: req.db)
            }
    }
}
