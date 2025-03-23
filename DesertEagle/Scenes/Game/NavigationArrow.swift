//
//  NavigationArrow.swift
//  DesertEagle
//
//  Created by Pavel Ivanov on 21.03.2025.
//

import SpriteKit

class NavigationArrow: SKSpriteNode {
    init() {
        let texture = SKTexture(imageNamed: "navigationArrow")
        super.init(texture: texture, color: .clear, size: CGSize(width: 50, height: 100))
        self.zPosition = 100
        self.setScale(0.8)
        self.alpha = 1.0
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) not implemented")
    }

    func pointToward(target: CGPoint, from origin: CGPoint) {
        let dx = target.x - origin.x
        let dy = target.y - origin.y
        let angle = atan2(dy, dx) - .pi / 2
        zRotation = angle
    }
}
