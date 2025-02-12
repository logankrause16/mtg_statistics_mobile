// Models/Player.swift
import Foundation

struct Player: Encodable {
    var id: Int { user.id }
    let user: User
    var health: Int
}
