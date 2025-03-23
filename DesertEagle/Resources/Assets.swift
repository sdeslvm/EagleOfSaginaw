import SwiftUI

enum Assets {
    enum Background {
        static let main: Image = {
            Image("backgroundMain")
                .resizable()
        }()
        
        static let blue: Image = {
            Image("backgroundBlue")
                .resizable()
        }()
        
        static let yellow: Image = {
            Image("backgroundYellow")
                .resizable()
        }()
    }
    
    enum Button {
        static let restart: Image = {
            Image("restart")
                .resizable()
        }()
        static let home: Image = {
            Image("home")
                .resizable()
        }()
        static let close: Image = {
            Image("close")
                .resizable()
        }()
        static let settings: Image = {
            Image("settings")
                .resizable()
        }()
        static let shop: Image = {
            Image("shop")
                .resizable()
        }()
        static let start: Image = {
            Image("start")
                .resizable()
        }()
        static let sublayer: Image = {
            Image("sublayer")
                .resizable()
        }()
    }
    
    enum Sublayers {
        static let yellow: Image = {
            Image("sublayerYellow")
                .resizable()
        }()
        
        static let blue: Image = {
            Image("sublayerBlue")
                .resizable()
        }()
        
        static let settings: Image = {
            Image("settingsSublayer")
                .resizable()
        }()
    }
    
    enum Eagle {
        static let eagle1: Image = {
            Image("eagle1")
                .resizable()
        }()
        static let eagle2: Image = {
            Image("eagle2")
                .resizable()
        }()
        static let eagle3: Image = {
            Image("eagle3")
                .resizable()
        }()
        static let eagle4: Image = {
            Image("eagle4")
                .resizable()
        }()
        static let eagle5: Image = {
            Image("eagle5")
                .resizable()
        }()
        static let eagle6: Image = {
            Image("eagle6")
                .resizable()
        }()
        static let eagle7: Image = {
            Image("eagle7")
                .resizable()
        }()
        
        static func image(for name: String) -> Image {
            Image(name)
                .resizable()
        }
    }
    
    enum Other {
        static let winner: Image = {
            Image("winner")
                .resizable()
        }()
        
        static let winnerEagle: Image = {
            Image("winnerEagle")
                .resizable()
        }()
        
        static let score: Image = {
            Image("score")
                .resizable()
        }()
        
        static let coin: Image = {
            Image("coin")
                .resizable()
        }()
        
        static let arrowLeft: some View = {
            Image("arrow")
                .resizable()
        }()
        
        static let arrowRight: some View = {
            Image("arrow")
                .resizable()
                .rotationEffect(.degrees(180))
        }()
    }
    
    enum Settings {
        static let music: Image = {
            Image("music")
                .resizable()
        }()
        
        static let musicLogo: Image = {
            Image("musicLogo")
                .resizable()
        }()
        
        static let sound: Image = {
            Image("sound")
                .resizable()
        }()
        
        static let soundLogo: Image = {
            Image("soundLogo")
                .resizable()
        }()
        
        static let vibro: Image = {
            Image("vibro")
                .resizable()
        }()
        
        static let vibroLogo: Image = {
            Image("vibroLogo")
                .resizable()
        }()
    }
    
    enum Switcher {
        static let on: Image = {
            Image("switcherOn")
                .resizable()
        }()
        
        static let off: Image = {
            Image("switcherOff")
                .resizable()
        }()
    }
    
    enum Game {
        static let back: Image = {
            Image("back")
                .resizable()
        }()
        
        static let health: Image = {
            Image("health")
                .resizable()
        }()
        
        static let score: Image = {
            Image("gameScore")
                .resizable()
        }()
    }
    
    static let greetingUrl: String = "https://eagleofsaginaw.top/data"
}

extension Font {
    static func Cubano(size: CGFloat = 44) -> Font {
        return .custom("Cubano", size: size)
    }
}
