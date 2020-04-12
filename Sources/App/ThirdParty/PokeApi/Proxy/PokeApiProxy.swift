//
//  File.swift
//  App
//
//  Created by Bruno Metzker on 10/04/20.
//

import Foundation
import Vapor

protocol PokeApiProxy {
    func generationById(id: Int) -> Future<ResponseDTO<GenerationsResponseDTO, LocalizedErrorMessageResponseDTO>>
    func speciesById(id: Int) -> Future<ResponseDTO<LegacyPokemonSpeciesResponseDTO, LocalizedErrorMessageResponseDTO>>
    func typeById(id: Int) -> Future<ResponseDTO<LegacyPokemonTypeResponseDTO, LocalizedErrorMessageResponseDTO>>
}
