import Vapor
import Redis

/// Called before your application initializes.
public func configure(_ config: inout Config, _ env: inout Environment, _ services: inout Services) throws {
    // Register providers first
    try services.register(RedisProvider())
    
    var redisConfig = RedisClientConfig()
    redisConfig.hostname = Environment.get("REDIS_HOST") ?? K.Services.Redis.host
    redisConfig.port = K.Services.Redis.port
    let redis = try RedisDatabase(config: redisConfig)
    
    var databases = DatabasesConfig()
    databases.add(database: redis, as: .redis)
    
    services.register(databases)
    services.register(KeyedCache.self) { container in
        try container.keyedCache(for: .redis)
    }
    
    config.prefer(DatabaseKeyedCache<ConfiguredDatabase<RedisDatabase>>.self, for: KeyedCache.self)
    
    services.register(PokeApiService.self) { container in
        return PokeApiService(client: try container.client())
    }
    
    services.register(PokemonSpeciesService.self) { container in
        return PokemonSpeciesService(keyedCache: try container.make(KeyedCache.self), pokeApi: try container.make(PokeApiService.self))
    }
    
    services.register(PokemonSpeciesController.self) { container in
        return PokemonSpeciesController(speciesService: try container.make(PokemonSpeciesService.self))
    }
    
    // Register routes to the router
    let router = EngineRouter.default()
    try routes(router)
    services.register(router, as: Router.self)

    // Register middleware
    var middlewares = MiddlewareConfig() // Create _empty_ middleware config
    // middlewares.use(FileMiddleware.self) // Serves files from `Public/` directory
    middlewares.use(ErrorMiddleware.self) // Catches errors and converts to HTTP response
    services.register(middlewares)
}
