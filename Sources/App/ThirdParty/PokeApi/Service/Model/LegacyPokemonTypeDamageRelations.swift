import Vapor

struct LegacyPokemonTypeDamageRelations: Content {
    let double_damage_from: [LegacyPokemonTypeDetails]?
    let double_damage_to: [LegacyPokemonTypeDetails]?
    let half_damage_from: [LegacyPokemonTypeDetails]?
    let half_damage_to: [LegacyPokemonTypeDetails]?
    let no_damage_from: [LegacyPokemonTypeDetails]?
    let no_damage_to: [LegacyPokemonTypeDetails]?
}
