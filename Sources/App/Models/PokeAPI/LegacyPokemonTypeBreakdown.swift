import Vapor

struct LegacyPokemonTypeBreakdown: Content {
    let id: Int
    let name: String
    let damage_relations: LegacyPokemonTypeDamageRelations
}
