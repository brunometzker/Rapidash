import Vapor

/// Register your application's routes here.
public func routes(_ router: Router) throws {
    router.get("pokemon", "species", "all") { req -> Future<Response> in
        let speciesController = try req.make(PokemonSpeciesController.self)
        
        return try speciesController.getAllSpecies(req)
    }
    
    router.get("pokemon", "species", Int.parameter) { req -> Future<Response> in
        let speciesController = try req.make(PokemonSpeciesController.self)
        
        return try speciesController.getSpeciesById(req)
    }
    
    router.get("pokemon", "type", Int.parameter) { req -> Future<Response> in
        let typeController = try req.make(PokemonTypeController.self)
        
        return try typeController.getTypeById(req)
    }
}
