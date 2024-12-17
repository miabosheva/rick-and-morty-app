import Foundation

enum CharacterError: Error, LocalizedError {
    case invalidURL
    case serverError
    case invalidData
    case unknown(Error)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "The URL is invalid."
        case .serverError:
            return "Server error. Try Again."
        case .invalidData:
            return "The data is invalid."
        case .unknown(let error):
            return error.localizedDescription
        }
    }
}
