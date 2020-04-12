import Vapor

struct PokemonSpecies: Content {
    let id: Int
    let name: String
    let moves: [PokemonMove]?
    let sprites: [String?]?
    let types: [PokemonType]?
    let defaultImage: String?
}
