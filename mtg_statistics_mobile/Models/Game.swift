//
//  Game.swift
//  mtg_statistics_mobile
//
//  Created by Logan Krause on 2/8/25.
//

import Foundation

struct GameParticipants: Encodable {
    var id: Int
    var game_id: Int
    var user_id: Int
    var deck_id: Int
    var loss_condition_id: Int
    var win: Bool
    var notes: String?
}

// Models/Player.swift
//import Foundation
//
//struct Player: Identifiable {
//    var id: Int { user.id }
//    let user: User
//    var health: Int
//}

