import Vapor

struct GenerationsResponseDTO: Content, Adaptable {
    typealias To = [PokemonSpecies]
    
    let pokemon_species: [LegacyPokemonSpecies]
    
    func adapt() -> [PokemonSpecies] {
        return self.pokemon_species.map { legacySpecies -> PokemonSpecies in
            let url = legacySpecies.url
            let id = Int.init(url.split(separator: "/").last ?? "0")
            let name = legacySpecies.name
            
            let defaultImage = "https://\(K.Services.PokeResBastionBot.host)\(K.Services.PokeResBastionBot.pokemonImagePath)/\(id ?? 0).\(K.Services.PokeResBastionBot.imageExtension)"
            
            return PokemonSpecies(id: id!, name: name, moves: nil, sprites: nil, types: nil, defaultImage: defaultImage)
        }
    }
}
