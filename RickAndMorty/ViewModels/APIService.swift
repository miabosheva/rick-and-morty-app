import Foundation

struct APIService {
    
    @MainActor
    static func fetchCharacters(page: Int) async throws -> CharacterResponse {
        
        guard let url = URL(string: "https://rickandmortyapi.com/api/character/?page=\(page)") else {
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
