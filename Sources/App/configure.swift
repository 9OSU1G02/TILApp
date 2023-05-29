import Fluent
import FluentPostgresDriver
import Vapor
import Leaf

// configures your application
public func configure(_ app: Application) throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
    let databaseName: String
    let databasePort: Int
    if (app.environment == .testing) {
        databaseName = "TILApp-Test"
        databasePort = 5433
    } else {
        databaseName = "TILApp"
        databasePort = 5432
    }
    
    app.databases.use(.postgres(
      hostname: Environment.get("DATABASE_HOST")
        ?? "localhost",
      port: databasePort,
      username: Environment.get("DATABASE_USERNAME")
        ?? "postgres",
      password: Environment.get("DATABASE_PASSWORD")
        ?? "",
      database: Environment.get("DATABASE_NAME")
        ?? databaseName
    ), as: .psql)
    
    app.migrations.add(CreateUser())
    app.migrations.add(CreateAcronym())
    app.migrations.add(CreateCategory())
    app.migrations.add(CreateAcronymCategoryPivot())
    app.logger.logLevel = .debug
    try app.autoMigrate().wait()
    app.views.use(.leaf)
    // register routes
    try routes(app)
}
