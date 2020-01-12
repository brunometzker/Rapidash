import Vapor

final class PokemonTypeService {
    private let cachingService: CachingService
    
    init(using service: CachingService) {
        self.cachingService = service
    }
    
    public func getTypeByIdAsync(on container: Container, id: Int) throws -> Future<PokemonType> {
        let cachedValue: Future<LegacyPokemonTypeResponseDTO?> = try cachingService.getValue(with: "pokemon.type.\(id)", on: container)
            
        return cachedValue.flatMap { responseDto in
            if let value = responseDto {
                return container.future(value.adapt())
            }
            
            return self.fetchTypeByIdAsync(using: try container.client(), of: id).map { value in
                self.cachingService.cacheValue(of: container.future(value), with: "pokemon.type.\(id)", on: container).catch { print($0) }
                return value.adapt()
            }
        }.catchFlatMap { error in
            print(error)
            print("Could not find cached value for key: pokemon.type.\(id). Calling PokeAPI to retrieve information")
            
            return self.fetchTypeByIdAsync(using: try container.client(), of: id).map { value in
                self.cachingService.cacheValue(of: container.future(value), with: "pokemon.type.\(id)", on: container).catch { print($0) }
                return value.adapt()
            }
        }
    }
    
    private func fetchTypeByIdAsync(using client: Client, of id: Int) -> Future<LegacyPokemonTypeResponseDTO> {
        return PokeApiProxy.getTypeById(using: client, of: id).flatMap { response -> Future<LegacyPokemonTypeResponseDTO> in
            return try response.content.decode(LegacyPokemonTypeResponseDTO.self)
        }
    }
}
