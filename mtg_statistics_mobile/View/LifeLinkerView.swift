//
//  LifeLinkerView.swift
//  MTGStatisticsApp
//
//  Created by [Your Name] on [Date].
//

import SwiftUI

struct LifeLinkerView: View {
    
    @State private var players: [Player] = [
        Player(user: User(id: 1, name: "Player 1"), health: 40),
        Player(user: User(id: 2, name: "Player 2"), health: 40),
        Player(user: User(id: 3, name: "Player 3"), health: 40),
        Player(user: User(id: 4, name: "Player 4"), health: 40)
    ]
    
    @State private var showDiceResult: Bool = false
    @State private var diceNumber: Int = 0
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                Color.white
                    .ignoresSafeArea()
                
                // Top-Left (upright)
                PlayerPanelView(player: $players[0], flipped: true)
                    .frame(width: geo.size.width / 2, height: geo.size.height / 2)
                    .position(x: geo.size.width / 4, y: geo.size.height / 4)
                
                // Top-Right (flipped)
                PlayerPanelView(player: $players[1], flipped: true)
                    .frame(width: geo.size.width / 2, height: geo.size.height / 2)
                    .position(x: 3 * geo.size.width / 4, y: geo.size.height / 4)
                
                // Bottom-Left (flipped)
                PlayerPanelView(player: $players[2], flipped: false)
                    .frame(width: geo.size.width / 2, height: geo.size.height / 2)
                    .position(x: geo.size.width / 4, y: 3 * geo.size.height / 4)
                
                // Bottom-Right (upright)
                PlayerPanelView(player: $players[3], flipped: false)
                    .frame(width: geo.size.width / 2, height: geo.size.height / 2)
                    .position(x: 3 * geo.size.width / 4, y: 3 * geo.size.height / 4)
                
                // Overlay for extra controls
                VStack {
                    Spacer()
                    HStack(spacing: 20) {
                        Button(action: resetAllPlayers) {
                            Image(systemName: "arrow.clockwise.circle")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .foregroundColor(.blue)
                        }
                        
                        Text("\(players.count)")
                            .font(.title)
                            .foregroundColor(.blue)
                        
                        HStack(spacing: 8) {
                            Circle().fill(Color.red).frame(width: 20, height: 20)
                            Circle().fill(Color.green).frame(width: 20, height: 20)
                            Circle().fill(Color.blue).frame(width: 20, height: 20)
                            Circle().fill(Color.black).frame(width: 20, height: 20)
                        }
                        
                        Button(action: rollDice) {
                            Image(systemName: "die.face.6")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .foregroundColor(.blue)
                        }
                    }
                    .padding()
                }
                
                // Dice roll popup
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
            }
        }
    }
    
    private func resetAllPlayers() {
        for i in players.indices {
            players[i].health = 40
        }
    }
    
    private func rollDice() {
        diceNumber = Int.random(in: 1...6)
        showDiceResult = true
    }
}

struct LifeLinkerView_Previews: PreviewProvider {
    static var previews: some View {
        LifeLinkerView()
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
