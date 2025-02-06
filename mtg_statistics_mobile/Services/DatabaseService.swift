import Foundation

class DatabaseService {
    static let shared = DatabaseService()
    
    // Credentials
    let host = "localhost"
    let port = 5432
    let username = "lkrause"
    let password = "pass"
    let database = "mtg_statistics"
    
    // Example method to fetch player names from your database.
    // Replace this with your real database query.
    func fetchPlayerNames(completion: @escaping (Result<[String], Error>) -> Void) {
        // Simulated network/database delay
        DispatchQueue.global().asyncAfter(deadline: .now() + 1.0) {
            // Example list of players from the database.
            let names = ["Alice", "Bob", "Charlie", "Diana", "Eve"]
            completion(.success(names))
        }
    }
}
