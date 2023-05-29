//
//  File.swift
//
//
//  Created by Nguyen Quoc Huy on 5/29/23.
//

import Leaf
import Vapor

struct WebsiteController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        routes.get(use: indexHandler(_:))
        routes.get("acronyms", ":acronymID", use: acronymHandler)
    }

    func indexHandler(_ req: Request)
        -> EventLoopFuture<View>
    {
        // 1
        Acronym.query(on: req.db).all().flatMap { acronyms in
            // 2
            let acronymsData = acronyms.isEmpty ? nil : acronyms
            let context = IndexContext(
                title: "Home page",
                acronyms: acronymsData)
            return req.view.render("index", context)
        }
    }

    func acronymHandler(_ req: Request)
        -> EventLoopFuture<View>
    {
        // 2
        Acronym.find(req.parameters.get("acronymID"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { acronym in
                // 3
                acronym.$user.get(on: req.db).flatMap { user in
                    // 4
                    let context = AcronymContext(
                        title: acronym.short,
                        acronym: acronym,
                        user: user)
                    return req.view.render("acronym", context)
                }
            }
    }
}

struct IndexContext: Encodable {
    let title: String
    let acronyms: [Acronym]?
}

struct AcronymContext: Encodable {
    let title: String
    let acronym: Acronym
    let user: User
}
