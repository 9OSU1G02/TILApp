//
//  File.swift
//
//
//  Created by Nguyen Quoc Huy on 5/28/23.
//

@testable import App
import XCTVapor

final class AcronymTests: XCTestCase {
    let short = "WTF"
    let long = "alice"
    let acronymsURI = "api/acronyms"
    var app: Application!

    override func setUpWithError() throws {
        app = try Application.testable()
    }

    override func tearDownWithError() throws {
        app.shutdown()
    }
}
