import SwiftUI

@main
struct RickAndMortyApp: App {
    var body: some Scene {
        WindowGroup {
            HomeView().environmentObject(CharacterViewModel())
        }
    }
}
