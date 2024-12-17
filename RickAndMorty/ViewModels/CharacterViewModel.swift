import Foundation

class CharacterViewModel: ObservableObject {
    @Published var characters = [Character]()
    @Published var error: Error?
    
    private var currentPage: Int = 1
    private var hasMorePages: Bool = true
    
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
        characters.removeAll()
        loadData()
    }
}

// MARK: - Network Calls

extension CharacterViewModel {
    
    @MainActor
    func fetchCharacters() async {
        do {
            let response = try await APIService.fetchCharacters(page: currentPage)
            characters.append(contentsOf: response.results)
            if (response.info.next != nil) {
                hasMorePages = true
                currentPage += 1
            } else {
                hasMorePages = false
            }
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
}
