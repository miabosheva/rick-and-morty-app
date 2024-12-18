import SwiftUI

@main
struct RickAndMortyApp: App {
//    @StateObject private var dataController = DataController()
    
    var body: some Scene {
        WindowGroup {
            HomeView()
                .environmentObject(CharacterViewModel())
//                .environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
}
