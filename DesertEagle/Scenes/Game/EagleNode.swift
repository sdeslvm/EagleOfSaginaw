//
//  EagleNode.swift
//  DesertEagle
//
//  Created by Pavel Ivanov on 21.03.2025.
//

import SpriteKit

class EagleNode: SKSpriteNode {
    private var speedVector = CGVector(dx: 0, dy: 2)
    private var angle: CGFloat = 0

    init() {
        let texture = SKTexture(imageNamed: SkinStore.shared.selectedSkinName)
        super.init(texture: texture, color: .clear, size: texture.size())
        self.zRotation = -.pi / 2 // Повернуть орла вперёд
        self.zPosition = 10
        self.setScale(0.3)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) not implemented")
    }

    func rotate(left: Bool) {
        let rotationAngle: CGFloat = left ? 0.07 : -0.07 // снижена скорость поворота
        angle += rotationAngle
        run(SKAction.rotate(byAngle: rotationAngle, duration: 0.1))

        let newDx = cos(angle) * 4
        let newDy = sin(angle) * 4
        speedVector = CGVector(dx: newDx, dy: newDy)
    }

    func movementVector() -> CGVector {
        return speedVector
    }
}

