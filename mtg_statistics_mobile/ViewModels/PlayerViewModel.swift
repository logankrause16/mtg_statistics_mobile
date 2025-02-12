//
//  PlayerViewModel.swift
//  mtg_statistics_mobile
//
//  Created by Logan Krause on 2/8/25.
//

import Foundation

class PlayerViewModel: ObservableObject {
    @Published var availablePlayers: [String] = []
    
    func fetchPlayers(completion: @escaping ([String]) -> Void) {
        APIService.shared.fetchUsers { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let users):
                    let players = users.map { $0.name }
                    self?.availablePlayers = players
                    completion(players)
                case .failure(let error):
                    print("Error fetching users: \(error)")
                    self?.availablePlayers = []
                    completion([])
                }
            }
        }
    }
}
