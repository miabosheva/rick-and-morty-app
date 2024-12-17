import Foundation

class CharacterViewModel: ObservableObject {
    @Published var characters = [Character]()
    @Published var searchedCharacters = [Character]()
    @Published var error: Error?
    
    private var currentPage: Int = 1
    private var totalPages: Int?
    
    init() {
        loadData()
    }
    
    func loadData() {
        Task {
            await fetchCharacters()
        }
    }
    
    func refreshData() {
        currentPage = 1
        totalPages = nil
        characters.removeAll()
        loadData()
    }
    
    func fetchSearchData(name: String) {
        Task {
            await fetchCharactersByName(name: name)
        }
    }
}

// MARK: - Network Calls

extension CharacterViewModel {
    
    @MainActor
    func fetchCharacters() async {
        do {
            if totalPages == nil {
                let response = try await APIService.fetchCharacters(page: currentPage)
                totalPages = response.info.pages
            }

            guard let totalPages = totalPages, currentPage <= totalPages else { return }
            
            let response = try await APIService.fetchCharacters(page: currentPage)
            characters.append(contentsOf: response.results)
            currentPage += 1
        } catch {
            self.error = error
        }
    }
    
    @MainActor
    func fetchEpisodeForCharacter(url: String) async -> Episode? {
        do {
            let response = try await APIService.fetchEpisodeWithURL(episodeURL: url)
            return response
        } catch let error {
            print(error.localizedDescription)
        }
        return nil
    }
    
    @MainActor
    func fetchCharactersByName(name: String) async {
        do {
            let response = try await APIService.fetchCharactersByName(name: name)
            self.searchedCharacters = response.results
        } catch let error {
            self.searchedCharacters = []
            print(error)
        }
    }
}
