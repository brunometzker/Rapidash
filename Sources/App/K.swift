//
//  File.swift
//  
//
//  Created by Bruno Metzker on 06/04/20.
//

import Foundation

struct K {
    struct Services {
        struct Redis {
            static let host = "localhost"
            static let port = 6379
        }
        
        struct PokeAPI {
            static let host = "pokeapi.co/api"
            static let version = "v2"
            static let speciesRoute = "/pokemon"
            static let typeRoute = "/type"
            static let generationRoute = "/generation"
            static let generationIdPlaceholder = "${generationId}"
            static let generationCacheKey = "pokemon.generation.\(K.Services.PokeAPI.generationIdPlaceholder)"
            static let speciesIdPlaceholder = "${speciesId}"
            static let speciesCacheKey = "pokemon.species.\(K.Services.PokeAPI.speciesIdPlaceholder)"
            static let typeIdPlaceholder = "${typeId}"
            static let typeCacheKey = "pokemon.type.\(K.Services.PokeAPI.typeIdPlaceholder)"
        }
        
        struct PokeResBastionBot {
            static let host = "pokeres.bastionbot.org"
            static let pokemonImagePath = "/images/pokemon"
            static let imageExtension = "png"
        }
    }
}
