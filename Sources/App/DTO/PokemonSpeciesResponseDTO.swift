import Vapor

struct PokemonSpeciesResponseDTO: Content, Adaptable {
    typealias To = PokemonSpecies
    
    let id: Int
    let moves: [LegacyPokemonMove]
    let name: String
    let sprites: LegacyPokemonImage
    let types: [LegacyPokemonType]
    
    func adapt() -> PokemonSpecies {
        let pokemonId = self.id
        let pokemonName = self.name

        let pokemonMoves = self.moves.map { legacyPokemonMove -> PokemonMove in
            let moveId = Int.init(legacyPokemonMove.move.url.split(separator: "/").last ?? "0")
            let moveName = legacyPokemonMove.move.name

            return PokemonMove(id: moveId!, name: moveName, type: nil)
        }

        let pokemonSprites = [self.sprites.back_default, self.sprites.back_female, self.sprites.back_shiny, self.sprites.back_shiny_female, self.sprites.front_default, self.sprites.front_female, self.sprites.front_shiny, self.sprites.front_shiny_female]

        let pokemonTypes = self.types.map { legacyPokemonType -> PokemonType in
            let typeId = Int.init(legacyPokemonType.type.url.split(separator: "/").last ?? "0")
            let typeName = legacyPokemonType.type.name

            return PokemonType(id: typeId!, name: typeName, doubleDamageFrom: nil, doubleDamageTo: nil, halfDamageFrom: nil, halfDamageTo: nil, noDamageFrom: nil, noDamageTo: nil)
        }

        return PokemonSpecies(id: pokemonId, name: pokemonName, moves: pokemonMoves, sprites: pokemonSprites, types: pokemonTypes)
    }
}
