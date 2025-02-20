import SwiftUI

struct LifeLinkerView: View {
    // Accept an initial array of players from the parent view.
    @State var players: [Player]

    @State private var showDiceResult: Bool = false
    @State private var gameSubmitted: Bool = false
    @State private var diceNumber: Int = 0

    var body: some View {
        GeometryReader { geo in
            ZStack {
                // Background color.
                Color.white
                    .ignoresSafeArea()
                
                // Layout according to the number of players.
                if players.count == 2 {
                    // Two players: one panel on top, one on bottom.
                    // Top panel: player 0 (flipped)
                    PlayerPanelView(player: $players[0], flipped: true)
                        .frame(width: geo.size.width, height: geo.size.height / 2)
                        .position(x: geo.size.width / 2, y: geo.size.height / 4)
                    
                    // Bottom panel: player 1 (not flipped)
                    PlayerPanelView(player: $players[1], flipped: false)
                        .frame(width: geo.size.width, height: geo.size.height / 2)
                        .position(x: geo.size.width / 2, y: 3 * geo.size.height / 4)
                }
                else if players.count == 3 {
                    // Three players:
                    // Top half: player 0 occupies full top half (flipped).
                    PlayerPanelView(player: $players[0], flipped: true)
                        .frame(width: geo.size.width, height: geo.size.height / 2)
                        .position(x: geo.size.width / 2, y: geo.size.height / 4)
                    
                    // Bottom half: split horizontally between players 1 and 2.
                    PlayerPanelView(player: $players[1], flipped: false)
                        .frame(width: geo.size.width / 2, height: geo.size.height / 2)
                        .position(x: geo.size.width / 4, y: 3 * geo.size.height / 4)
                    
                    PlayerPanelView(player: $players[2], flipped: false)
                        .frame(width: geo.size.width / 2, height: geo.size.height / 2)
                        .position(x: 3 * geo.size.width / 4, y: 3 * geo.size.height / 4)
                }
                else if players.count >= 4 {
                    // Four players: 2 x 2 grid.
                    // Top-Left (player 0, flipped)
                    PlayerPanelView(player: $players[0], flipped: true)
                        .frame(width: geo.size.width / 2, height: geo.size.height / 2)
                        .position(x: geo.size.width / 4, y: geo.size.height / 4)
                    
                    // Top-Right (player 1, flipped)
                    PlayerPanelView(player: $players[1], flipped: true)
                        .frame(width: geo.size.width / 2, height: geo.size.height / 2)
                        .position(x: 3 * geo.size.width / 4, y: geo.size.height / 4)
                    
                    // Bottom-Left (player 2, not flipped)
                    PlayerPanelView(player: $players[2], flipped: false)
                        .frame(width: geo.size.width / 2, height: geo.size.height / 2)
                        .position(x: geo.size.width / 4, y: 3 * geo.size.height / 4)
                    
                    // Bottom-Right (player 3, not flipped)
                    PlayerPanelView(player: $players[3], flipped: false)
                        .frame(width: geo.size.width / 2, height: geo.size.height / 2)
                        .position(x: 3 * geo.size.width / 4, y: 3 * geo.size.height / 4)
                }
                
                // Overlay for extra controls at the bottom.
                VStack {
                    Spacer()
                    HStack(spacing: 20) {
                        Button(action: resetAllPlayers) {
                            Image(systemName: "arrow.clockwise.circle")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .foregroundColor(.blue)
                        }
                        
                        Button(action: rollDice) {
                            Image(systemName: "die.face.6")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .foregroundColor(.blue)
                        }
                        
                        Button(action: submitGameResult) {
                            Image(systemName: "paperplane.fill")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .foregroundColor(.blue)
                        }
                    }
                    .padding()
                }
                
                // Dice roll popup overlay.
                if showDiceResult {
                    VStack {
                        Text("Rolled a \(diceNumber)")
                            .font(.largeTitle)
                            .foregroundColor(.white)
                            .padding()
                        
                        Button("Close") {
                            showDiceResult = false
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(8)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.black.opacity(0.7))
                    .ignoresSafeArea()
                }
                
                // Game submitted overlay.
                if gameSubmitted {
                    VStack {
                        Text("Game Submitted!")
                            .font(.largeTitle)
                            .foregroundColor(.white)
                            .padding()
                        
                        Button("Close") {
                            gameSubmitted = false
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(8)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.black.opacity(0.7))
                    .ignoresSafeArea(edges: [.horizontal])
                }
            }
        }
    }
    
    // MARK: - Helper Functions
    
    private func resetAllPlayers() {
        for i in players.indices {
            players[i].health = 40
        }
    }
    
    private func rollDice() {
        diceNumber = Int.random(in: 1...6)
        showDiceResult = true
    }
    
    private func submitGameResult() {
        let participants: [GameParticipants] = [
            GameParticipants(id: 1, game_id: 1, user_id: 1, deck_id: 1, loss_condition_id: 1, win: true, notes: "Scooped"),
            GameParticipants(id: 2, game_id: 1, user_id: 2, deck_id: 2, loss_condition_id: 2, win: false, notes: "Had to leave"),
            GameParticipants(id: 3, game_id: 1, user_id: 3, deck_id: 3, loss_condition_id: 3, win: true, notes: nil)
        ]
        // APIService.shared.submitGame(game: participants)
        gameSubmitted = true
    }
}

struct LifeLinkerView_Previews: PreviewProvider {
    static var previews: some View {
        // Provide sample players for preview.
        LifeLinkerView(players: [
            Player(user: User(id: 1, name: "Player 1"), health: 40),
            Player(user: User(id: 2, name: "Player 2"), health: 40),
            Player(user: User(id: 3, name: "Player 3"), health: 40)
        ])
        .previewInterfaceOrientation(.landscapeLeft)
    }
}
