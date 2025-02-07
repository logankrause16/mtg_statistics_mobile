import Foundation

class APIService {
    static let shared = APIService()
    
    private let userEndpoint = URL(string: "http://localhost:8081/api/user_management/users")
    
    // Private initializer to enforce singleton usage.
    private init() {}
    
    /// Fetches users from the API backend.
    /// - Parameter completion: A completion handler that returns a Result containing an array of User or an Error.
    func fetchUsers(completion: @escaping (Result<[User], Error>) -> Void) {
        let request = URLRequest(url: userEndpoint!)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            // If an error occurred, return it.
            if let error = error {
                completion(.failure(error))
                return
            }
            
            // Ensure data exists.
            guard let data = data else {
                let noDataError = NSError(domain: "APIService", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data returned"])
                completion(.failure(noDataError))
                return
            }
            
            do {
                // Decode the JSON response into an array of User.
                let users = try JSONDecoder().decode([User].self, from: data)
                completion(.success(users))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
}
