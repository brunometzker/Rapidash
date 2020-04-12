import Vapor

final class PokemonTypeService: Service {
    let keyedCache: KeyedCache
    let pokeApi: PokeApiProxy
    
    init(keyedCache: KeyedCache, pokeApi: PokeApiProxy) {
        self.keyedCache = keyedCache
        self.pokeApi = pokeApi
    }
    
    public func typeById(id: Int, eventLoop: EventLoop) -> Future<ResponseDTO<PokemonTypeResponseDTO, LocalizedErrorMessageResponseDTO>> {
        let cacheKey = K.Services.PokeAPI.typeCacheKey.replacingOccurrences(of: K.Services.PokeAPI.typeIdPlaceholder, with: "\(id)")
        
        return self.keyedCache.get(cacheKey, as: LegacyPokemonTypeResponseDTO.self).then { (cachedDto) -> Future<ResponseDTO<PokemonTypeResponseDTO, LocalizedErrorMessageResponseDTO>> in
            if let safeCachedDto = cachedDto {
                return eventLoop.future(ResponseDTO<PokemonTypeResponseDTO, LocalizedErrorMessageResponseDTO>(success: true, data: PokemonTypeResponseDTO(type: safeCachedDto.adapt()), error: nil))
            }
            
            return self.pokeApi.typeById(id: id).then { (responseDto) -> EventLoopFuture<ResponseDTO<PokemonTypeResponseDTO, LocalizedErrorMessageResponseDTO>> in
                if responseDto.success {
                    self.keyedCache.set(cacheKey, to: responseDto.data!)
                    
                    return eventLoop.future(ResponseDTO<PokemonTypeResponseDTO, LocalizedErrorMessageResponseDTO>(success: true, data: PokemonTypeResponseDTO(type: responseDto.data!.adapt()), error: nil))
                }
                
                return eventLoop.future(ResponseDTO<PokemonTypeResponseDTO, LocalizedErrorMessageResponseDTO>(success: false, data: nil, error: responseDto.error))
            }
        }
    }
}
