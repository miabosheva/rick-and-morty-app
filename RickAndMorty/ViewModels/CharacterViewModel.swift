import Foundation

class CharacterViewModel: ObservableObject {
    @Published var characters = [Character]()
    @Published var searchedCharacters = [Character]()
    @Published var error: Error?
    @Published var isLoading: Bool = false
    
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
        self.isLoading = false
        do {
            if totalPages == nil {
                let response = try await APIService.fetchCharacters(page: currentPage)
                totalPages = response.info.pages
            }
            
            guard let totalPages = totalPages, currentPage <= totalPages else { return }
            
            let response = try await APIService.fetchCharacters(page: currentPage)
            
            // add the next page of results, if meanwile a search was made, make sure to avoid duplicates
            self.characters = Array(Set(self.characters + response.results)).sorted()
            currentPage += 1
        } catch {
            self.error = error
        }
        self.isLoading = false
    }
    
    @MainActor
    func fetchEpisodeForCharacter(charId: Int, episodeUrl: String) async {
        do {
            let response = try await APIService.fetchEpisodeWithURL(episodeURL: episodeUrl)
            if let index = self.characters.firstIndex(where: { $0.id == charId }) {
                if self.characters[index].episodes == nil {
                    self.characters[index].episodes = [response]
                } else {
                    self.characters[index].episodes?.append(response)
                }
            }
        } catch let error {
            print("Error fetching episode: \(error.localizedDescription)")
        }
    }
    
    @MainActor
    func fetchCharactersByName(name: String) async {
        do {
            let response = try await APIService.fetchCharactersByName(name: name)
            self.searchedCharacters = response.results
            // when fetching new characters with search, cache them with the rest of the list
            let combinedCharacters = self.characters + self.searchedCharacters
            let uniqueCharacters = Array(Set(combinedCharacters))
            self.characters = uniqueCharacters.sorted()
        } catch let error {
            self.searchedCharacters = []
            print(error)
        }
    }
}
