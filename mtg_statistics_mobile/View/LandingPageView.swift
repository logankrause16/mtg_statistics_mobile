import SwiftUI

// Make PlayerSelection identifiable so SwiftUI can track changes.
struct PlayerSelection: Identifiable, Equatable {
    let id = UUID()
    var playerIndex: Int = -1
    var deckIndex: Int = -1
}

struct LandingPageView: View {
    @StateObject private var playerViewModel = PlayerViewModel()
    @StateObject private var gameViewModel = GameViewModel()
    
    // Start with two players.
    @State private var players: [PlayerSelection] = [PlayerSelection(), PlayerSelection()]
    
    @State private var showAlert = false
    @State private var navigateToLifeLinker = false
    @State private var selectedPlayers: [String] = []
    
    var body: some View {
        NavigationView {
            Form {
                // Dynamic list of player pickers.
                Section(header: Text("Players")) {
                    ForEach(players.indices, id: \.self) { index in
                        VStack(alignment: .leading, spacing: 10) {
                            // Player Picker
                            Picker("Player \(index + 1)", selection: Binding(
                                get: { players[index].playerIndex },
                                set: { players[index].playerIndex = $0 }
                            )) {
                                Text("Select a Player").tag(-1)
                                ForEach(playerViewModel.availablePlayers.indices, id: \.self) { i in
                                    Text(playerViewModel.availablePlayers[i]).tag(i)
                                }
                            }
                            .pickerStyle(MenuPickerStyle())
                            
                            // Deck Picker appears only when a player is selected.
                            if players[index].playerIndex != -1 {
                                let playerName = playerViewModel.availablePlayers[players[index].playerIndex]
                                Picker("Select deck for \(playerName)", selection: Binding(
                                    get: { players[index].deckIndex },
                                    set: { players[index].deckIndex = $0 }
                                )) {
                                    Text("Select a Deck").tag(-1)
                                    // Uncomment and add deck options if needed.
                                }
                                .pickerStyle(MenuPickerStyle())
                            }
                        }
                        .padding(.vertical, 5)
                    }
                }
                
                // Section for adding players.
                Section {
                    Button("Add Player (Limit 4)") {
                        if players.count < 4 {
                            players.append(PlayerSelection())
                        }
                    }
                    .disabled(players.count >= 4)
                }
                
                // Section for removing players.
                Section {
                    Button("Remove Player") {
                        if players.count > 2 {
                            players.removeLast()
                        }
                    }
                    .disabled(players.count <= 2)
                }
                
                // Section for starting the game.
                Section {
                    Button("Start Game") {
                        let indices = players.map { $0.playerIndex }
                        // Debug prints.
                        print("Selected indices: \(indices)")
                        print("Available players: \(playerViewModel.availablePlayers)")
                        
                        // Check if any selection is missing.
                        guard !indices.contains(-1),
                              !playerViewModel.availablePlayers.isEmpty,
                              indices.allSatisfy({ $0 >= 0 && $0 < playerViewModel.availablePlayers.count })
                        else {
                            showAlert = true
                            return
                        }
                        
                        // Use safe mapping.
                        let mappedPlayers = indices.compactMap { index -> String? in
                            if index >= 0 && index < playerViewModel.availablePlayers.count {
                                return playerViewModel.availablePlayers[index]
                            } else {
                                return nil
                            }
                        }
                        
                        // If mapping didn't yield all players, show alert.
                        guard mappedPlayers.count == players.count else {
                            showAlert = true
                            return
                        }
                        
                        selectedPlayers = mappedPlayers
                        gameViewModel.createGame(selectedPlayers: selectedPlayers)
                        navigateToLifeLinker = true
                    }
                }
            }
            .navigationBarTitle("Select Players")
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Incomplete Selection"),
                    message: Text("Please select all players properly."),
                    dismissButton: .default(Text("OK"))
                )
            }
            .background(
                NavigationLink(
                    destination: LifeLinkerView(
                        players: selectedPlayers.enumerated().map { (index, name) in
                            Player(
                                user: User(id: index + 1, name: name),
                                health: 40
                            )
                        }
                    ),
                    isActive: $navigateToLifeLinker,
                    label: { EmptyView() }
                )
                .hidden()
            )
            .onAppear {
                playerViewModel.fetchPlayers { _ in }
            }
        }
    }
}

struct LandingPageView_Previews: PreviewProvider {
    static var previews: some View {
        LandingPageView()
    }
}
