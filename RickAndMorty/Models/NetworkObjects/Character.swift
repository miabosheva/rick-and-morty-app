import Foundation

struct CharacterResponse: Identifiable, Codable, Comparable, Hashable {
    var id: Int
    var name: String
    var species: String
    var image: String
    var status: Status
    var gender: Gender
    var episodeUrls: [String]
    var origin: Location
    var location: Location
    var episodes: [EpisodeResponse]?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case species
        case image
        case status
        case gender
        case episodeUrls = "episode"
        case origin
        case location
        case episodes
    }
    
    static func < (lhs: CharacterResponse, rhs: CharacterResponse) -> Bool {
        lhs.id < lhs.id
    }
    
    static func == (lhs: CharacterResponse, rhs: CharacterResponse) -> Bool {
        lhs.id == lhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

public struct Location: Codable {
    var name: String
    var url: String
}

@objc
public enum Gender: Int64, Codable {
    case female
    case male
    case genderless
    case unknown
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let stringValue = try container.decode(String.self)
        
        switch stringValue.lowercased() {
        case "female":
            self = .female
        case "male":
            self = .male
        case "genderless":
            self = .genderless
        case "unknown":
            self = .unknown
        default:
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid gender value")
        }
    }
    
    func name() -> String {
        switch self {
        case .female: return "Female"
        case .male: return "Male"
        case .genderless: return "Genderless"
        case .unknown: return "unknown"
        }
    }
}

@objc
public enum Status: Int64, Codable {
    case dead
    case alive
    case unknown
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let stringValue = try container.decode(String.self)
        
        switch stringValue.lowercased() {
        case "dead":
            self = .dead
        case "alive":
            self = .alive
        case "unknown":
            self = .unknown
        default:
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid status value")
        }
    }
    
    func name() -> String {
        switch self {
        case .dead: return "Dead"
        case .alive: return "Alive"
        case .unknown: return "unknown"
        }
    }
}
