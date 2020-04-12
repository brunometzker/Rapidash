import Vapor

struct PokemonMove: Content {
    let id: Int
    let name: String
    let type: PokemonType?
}
