import Fluent
import FluentPostgresDriver
import Vapor

// configures your application
public func configure(_ app: Application) throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

    app.databases.use(.postgres(
        hostname: "localhost",
        port: Environment.get("DATABASE_PORT").flatMap(Int.init(_:)) ?? PostgresConfiguration.ianaPortNumber,
        username: "postgres",
        password: "",
        database: "vapor_database"
    ), as: .psql)

    app.migrations.add(CreateAcronym())
    app.logger.logLevel = .debug
    try app.autoMigrate().wait()
    // register routes
    try routes(app)
}
