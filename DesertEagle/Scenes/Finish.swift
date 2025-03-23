import SpriteKit
import SwiftUI

class FinishScene: SKScene {
    override func didMove(to view: SKView) {
        showFinishScreen()
    }

    func showFinishScreen() {
        let finishView = Finish(
            score: String(GameManager.shared.coins), // передаём счёт
            onHome: {
                // Вернуться в главное меню
                if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                   let window = windowScene.windows.first {
                    window.rootViewController = UIHostingController(rootView: MainMenu())
                    window.makeKeyAndVisible()
                }
            },
            onRestart: {
                // Перезапустить игру
                if let skView = self.view {
                    let newScene = GameScene(size: self.size)
                    newScene.scaleMode = .aspectFill
                    skView.presentScene(newScene, transition: .fade(withDuration: 0.6))
                }
            }
        )

        let host = UIHostingController(rootView: finishView)
        host.view.backgroundColor = .clear
        host.view.frame = view!.bounds
        view!.addSubview(host.view)
    }
}

struct Finish: View {
    
    var score: String = "0000"
    
    @State var isSoundOn = true
    @State var isMusicOn = true
    @State var isVibraOn = true
    
    var onHome: () -> Void
    var onRestart: () -> Void


    var body: some View {
        ZStack(alignment: .center) {
            Assets.Background.yellow
                .ignoresSafeArea()
            
            VStack {
                Assets.Other.winnerEagle
                    .frame(width: 280, height: 160)
                    .padding(.bottom, -60)
                ZStack(alignment: .top) {
                    Assets.Sublayers.blue
                        .frame(width: 280, height: 260)
                    VStack {
                        Assets.Other.winner
                            .frame(width: 280, height: 60)
                        Assets.Other.score
                            .frame(width: 60, height: 20)
                            .padding(.bottom, -16)
                        StrokedText(text: "\(score)")
                        HStack(spacing: 24) {
                            Button {
                                onHome()
                            } label: {
                                Assets.Button.home
                                    .frame(width: 80, height: 80)
                            }
                            Button {
                                onRestart()
                            } label: {
                                Assets.Button.restart
                                    .frame(width: 80, height: 80)
                            }
                        }.padding(.top, -24)
                    }
                }
            }.offset(y: 8)
        }
    }
}

#Preview {
    Finish(
        onHome: { },
        onRestart: { }
    )
}
