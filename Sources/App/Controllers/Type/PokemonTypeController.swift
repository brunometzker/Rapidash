import Vapor

final class PokemonTypeController {
    private let typeService: PokemonTypeService
    
    init() {
        self.typeService = PokemonTypeService(using: CachingService.getInstance())
    }
    
    func getTypeById(_ req: Request) throws -> Future<Response> {
        let id = try req.parameters.next(Int.self)
        
        let payload = try self.typeService.getTypeByIdAsync(on: req, id: id)
        
        return payload.then { pokemonType in
            return pokemonType.encode(status: .ok, for: req)
        }.catchFlatMap { error in
            print(error)
            
            let message = "Pokémon type of identifier: \(id) was not found."
            
            return message.encode(status: .notFound, for: req)
        }
    }
}
