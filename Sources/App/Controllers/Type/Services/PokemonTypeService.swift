import Vapor

final class PokemonTypeService {
    private let cachingService: CachingService
    
    init(using service: CachingService) {
        self.cachingService = service
    }
    
    public func getTypeByIdAsync(on container: Container, id: Int) throws -> Future<PokemonType> {
        let cacheKey = K.Services.PokeAPI.typeCacheKey.replacingOccurrences(of: K.Services.PokeAPI.typeIdPlaceholder, with: "\(id)")
        
        let cachedValue: Future<LegacyPokemonTypeResponseDTO?> = try cachingService.getValue(with: cacheKey, on: container)
            
        return cachedValue.flatMap { responseDto in
            if let value = responseDto {
                return container.future(value.adapt())
            }
            
            return self.fetchTypeByIdAsync(using: try container.client(), of: id).map { value in
                self.cachingService.cacheValue(of: container.future(value), with: cacheKey, on: container)
                return value.adapt()
            }
        }
    }
    
    private func fetchTypeByIdAsync(using client: Client, of id: Int) -> Future<LegacyPokemonTypeResponseDTO> {
        return client.get("https://\(K.Services.PokeAPI.host)/\(K.Services.PokeAPI.version)/\(K.Services.PokeAPI.typeRoute)/\(id)").flatMap { (response) -> EventLoopFuture<LegacyPokemonTypeResponseDTO> in
            do {
                return try response.content.decode(LegacyPokemonTypeResponseDTO.self)
            } catch {
                return response.future(error: error)
            }
        }
    }
}
