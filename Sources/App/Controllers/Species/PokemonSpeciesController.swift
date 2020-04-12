import Vapor

/// Controls basic CRUD operations on `Todo`s.
final class PokemonSpeciesController: Service {
    static let GENERATIONS: [Int] = [1, 2, 3, 4, 5, 6, 7]
    let speciesService: PokemonSpeciesService
    
    init(speciesService: PokemonSpeciesService) {
        self.speciesService = speciesService
    }
    
    func getAllSpecies(_ req: Request) throws -> Future<Response> {
        return self.speciesService.allSpeciesFrom(generations: PokemonSpeciesController.GENERATIONS, eventLoop: req.eventLoop).then { (responseDto) -> Future<Response> in
            return responseDto.success ? responseDto.encode(status: .ok, for: req) : responseDto.encode(status: .internalServerError, for: req)
        }
    }
    
    func getSpeciesById(_ req: Request) throws -> Future<Response> {
        return self.speciesService.speciesById(id: try req.parameters.next(Int.self), eventLoop: req.eventLoop).then { (responseDto) -> Future<Response> in
            return responseDto.success ? responseDto.encode(status: .ok, for: req) : responseDto.encode(status: .internalServerError, for: req)
        }
    }
}
