import Foundation
import CoreData

class CharacterViewModel: ObservableObject {
    
    private let context: NSManagedObjectContext
    
    @Published var characters = [CharacterResponse]()
    @Published var searchedCharacters = [CharacterResponse]()
    @Published var error: Error?
    @Published var isLoading: Bool = false
    
    @Published var loadCharacters = [CharacterEntity]()
    
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
            
            for char in response.results {
                saveCharacter(characterResponse: char)
            }
            print(loadCharacters)
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

// MARK: - Core Data Methods

extension CharacterViewModel {
    
    func saveCharacter(characterResponse: CharacterResponse) {
        let newCharacter = CharacterEntity(context: context)
        
        newCharacter.name = characterResponse.name
        newCharacter.species = characterResponse.species
        newCharacter.image = characterResponse.image
        newCharacter.originName = characterResponse.origin.name
        newCharacter.locationName = characterResponse.location.name
        newCharacter.episodeUrls = characterResponse.episodeUrls.joined(separator: ",")
        newCharacter.status = Int64(characterResponse.status.rawValue)
        newCharacter.gender = Int64(characterResponse.gender.rawValue)
        
        do {
            try context.save()
            fetchCharacters()
        } catch {
            print("Error saving character: \(error)")
        }
    }
    
    func fetchCharacters() {
        let fetchRequest: NSFetchRequest<CharacterEntity> = CharacterEntity.fetchRequest()
        do {
            loadCharacters = try context.fetch(fetchRequest)
            print("number of characters: \(loadCharacters.count)")
        } catch {
            print("Error fetching characters: \(error)")
        }
    }
}

// MARK: - Helper Methods

extension CharacterViewModel {
    
    private func addCharacter(character: CharacterResponse) {
        if !self.characters.contains(where: { $0.id == character.id }) {
            self.characters.append(character)
        }
    }
}
