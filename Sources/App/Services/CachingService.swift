import Vapor

final class CachingService {
    private static var instance: CachingService? = nil
    
    private init() {}
    
    public static func getInstance() -> CachingService {
        if instance == nil {
            self.instance = CachingService()
        }
        
        return self.instance!
    }
    
    public func cacheValue<T>(of value: Future<T>, with key: String, on container: Container) -> Future<Void> where T : Encodable {
        return value.then { (enc: T) -> Future<Void> in
            do {
                return try container.keyedCache(for: .redis).set(key, to: enc)
            } catch {
                return container.future(error: error)
            }
        }
    }
    
    public func getValue<T>(with key: String, on container: Container) throws -> Future<T?> where T : Decodable {
        return try container.keyedCache(for: .redis).get(key, as: T.self)
    }
}
