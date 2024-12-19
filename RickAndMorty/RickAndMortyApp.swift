import SwiftUI

@main
struct RickAndMortyApp: App {
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            HomeView()
                .environmentObject(CharacterViewModel())
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
