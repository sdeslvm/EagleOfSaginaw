import SwiftUI
import SpriteKit

import SwiftUI
import SpriteKit

struct EagleGame: View {
    @StateObject private var sceneHolder = SceneHolder()
    @ObservedObject private var gameManager = GameManager.shared
    @State private var isGameOver = false

    var onQuit: () -> Void

    var body: some View {
        ZStack(alignment: .top) {
            SpriteView(scene: sceneHolder.scene)
                .id(sceneHolder.scene) // ⬅️ Обновит представление при пересоздании сцены
                .ignoresSafeArea()

            GameInterface(
                health: $gameManager.health,
                score: $gameManager.score,
                coins: $gameManager.coins,
                onBack: {
                    isGameOver = true
                }
            ).padding()

            if isGameOver {
                Finish(
                    score: String(format: "%04d", gameManager.score),
                    onHome: {
                        isGameOver = false
                        gameManager.reset()
                        onQuit()
                    },
                    onRestart: {
                        isGameOver = false
                        gameManager.reset()
                        sceneHolder.createNewScene { _ in
                            isGameOver = true
                        }
                    }
                )
                .transition(.opacity)
            }
        }
        .onAppear {
            sceneHolder.createNewScene { _ in
                isGameOver = true
            }
            MusicCentre.shared.playMusic()
        }
        .onDisappear() {
            MusicCentre.shared.stopMusic()
        }
    }
}

struct GameInterface: View {
    
    @Binding var health: Int
    @Binding var score: Int
    @Binding var coins: Int
    var onBack: () -> Void
    
    var body: some View {
        ZStack(alignment: .top) {
            HStack {
                Button {
                    onBack()
                } label: {
                    Assets.Game.back
                        .frame(width: 80, height: 60)
                }
                
                Spacer()
                
                VStack(alignment: .trailing) {
                    ZStack(alignment: .leading) {
                        Rectangle()
                            .cornerRadius(20)
                            .frame(width: healthBarWidth(), height: 30)
                            .foregroundStyle(.red)
                            .offset(x: 24, y: 2)
                        Assets.Game.health
                            .frame(width: 200, height: 40)
                    }
                    
                    HStack {
                        Assets.Other.coin
                            .frame(width: 40, height: 40)
                        StrokedText(text: String(format: "%04d", coins), size: 24)
                    }
                }.offset(y: 6)
            }
            
            ZStack {
                Assets.Game.score
                    .frame(width: 140, height: 60)
                StrokedText(text: String(format: "%04d", score), size: 24)
                    .offset(y: 10)
            }
        }
    }
    
    func healthBarWidth() -> CGFloat {
        let maxWidth: CGFloat = 172
        let clampedHealth = max(0, min(CGFloat(health), 100))
        return (clampedHealth / 100) * maxWidth
    }
}

final class SceneHolder: ObservableObject {
    @Published var scene: GameScene = GameScene()

    func createNewScene(onGameOver: @escaping (Int) -> Void) {
        let newScene = GameScene()
        let screen = UIScreen.main.bounds
        newScene.size = CGSize(width: max(screen.width, screen.height),
                               height: min(screen.width, screen.height))
        newScene.scaleMode = .aspectFill
        newScene.onGameOver = onGameOver
        self.scene = newScene
    }
}
