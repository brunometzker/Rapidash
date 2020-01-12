import Vapor

/// Register your application's routes here.
public func routes(_ router: Router) throws {
    let pokemonSpeciesController = PokemonSpeciesController()
    let pokemonTypeController = PokemonTypeController()
    
    router.get("pokemon", "species", "all", use: pokemonSpeciesController.getAllSpecies)
    router.get("pokemon", "species", Int.parameter, use: pokemonSpeciesController.getSpeciesById)
    router.get("pokemon", "type", Int.parameter, use: pokemonTypeController.getTypeById)
}
