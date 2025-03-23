//
//  GameMabager.swift
//  DesertEagle
//
//  Created by Pavel Ivanov on 21.03.2025.
//

import SpriteKit
import AVFoundation

class GameManager: ObservableObject {
    static let shared = GameManager()
    var isVibroEnabled: Bool = true
    var isSoundEnabled: Bool = true
    var isGreetingShowing: Bool = false
    
    private var cashSound: AVAudioPlayer?
    private var eagleSound: AVAudioPlayer?
    
    let impact = UIImpactFeedbackGenerator(style: .medium)
    
    private init() {
        load()
    }

    @Published var health: Int = 100
    @Published var coins: Int = 0
    @Published var score: Int = 0

    func handleCollision(eagle: EagleNode, object: GameObjectNode) {
        switch object.type {
        case .coin:
            coins += 1
            score += 5
            if isVibroEnabled {
                impact.impactOccurred()
            }
            if isSoundEnabled {
                cashSound?.play()
            }
            object.removeFromParent()
        case .arrow:
            health -= 10
            if isVibroEnabled {
                impact.impactOccurred()
            }
            object.removeFromParent()
        case .enemyEagle:
            health -= 30
            if isVibroEnabled {
                impact.impactOccurred()
            }
            if isSoundEnabled {
                eagleSound?.play()
            }
            object.removeFromParent()
        case .helper:
            health += 15
            score += 15
            if isVibroEnabled {
                impact.impactOccurred()
            }
            object.removeFromParent()
        }
        
        if health <= 0 {
            print("Game Over")
        }
    }
    
    func reset() {
        CoinStorage.shared.add(coins)
        health = 100
        coins = 0
        score = 0
    }

    private func load() {
        // Загружаем музыку из файла
        if let url = Bundle.main.url(forResource: "cash", withExtension: "mp3") {
            do {
                cashSound = try AVAudioPlayer(contentsOf: url)
            } catch {
                print("Error loading audio file: \(error.localizedDescription)")
            }
        }
        if let url = Bundle.main.url(forResource: "eagle", withExtension: "mp3") {
            do {
                eagleSound = try AVAudioPlayer(contentsOf: url)
            } catch {
                print("Error loading audio file: \(error.localizedDescription)")
            }
        }
    }
}
