//
//  PokemonSpeciesResponseDTO.swift
//  App
//
//  Created by Bruno Metzker on 11/04/20.
//

import Foundation
import Vapor

struct AllPokemonSpeciesResponseDTO: Content {
    let species: [PokemonSpecies]
}
