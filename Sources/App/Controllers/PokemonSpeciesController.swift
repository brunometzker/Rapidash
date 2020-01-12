import Vapor

/// Controls basic CRUD operations on `Todo`s.
final class PokemonSpeciesController {
    private static let GENERATIONS: [Int] = [1, 2, 3, 4, 5, 6, 7]
    private let speciesService: PokemonSpeciesService
    
    init() {
        self.speciesService = PokemonSpeciesService(using: CachingService.getInstance())
    }
    
    func getAllSpecies(_ req: Request) throws -> Future<Response> {
        let speciesByGeneration = try PokemonSpeciesController.GENERATIONS.map { return try self.speciesService.getSpeciesByGenerationAsync(on: req, id: $0) }
        
        let payload: Future<[PokemonSpecies]> = Future.whenAll(speciesByGeneration, eventLoop: req.eventLoop).map { speciesByGeneration in
            return speciesByGeneration.flatMap { $0 }
        }
        
        return payload.then { species in
            return species.encode(status: .ok, for: req)
        }.catchFlatMap { error in
            print(error)
            let empty: [PokemonSpecies] = []

            return empty.encode(status: .internalServerError, for: req)
        }
    }
    
    func getSpeciesById(_ req: Request) throws -> Future<Response> {
        let id = try req.parameters.next(Int.self)
        
        let payload: Future<PokemonSpecies> = try self.speciesService.getSpeciesByIdAsync(on: req, id: id).catch { print($0) }
        
        return payload.then { species in
            return species.encode(status: .ok, for: req)
        }.catchFlatMap { error in
            print(error)

            let message = "Pokémon with identifier: \(id) was not found"
            
            return message.encode(status: .notFound, for: req)
        }
    }
}
