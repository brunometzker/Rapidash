import Vapor

final class PokemonTypeController: Service {
    let typeService: PokemonTypeService
    
    init(typeService: PokemonTypeService) {
        self.typeService = typeService
    }
    
    func getTypeById(_ req: Request) throws -> Future<Response> {
        return self.typeService.typeById(id: try req.parameters.next(Int.self), eventLoop: req.eventLoop).then { (responseDto) -> Future<Response> in
            return responseDto.success ? responseDto.encode(status: .ok, for: req) : responseDto.encode(status: .internalServerError, for: req)
        }
    }
}
