//
//  File.swift
//  App
//
//  Created by Bruno Metzker on 10/04/20.
//

import Foundation
import Vapor

class PokeApiService: PokeApiProxy, Service {
    let client: Client
    
    init(client: Client) {
        self.client = client
    }
    
    func generationById(id: Int) -> Future<ResponseDTO<GenerationsResponseDTO, LocalizedErrorMessageResponseDTO>> {
        return self.client.fetch(request: { (client: Client) -> EventLoopFuture<Response> in
            return client.get("https://\(K.Services.PokeAPI.host)/\(K.Services.PokeAPI.version)/\(K.Services.PokeAPI.generationRoute)/\(id)")
        }, dataType: GenerationsResponseDTO.self, failedWhenStatusIsOneOf: [500], errorType: LocalizedErrorMessageResponseDTO.self)
    }
    
    func speciesById(id: Int) -> Future<ResponseDTO<LegacyPokemonSpeciesResponseDTO, LocalizedErrorMessageResponseDTO>> {
        return self.client.fetch(request: { (client) -> Future<Response> in
            return client.get("https://\(K.Services.PokeAPI.host)/\(K.Services.PokeAPI.version)/\(K.Services.PokeAPI.speciesRoute)/\(id)")
        }, dataType: LegacyPokemonSpeciesResponseDTO.self, failedWhenStatusIsOneOf: [500], errorType: LocalizedErrorMessageResponseDTO.self)
    }
    
    func typeById(id: Int) -> Void {
        
    }
}
