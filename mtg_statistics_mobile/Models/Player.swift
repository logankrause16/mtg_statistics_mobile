// Models/Player.swift
import Foundation

struct Player: Identifiable {
    var id: Int { user.id }
    let user: User
    var health: Int
}
