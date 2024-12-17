import Foundation

struct APIService {
    
    @MainActor
    static func fetchCharacters(page: Int) async throws -> CharacterResponse {
        
        guard var urlComponents = URLComponents(string: "https://rickandmortyapi.com/api/character") else {
            throw CharacterError.invalidURL
        }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "page", value: "\(page)")
        ]
        
        guard let url = urlComponents.url else {
            throw CharacterError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw CharacterError.serverError
        }
        
        guard let result = try? JSONDecoder().decode(CharacterResponse.self, from: data) else {
            throw CharacterError.invalidData
        }
//        do {
//            _ = try JSONDecoder().decode(CharacterResponse.self, from: data)
//        } catch let error {
//            print(error)
//        }
        return result
    }
}
