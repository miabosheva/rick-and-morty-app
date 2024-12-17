import Foundation

class CharacterViewModel: ObservableObject {
    @Published var characters = [Character]()
    @Published var error: Error?
    
    private var currentPage: Int = 1
    private var hasMorePages: Bool = true
    
    init() {
        Task {
            await loadData()
        }
    }
}

// MARK: - Network Calls

extension CharacterViewModel {
    
    @MainActor
    func loadData() async {
        do {
            let response = try await APIService.fetchCharacters(page: currentPage)
            characters.append(contentsOf: response.results)
        } catch {
            self.error = error
        }
    }
    
    @MainActor
    func fetchMoreCharacters() async {
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
}
