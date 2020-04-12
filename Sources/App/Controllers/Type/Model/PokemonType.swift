import Vapor

struct PokemonType: Content {
    let id: Int
    let name: String
    let doubleDamageFrom: [String]?
    let doubleDamageTo: [String]?
    let halfDamageFrom: [String]?
    let halfDamageTo: [String]?
    let noDamageFrom: [String]?
    let noDamageTo: [String]?
}
