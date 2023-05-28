//
//  File.swift
//  
//
//  Created by Nguyen Quoc Huy on 5/28/23.
//

import XCTVapor
import App

extension Application {
    static func testable() throws -> Application {
        let app = Application(.testing)
        try configure(app)
        try app.autoRevert().wait()
        try app.autoMigrate().wait()
        return app
    }
}
