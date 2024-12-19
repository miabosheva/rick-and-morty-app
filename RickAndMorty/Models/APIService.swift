import Foundation

struct APIService {
    
    static func fetchCharacters(page: Int) async throws -> CharacterResponseObject {
        
        guard let url = URL(string: "https://rickandmortyapi.com/api/character/?page=\(page)") else {
            throw CharacterError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw CharacterError.serverError
        }
        
        guard let result = try? JSONDecoder().decode(CharacterResponseObject.self, from: data) else {
            throw CharacterError.invalidData
        }
//        do {
//            _ = try JSONDecoder().decode(CharacterResponse.self, from: data)
//        } catch let error {
//            print(error)
//        }
        return result
    }
    
    static func fetchEpisodeWithURL(episodeURL: String) async throws -> EpisodeResponse {
        guard let url = URL(string: episodeURL) else {
            throw CharacterError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw CharacterError.serverError
        }
        
        guard let result = try? JSONDecoder().decode(EpisodeResponse.self, from: data) else {
            throw CharacterError.invalidData
        }
        
        return result
    }
    
    static func fetchCharactersByName(name: String) async throws -> CharacterResponseObject {
        
        guard let url = URL(string: "https://rickandmortyapi.com/api/character/?name=\(name)") else {
            throw CharacterError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw CharacterError.invalidResponse
        }

        if httpResponse.statusCode == 404 {
            throw CharacterError.noDataFound
        } else if httpResponse.statusCode != 200 {
            throw CharacterError.serverError
        }
        
        guard let result = try? JSONDecoder().decode(CharacterResponseObject.self, from: data) else {
            throw CharacterError.invalidData
        }
        
        return result
    }
}
