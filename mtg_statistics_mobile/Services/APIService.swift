import Foundation

class APIService {
    static let shared = APIService()
    
    private let userEndpoint = "http://localhost:8081/api/user_management"
    private let deckEndpoint = "http://localhost:8081/api/deck_management"
    private let gameEndpoint = "httP://localhost:8081/api/game_management"
    
    // Private initializer to enforce singleton usage.
    private init() {}
    
    /// Submits a game to the server using a POST request.
    ///
    /// - Parameters:
    ///   - game: A Game instance that will be encoded into JSON and sent to the backend.
    ///   - completion: A completion handler that returns a Result containing a success message String or an Error.
    func submitGame(game: [GameParticipants], completion: @escaping (Result<String, Error>) -> Void) {
        // Create the full endpoint URL by appending "/game/submit"
        let submitGameEndpoint = URL(string: gameEndpoint + "/game/submit")
        var request = URLRequest(url: submitGameEndpoint!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Encode the game object into JSON.
        do {
            let jsonData = try JSONEncoder().encode(game)
            request.httpBody = jsonData
        } catch {
            completion(.failure(error))
            return
        }
        
        // Create a data task to submit the game.
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            // Check for client-side errors.
            if let error = error {
                completion(.failure(error))
                return
            }
            
            // Ensure we have received data.
            guard let data = data else {
                let noDataError = NSError(domain: "APIService", code: -1,
                                          userInfo: [NSLocalizedDescriptionKey: "No data returned"])
                completion(.failure(noDataError))
                return
            }
            
            // Optionally, check the HTTP response status code.
            if let httpResponse = response as? HTTPURLResponse, !(200...299).contains(httpResponse.statusCode) {
                let httpError = NSError(domain: "APIService", code: httpResponse.statusCode,
                                        userInfo: [NSLocalizedDescriptionKey: "Server returned status code \(httpResponse.statusCode)"])
                completion(.failure(httpError))
                return
            }
            
            // Attempt to decode the response.
            do {
                // If your API returns a JSON object (like {"message": "Game submitted!"}),
                // you might define a corresponding response struct.
                // For simplicity, this example tries to decode a plain String.
                let responseMessage = try JSONDecoder().decode(String.self, from: data)
                completion(.success(responseMessage))
            } catch {
                // If JSON decoding fails, try converting the data to a string.
                if let responseString = String(data: data, encoding: .utf8) {
                    completion(.success(responseString))
                } else {
                    completion(.failure(error))
                }
            }
        }
        
        task.resume()
    }
    
    
    /// Fetches users from the API backend.
    /// - Parameter completion: A completion handler that returns a Result containing an array of User or an Error.
    func fetchUsers(completion: @escaping (Result<[User], Error>) -> Void) {
        let userEndpointUsers = URL(string: userEndpoint + "/users")
        let request = URLRequest(url: userEndpointUsers!)
        
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
    
    func createGame(selectedPlayers: [String], completion: @escaping (Result<Game, Error>) -> Void) {
        // Construct the URL using your game endpoint.
        guard let url = URL(string: gameEndpoint + "/game/new") else {
            let urlError = NSError(domain: "APIService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])
            completion(.failure(urlError))
            return
        }
        
        // Create and configure the URLRequest as a POST request.
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            // Encode the selectedPlayers array into JSON data.
            let playersData = try JSONEncoder().encode(selectedPlayers)
            // Base64 encode the JSON data.
            let base64PlayersString = playersData.base64EncodedString()
            // Wrap the base64 string in a dictionary. Adjust the key as needed by your backend.
            let payload: [String: String] = ["players": base64PlayersString]
            // Convert the payload dictionary into JSON data.
            let payloadData = try JSONSerialization.data(withJSONObject: payload, options: [])
            // Set the JSON payload as the request body.
            request.httpBody = payloadData
        } catch {
            completion(.failure(error))
            return
        }
        
        // Create the data task.
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
                // Decode the JSON response into a Game object.
                let game = try JSONDecoder().decode(Game.self, from: data)
                completion(.success(game))
            } catch {
                completion(.failure(error))
            }
        }
        
        // Start the task.
        task.resume()
    }

}
