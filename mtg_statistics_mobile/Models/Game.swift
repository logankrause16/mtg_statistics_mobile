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

struct Game: Decodable {
    var id: Int
    var date: String
}
