import SpriteKit

enum ObjectType {
    case coin, helper, arrow, enemyEagle
}

extension ObjectType {
    static func random() -> ObjectType {
        let all: [ObjectType] = [.coin, .helper, .arrow, .enemyEagle]
        return all.randomElement()!
    }
}

final class GameObjectStorage {
    let enemyNames: [String] = ["enemy1", "enemy2"]
    let helperNames: [String] = ["helper1", "helper2", "helper3", "helper4", "helper5", "helper6", "helper7", "helper8"]
}

class GameObjectNode: SKSpriteNode {
    let type: ObjectType
    private var velocity: CGVector = .zero

    init(type: ObjectType) {
        self.type = type

        let textureName: String = {
            switch type {
            case .coin:
                "coin"
            case .arrow:
                "arrowEnemy"
            case .enemyEagle:
                GameObjectStorage().enemyNames.randomElement() ?? "enemy1"
            case .helper:
                GameObjectStorage().helperNames.randomElement() ?? "helper1"
            }
        }()

        let texture = SKTexture(imageNamed: textureName)
        super.init(texture: texture, color: .clear, size: texture.size())
        self.setScale(0.2)
        self.zPosition = 5
        self.name = "enemyObject"

        if type == .arrow {
            zRotation = CGFloat.random(in: 0...(.pi * 2))
            velocity = CGVector(dx: cos(zRotation) * 4, dy: sin(zRotation) * 4)
        } else if type == .enemyEagle {
            zRotation = .pi // временно — враг будет смотреть влево при спавне
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func update(towards target: CGPoint?) {
        switch type {
        case .arrow:
            position.x += velocity.dx
            position.y += velocity.dy
            if let parent = parent, !parent.calculateAccumulatedFrame().contains(position) {
                removeFromParent()
            }

        case .enemyEagle:
            guard let target = target else { return }

            let angleToTarget = atan2(target.y - position.y, target.x - position.x)
            let shortest = shortestAngle(from: zRotation, to: angleToTarget)
            let maxRotation: CGFloat = 0.03
            let clampedRotation = max(-maxRotation, min(maxRotation, shortest))
            zRotation += clampedRotation

            let speed: CGFloat = 2.8
            let dx = cos(zRotation) * speed
            let dy = sin(zRotation) * speed
            position.x += dx
            position.y += dy

            if let parent = parent, !parent.calculateAccumulatedFrame().contains(position) {
                removeFromParent()
            }

        default:
            break
        }
    }

    private func shortestAngle(from: CGFloat, to: CGFloat) -> CGFloat {
        var delta = to - from
        while delta > .pi { delta -= .pi * 2 }
        while delta < -.pi { delta += .pi * 2 }
        return delta
    }

    static func randomSpawnPosition(in size: CGSize, margin: CGFloat = 100) -> CGPoint {
        let x = CGFloat.random(in: margin...(size.width - margin))
        let y = CGFloat.random(in: margin...(size.height - margin))
        return CGPoint(x: x, y: y)
    }
}
