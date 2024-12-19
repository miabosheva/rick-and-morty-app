import Foundation
import CoreData

class CharacterViewModel: ObservableObject {
    
    private let context: NSManagedObjectContext
    
    @Published var characters = [CharacterResponse]()
    @Published var searchedCharacters = [CharacterResponse]()
    @Published var error: Error?
    @Published var isLoading: Bool = false
    
    @Published var loadCharacters = [CharacterEntity]()
    @Published var loadedSearchedCharacters = [CharacterEntity]()
    
    private var currentPage: Int = 1
    private var totalPages: Int?
    
    init(context: NSManagedObjectContext) {
        self.context = context
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
        deleteAllCharacters()
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
            for char in response.results {
                addCharacter(character: char)
            }
            let fetchRequest: NSFetchRequest<CharacterEntity> = CharacterEntity.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "name CONTAINS[cd] %@", name)
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
            let results = try context.fetch(fetchRequest)
            self.loadCharacters = results
            print("SEARCH: \(loadCharacters[0].name)")
        } catch let error {
            self.loadCharacters = []
            print(error)
        }
    }
}

// MARK: - Core Data Methods

extension CharacterViewModel {
    
    private func saveCharacter(characterResponse: CharacterResponse) {
        
        let newCharacter = CharacterEntity(context: context, characterResponse: characterResponse)
        
        do {
            try context.save()
            fetchCharacters()
        } catch {
            print("Error saving character: \(error)")
        }
    }
    
    private func fetchCharacters() {
        let fetchRequest: NSFetchRequest<CharacterEntity> = CharacterEntity.fetchRequest()
        do {
            loadCharacters = try context.fetch(fetchRequest)
            print("number of characters fetched: \(loadCharacters.count)")
        } catch {
            print("Error fetching characters: \(error)")
        }
    }
    
    private func deleteAllCharacters() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = CharacterEntity.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(deleteRequest)
            try context.save()
            print("All Character objects have been deleted.")
        } catch {
            print("Failed to delete Character objects: \(error.localizedDescription)")
        }
    }
}

// MARK: - Helper Methods

extension CharacterViewModel {
    
    // avoid duplicates when adding characters
    private func addCharacter(character: CharacterResponse) {
        if !loadCharacters.contains(where: { $0.id == character.id }) {
            saveCharacter(characterResponse: character)
        }
    }
}
