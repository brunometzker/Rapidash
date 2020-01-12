import Vapor

final class PokeApiProxy {
    private static let HOST: String = "pokeapi.co/api/"
    private static let VERSION: String = "v2"
    
    public static func getSpeciesByGeneration(using httpClient: Client, of id: Int) -> Future<Response> {
        let path = "/generation/"
        let url = "https://\(PokeApiProxy.HOST)\(PokeApiProxy.VERSION)\(path)\(id)"
        
        return httpClient.get(url).catch { print($0) }
    }
    
    public static func getSpeciesById(using httpClient: Client, of id: Int) -> Future<Response> {
        let path = "/pokemon/"
        let url = "https://\(PokeApiProxy.HOST)\(PokeApiProxy.VERSION)\(path)\(id)"
        
        return httpClient.get(url).catch { print($0) }
    }
    
    public static func getTypeById(using httpClient: Client, of id: Int) -> Future<Response> {
        let path = "/type/"
        let url = "https://\(PokeApiProxy.HOST)\(PokeApiProxy.VERSION)\(path)\(id)"
        
        return httpClient.get(url).catch { print($0) }
    }
}
