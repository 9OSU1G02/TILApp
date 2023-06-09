//
//  File.swift
//
//
//  Created by Nguyen Quoc Huy on 5/25/23.
//

import Vapor

struct CategoriesController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let categoriesRoutes = routes.grouped("api", "categories")
        categoriesRoutes.get(use: getAllHandler(_:))
        categoriesRoutes.get(":categoryID", use: getHandler)
        categoriesRoutes.get(":categoryID", "acronyms", use: getAcronymsHandler)
        
        let tokenAuthMiddleware = Token.authenticator()
        let tokenGuardMiddleware = Token.guardMiddleware()
        let tokenAuthGroup = categoriesRoutes.grouped(tokenAuthMiddleware, tokenGuardMiddleware)
        tokenAuthGroup.post(use: createHandler)
    }
    
    func createHandler(_ req: Request) throws -> EventLoopFuture<Category> {
        let category = try req.content.decode(Category.self)
        return category.save(on: req.db).map { category }
    }
    
    func getAllHandler(_ req: Request) -> EventLoopFuture<[Category]> {
        Category.query(on: req.db).all()
    }
    
    func getHandler(_ req: Request) -> EventLoopFuture<Category> {
        Category.find(req.parameters.get("categoryID"), on: req.db).unwrap(or: Abort(.notFound))
    }
    
    func getAcronymsHandler(_ req: Request) -> EventLoopFuture<[Acronym]> {
        Category.find(req.parameters.get("categoryID"), on: req.db).unwrap(or: Abort(.notFound))
            .flatMap { category in
                category.$acronyms.query(on: req.db).all()
            }
    }
}
