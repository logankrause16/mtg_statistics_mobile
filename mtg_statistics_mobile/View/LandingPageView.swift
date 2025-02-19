import SwiftUI

struct LandingPageView: View {
    @StateObject private var playerViewModel = PlayerViewModel()
    @StateObject private var gameViewModel = GameViewModel()
    
    // Tracks the selected index for each player picker; -1 means "not selected"
    @State private var selectedIndices: [Int] = [-1, -1, -1, -1]
    // Tracks the selected deck index for each player; -1 means "not selected"
    @State private var selectedDeckIndices: [Int] = [-1, -1, -1, -1]
    
    @State private var showAlert = false
    // Trigger for navigation to LifeLinkerView
    @State private var navigateToLifeLinker = false
    // Temporarily hold the selected player names (as Strings)
    @State private var selectedPlayers: [String] = []
    
    var body: some View {
        NavigationView {
            Form {
                // For each player slot, display the player picker and, if selected, the deck picker.
                ForEach(0..<4, id: \.self) { index in
                    VStack(alignment: .leading, spacing: 10) {
                        self.playerPicker(for: index)
                        self.deckPickerIfNeeded(for: index)
                    }
                    .padding(.vertical, 5)
                }
                
                // Button to start the game.
                Button("Start Game") {
                    if selectedIndices.contains(-1) {
                        showAlert = true
                    } else {
                        selectedPlayers = selectedIndices.map { playerViewModel.availablePlayers[$0] }
                        gameViewModel.createGame(selectedPlayers: selectedPlayers)
                        navigateToLifeLinker = true
                    }
                }
            }
            .navigationBarTitle("Select Players")
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Incomplete Selection"),
                    message: Text("Please select all players."),
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
    
    // Helper function for the player picker.
    private func playerPicker(for index: Int) -> some View {
        Picker("Player \(index + 1)", selection: $selectedIndices[index]) {
            Text("Select a Player").tag(-1)
            ForEach(playerViewModel.availablePlayers.indices, id: \.self) { i in
                Text(playerViewModel.availablePlayers[i]).tag(i)
            }
        }
        .pickerStyle(MenuPickerStyle())
    }
    
    // Helper function for the deck picker.
    // Returns an EmptyView if no player is selected.
    private func deckPickerIfNeeded(for index: Int) -> AnyView {
        if selectedIndices[index] == -1 {
            return AnyView(EmptyView())
        }
        let playerName = playerViewModel.availablePlayers[selectedIndices[index]]
//        let decks = playerViewModel.decks(for: playerName)
        return AnyView(
            Picker("Select deck for \(playerName)", selection: $selectedDeckIndices[index]) {
                Text("Select a Deck").tag(-1)
//                ForEach(decks.indices, id: \.self) { deckIndex in
//                    Text(decks[deckIndex].name).tag(deckIndex)
//                }
            }
            .pickerStyle(MenuPickerStyle())
        )
    }
}

struct LandingPageView_Previews: PreviewProvider {
    static var previews: some View {
        LandingPageView()
    }
}
