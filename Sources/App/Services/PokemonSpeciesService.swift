import Vapor

final class PokemonSpeciesService {
    private let cachingService: CachingService
    
    init(using service: CachingService) {
        self.cachingService = service
    }
    
    public func getSpeciesByGenerationAsync(on container: Container, id: Int) throws -> Future<[PokemonSpecies]> {
        let cachedValue: Future<GenerationsResponseDTO?> = try self.cachingService.getValue(with: "pokemon.generation.\(id)", on: container)
        
        return cachedValue.flatMap { responseDto in
            if let value = responseDto {
                return container.future(value.adapt())
            }
            
            return self.fetchGenerationByIdAsync(using: try container.client(), of: id).map { value in
                self.cachingService.cacheValue(of: container.future(value), with: "pokemon.generation.\(id)", on: container)
                return value.adapt()
            }
        }.catchFlatMap { error in
            print(error)
            print("Could not find cached value for key: pokemon.species.\(id). Calling PokeAPI to retrieve information")
            
            return self.fetchGenerationByIdAsync(using: try container.client(), of: id).map { value in
                self.cachingService.cacheValue(of: container.future(value), with: "pokemon.generation.\(id)", on: container)
                return value.adapt()
            }
        }
    }
    
    public func getSpeciesByIdAsync(on container: Container, id: Int) throws -> Future<PokemonSpecies> {
        let cachedValue: Future<PokemonSpeciesResponseDTO?> = try self.cachingService.getValue(with: "pokemon.species.\(id)", on: container)
            
        return cachedValue.flatMap { responseDto in
            if let value = responseDto {
                return container.future(value.adapt())
            }
            
            return self.fetchSpeciesByIdAsync(using: try container.client(), of: id).map { value in
                self.cachingService.cacheValue(of: container.future(value), with: "pokemon.species.\(id)", on: container)
                return value.adapt()
            }
        }.catchFlatMap { error in
            print(error)
            print("Could not find cached value for key: pokemon.species.\(id). Calling PokeAPI to retrieve information")
            
            return self.fetchSpeciesByIdAsync(using: try container.client(), of: id).map { value in
                self.cachingService.cacheValue(of: container.future(value), with: "pokemon.species.\(id)", on: container)
                return value.adapt()
            }
        }
    }
    
    private func fetchGenerationByIdAsync(using client: Client, of id: Int) -> Future<GenerationsResponseDTO> {
        return PokeApiProxy.getSpeciesByGeneration(using: client, of: id).flatMap { response -> Future<GenerationsResponseDTO> in
            return try response.content.decode(GenerationsResponseDTO.self)
        }
    }
    
    private func fetchSpeciesByIdAsync(using client: Client, of id: Int) -> Future<PokemonSpeciesResponseDTO> {
        return PokeApiProxy.getSpeciesById(using: client, of: id).flatMap { response -> Future<PokemonSpeciesResponseDTO> in
            return try response.content.decode(PokemonSpeciesResponseDTO.self)
        }
    }
}
