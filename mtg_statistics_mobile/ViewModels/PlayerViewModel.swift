import Foundation

class PlayerViewModel: ObservableObject {
    @Published var availablePlayers: [String] = []
    
    init() {
        fetchPlayers()
    }
    
    func fetchPlayers() {
        APIService.shared.fetchUsers { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let users):
                    // Map the fetched User objects to their names.
                    self?.availablePlayers = users.map { $0.name }
                case .failure(let error):
                    // Handle error as needed (e.g., log or show an error message)
                    print("Error fetching users: \(error)")
                    self?.availablePlayers = []
                }
            }
        }
    }
}
