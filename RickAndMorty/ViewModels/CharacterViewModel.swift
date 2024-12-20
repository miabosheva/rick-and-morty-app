import Foundation
import CoreData

class CharacterViewModel: ObservableObject {
    
    private let context: NSManagedObjectContext
    
    @Published var searchedCharacters = [CharacterEntity]()
    @Published var characters = [CharacterEntity]()
    
    @Published var error: Error?
    @Published var isLoading: Bool = false
    
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
        searchedCharacters = []
        currentPage = 1
        totalPages = nil
        deleteAllCharacters()
        loadData()
    }
    
    func refreshEpisodes(characterId: Int) {
        deleteEpisodes(characterId: characterId)
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
            let fetchRequest: NSFetchRequest<CharacterEntity> = CharacterEntity.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %d", charId)
            
            if let character = try context.fetch(fetchRequest).first {
                if character.episodes.count == 0 {
                    character.episodes = [response]
                } else {
                    character.episodes.adding(response)
                }
                try context.save()
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
            let results = try context.fetch(fetchRequest)
            self.searchedCharacters = results
        } catch let error {
            self.searchedCharacters = []
            print(error)
        }
    }
}

// MARK: - Helper Methods

extension CharacterViewModel {
    
    // check for duplicates before adding the character
    private func addCharacter(character: CharacterResponse) {
        let fetchRequest: NSFetchRequest<CharacterEntity> = CharacterEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", character.id)
        
        do {
            let existingCharacters = try context.fetch(fetchRequest)
            if existingCharacters.isEmpty {
                print("Saving character with ID: \(character.id)")
                saveCharacter(characterResponse: character)
            } else {
                print("Character with ID \(character.id) already exists.")
            }
        } catch {
            print("Error checking for existing character: \(error.localizedDescription)")
        }
    }
}

// MARK: - Core Data Methods

extension CharacterViewModel {
    
    private func saveCharacter(characterResponse: CharacterResponse) {
        let character = CharacterEntity(context: context, characterResponse: characterResponse)
        self.characters.append(character)
        do {
            try context.save()
        } catch {
            print("Error saving character: \(error)")
        }
    }
    
    private func getLoadedCharacters() -> [CharacterEntity]? {
        let fetchRequest: NSFetchRequest<CharacterEntity> = CharacterEntity.fetchRequest()
        do {
            let loadedCharacters = try context.fetch(fetchRequest)
            print("Fetched characters: \(loadedCharacters.count)")
            return loadedCharacters
        } catch {
            print("Error fetching characters: \(error)")
        }
        return nil
    }
    
    private func deleteAllCharacters() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = CharacterEntity.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(deleteRequest)
            try context.save()
            self.characters = []
            print("All Character objects have been deleted.")
            if let loadedCharacters = getLoadedCharacters() {
                print("Characters remaining after delete: \(loadedCharacters.count)")
            }
        } catch {
            print("Failed to delete Character objects: \(error.localizedDescription)")
        }
    }
    
    func deleteEpisodes(characterId: Int) {
        let fetchRequest: NSFetchRequest<CharacterEntity> = CharacterEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", characterId)
        
        do {
            let characters = try context.fetch(fetchRequest)
            
            guard let character = characters.first else {
                print("Character with ID \(characterId) not found.")
                return
            }
            
            if let episodes = character.episodes as? NSMutableSet {
                episodes.removeAllObjects()
            } else {
                character.episodes = NSSet()
            }
            
            try context.save()
            print("Episodes refreshed for character with ID \(characterId).")
        } catch {
            print("Error refreshing episodes: \(error.localizedDescription)")
        }
    }
}
