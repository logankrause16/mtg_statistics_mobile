// ViewModels/PlayerViewModel.swift
import Foundation
import Combine

class PlayerViewModel: ObservableObject {
    @Published var availablePlayers: [String] = []
    
    init() {
        fetchPlayers()
    }
    
    func fetchPlayers() {
        // Replace this simulated delay with your actual database call.
        DispatchQueue.global().asyncAfter(deadline: .now() + 1.0) {
            let names = ["Alice", "Bob", "Charlie", "Diana", "Eve"]
            DispatchQueue.main.async {
                self.availablePlayers = names
            }
        }
    }
}
