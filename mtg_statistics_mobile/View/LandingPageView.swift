    import SwiftUI

    struct LandingPageView: View {
        @StateObject private var playerViewModel = PlayerViewModel()
        @StateObject private var gameViewModel = GameViewModel()
        // Tracks the selected index for each player picker; -1 means "not selected"
        @State private var selectedIndices: [Int] = [-1, -1, -1, -1]
        @State private var showAlert = false
        // Trigger for navigation to LifeLinkerView
        @State private var navigateToLifeLinker = false
        // Temporarily hold the selected player names (as Strings)
        @State private var selectedPlayers: [String] = []
        
        var body: some View {
            NavigationView {
                Form {
                    // Create a Picker for each of the 4 players.
                    ForEach(0..<4, id: \.self) { index in
                        Picker("Player \(index + 1)", selection: $selectedIndices[index]) {
                            // Default option indicating no selection.
                            Text("Select a Player").tag(-1)
                            // List available players fetched from the view model.
                            ForEach(playerViewModel.availablePlayers.indices, id: \.self) { i in
                                Text(playerViewModel.availablePlayers[i]).tag(i)
                            }
                        }
                        .pickerStyle(MenuPickerStyle()) // Dropdown style.
                    }
                    
                    // Button to start the game.
                    Button("Start Game") {
                        // Validate that all pickers have a valid selection.
                        if selectedIndices.contains(-1) {
                            showAlert = true
                        } else {
                            // Map selected indices to actual player names.
                            selectedPlayers = selectedIndices.map {
                                playerViewModel.availablePlayers[$0] }
                            // Create the game on click
                            gameViewModel.createGame(selectedPlayers: selectedPlayers)
                            
                            // Trigger navigation.
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
                // Hidden NavigationLink that performs the transition.
                .background(
                    NavigationLink(
                        destination: LifeLinkerView(
                            players: selectedPlayers.enumerated().map { (index, name) in
                                // Convert each selected name into a Player.
                                Player(
                                    user: User(
                                        id: index + 1,
                                        name: name
                                    ),
                                    health: 40
                                )
                            }
                        ),
                        isActive: $navigateToLifeLinker,
                        label: { EmptyView() }
                    )
                    .hidden()
                )
                // Trigger the API call when the view appears.
                .onAppear {
                    playerViewModel.fetchPlayers { _ in }
                }
            }
        }
    }

    struct LandingPage_Previews: PreviewProvider {
        static var previews: some View {
            LandingPageView()
        }
    }
