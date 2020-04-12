import Vapor

class PokemonSpeciesService: Service {
    let keyedCache: KeyedCache
    let pokeApi: PokeApiProxy
    
    init(keyedCache: KeyedCache, pokeApi: PokeApiProxy) {
        self.keyedCache = keyedCache
        self.pokeApi = pokeApi
    }
    
    public func allSpeciesFrom(generations: [Int], eventLoop: EventLoop) -> Future<ResponseDTO<AllPokemonSpeciesResponseDTO, LocalizedErrorMessageResponseDTO>> {
        let responseByGeneration = generations.map { generation -> Future<ResponseDTO<GenerationsResponseDTO, LocalizedErrorMessageResponseDTO>>  in
            let cacheKey = K.Services.PokeAPI.generationCacheKey.replacingOccurrences(of: K.Services.PokeAPI.generationIdPlaceholder, with: "\(generation)")
            
            return self.keyedCache.get(cacheKey, as: GenerationsResponseDTO.self).then { (cachedGeneration) -> Future<ResponseDTO<GenerationsResponseDTO, LocalizedErrorMessageResponseDTO>> in
                if let safeGeneration = cachedGeneration {
                    return eventLoop.future(ResponseDTO<GenerationsResponseDTO, LocalizedErrorMessageResponseDTO>(success: true, data: safeGeneration, error: nil))
                }
                
                return self.pokeApi.generationById(id: generation).do { (response) in
                    if let safeData = response.data {
                        self.keyedCache.set(cacheKey, to: safeData)
                    }
                }
            }
        }
        
        return Future.whenAll(responseByGeneration, eventLoop: eventLoop).flatMap { (generationDtos) -> Future<ResponseDTO<AllPokemonSpeciesResponseDTO, LocalizedErrorMessageResponseDTO>> in
            if let firstWithError = generationDtos.first(where: { !$0.success }) {
                return eventLoop.future(ResponseDTO<AllPokemonSpeciesResponseDTO, LocalizedErrorMessageResponseDTO>(success: false, data: nil, error: firstWithError.error))
            }
            
            let joined = generationDtos.reduce([]) { (current: [PokemonSpecies], next: ResponseDTO<GenerationsResponseDTO, LocalizedErrorMessageResponseDTO>) -> [PokemonSpecies] in
                return current + next.data!.adapt()
            }
            
            return eventLoop.future(ResponseDTO<AllPokemonSpeciesResponseDTO, LocalizedErrorMessageResponseDTO>(success: true, data: AllPokemonSpeciesResponseDTO(species: joined), error: nil))
        }
    }
    
    public func speciesById(id: Int, eventLoop: EventLoop) -> Future<ResponseDTO<PokemonSpeciesResponseDTO, LocalizedErrorMessageResponseDTO>> {
        let cacheKey = K.Services.PokeAPI.speciesCacheKey.replacingOccurrences(of: K.Services.PokeAPI.speciesIdPlaceholder, with: "\(id)")
        
        return self.keyedCache.get(cacheKey, as: LegacyPokemonSpeciesResponseDTO.self).then { (cachedSpecies) -> Future<ResponseDTO<PokemonSpeciesResponseDTO, LocalizedErrorMessageResponseDTO>> in
            if let safeCachedSpecies = cachedSpecies {
                return eventLoop.future(ResponseDTO<PokemonSpeciesResponseDTO, LocalizedErrorMessageResponseDTO>(success: true, data: PokemonSpeciesResponseDTO(species: safeCachedSpecies.adapt()), error: nil))
            }
            
            return self.pokeApi.speciesById(id: id).then { (responseDto) -> Future<ResponseDTO<PokemonSpeciesResponseDTO, LocalizedErrorMessageResponseDTO>> in
                if responseDto.success {
                    self.keyedCache.set(cacheKey, to: responseDto.data!)
                    
                    return eventLoop.future(ResponseDTO<PokemonSpeciesResponseDTO, LocalizedErrorMessageResponseDTO>(success: true, data: PokemonSpeciesResponseDTO(species: responseDto.data!.adapt()), error: nil))
                }
                
                return eventLoop.future(ResponseDTO<PokemonSpeciesResponseDTO, LocalizedErrorMessageResponseDTO>(success: false, data: nil, error: responseDto.error))
            }
        }
    }
}
