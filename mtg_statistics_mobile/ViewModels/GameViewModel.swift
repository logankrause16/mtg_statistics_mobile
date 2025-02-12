//
//  GameViewModel.swift
//  mtg_statistics_mobile
//
//  Created by Logan Krause on 2/8/25.
//

import Foundation

class GameViewModel: ObservableObject {

    func createGame(selectedPlayers: [String]) {
        APIService.shared.createGame(selectedPlayers: selectedPlayers) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let game):
                    print("Game created: \(game)")
                case .failure(let error):
                    print("Error creating game: \(error)")
                }
            }
        }
    }
}
