import SwiftUI

@main
struct RickAndMortyApp: App {
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            HomeView()
                .environmentObject(CharacterViewModel(context: persistenceController.container.viewContext))
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
