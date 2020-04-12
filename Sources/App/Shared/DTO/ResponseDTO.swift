import Vapor

struct ResponseDTO<T, U>: Content where T: Codable, U: Codable {
    let success: Bool
    let data: T?
    let error: U?
}
