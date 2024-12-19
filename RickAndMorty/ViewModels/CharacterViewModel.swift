import Foundation

class CharacterViewModel: ObservableObject {
    @Published var characters = [CharacterResponse]()
    @Published var searchedCharacters = [CharacterResponse]()
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
        do {
            self.isLoading = true
            if totalPages == nil {
                let response = try await APIService.fetchCharacters(page: currentPage)
                totalPages = response.info.pages
            }
            
            guard let totalPages = totalPages, currentPage <= totalPages else { return }
            
            let response = try await APIService.fetchCharacters(page: currentPage)
            currentPage += 1
            for char in response.results {
                addCharacter(character: char)
            }
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
            for char in searchedCharacters {
                addCharacter(character: char)
            }
        } catch let error {
            self.searchedCharacters = []
            print(error)
        }
    }
}

// MARK: - Herlper Methods

extension CharacterViewModel {
    
    private func addCharacter(character: CharacterResponse) {
        if !self.characters.contains(where: { $0.id == character.id }) {
            self.characters.append(character)
        }
    }
}
