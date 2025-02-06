//
//  PlayerPanelView.swift
//  MTGStatisticsApp
//
//  Created by [Your Name] on [Date].
//

import SwiftUI

/// A view displaying one player's panel, including life total, plus/minus buttons,
/// and extra counters (commander damage, poison, etc.).
///
/// The `flipped` parameter allows you to rotate the *entire* panel upside-down
/// while re-rotating the internal text so it remains upright.
/// This approach ensures that buttons and layout are correct for an "upside-down" seat.
struct PlayerPanelView: View {
    @Binding var player: Player
    
    /// Whether the panel is oriented upside-down for players on opposite seats.
    /// When `true`, the outer shape is flipped 180°, but the inner text and counters remain upright.
    var flipped: Bool = false
    
    // Example counters for other stats
    @State private var myCommanderDamage: Int = 0
    @State private var oppCommanderDamage: Int = 0
    
    // Additional optional counters (example)
    @State private var poisonCounters: Int = 0
    @State private var energyCounters: Int = 0
    
    /// Allows passing in a background color to customize each panel if desired.
    var backgroundColor: Color = Color(UIColor.systemBlue).opacity(0.2)
    
    var body: some View {
        ZStack {
            // 1) Rotate the entire background shape if flipped
            RoundedRectangle(cornerRadius: 20)
                .fill(backgroundColor)
                .rotationEffect(.degrees(flipped ? 180 : 0))
            
            // 2) Then rotate the content back so text remains upright
            VStack(spacing: -60) {
                // Top row: minus & plus
                HStack {
                    Button(action: {
                        player.health -= 1
                    }) {
                        Image(systemName: "minus")
                            .font(.title)
                            .padding()
                    }
                    Spacer()
                    Button(action: {
                        player.health += 1
                    }) {
                        Image(systemName: "plus")
                            .font(.title)
                            .padding()
                    }
                }
                .padding(.horizontal)
                
                // Life total and name
                VStack(spacing: 4) {
                    Text("\(player.health)")
                        .font(.system(size: 48, weight: .bold))
                    
                    Text(player.user.name)
                        .font(.headline)
                }
            }
            .padding(.vertical)
            .rotationEffect(.degrees(flipped ? 180 : 0)) // Re-rotate content upright
        }
    }
}

// MARK: - Previews

struct PlayerPanelView_Previews: PreviewProvider {
    // Sample data
    @State static var previewPlayer = Player(
        user: User(id: 1, name: "Logs"),
        health: 40
    )
    
    static var previews: some View {
        // Show a pair of panels (one upright, one flipped) side by side
        HStack {
            PlayerPanelView(player: $previewPlayer, flipped: false)
                .frame(width: 200, height: 250)
            
            PlayerPanelView(player: $previewPlayer, flipped: true)
                .frame(width: 200, height: 250)
        }
        .previewLayout(.sizeThatFits)
    }
}
