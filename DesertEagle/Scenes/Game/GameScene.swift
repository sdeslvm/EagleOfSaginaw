import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {

    var onGameOver: ((Int) -> Void)?

    var eagle: EagleNode!
    var background: SKNode!
    var gameManager = GameManager.shared

    var helperArrow: NavigationArrow?
    var nearestHelper: SKNode?

    var isTurningLeft = false
    var isTurningRight = false

    let mapScale: CGFloat = 0.4
    var enemySpawnTimer: TimeInterval = 0
    var timeSinceStart: TimeInterval = 0
    var mapSize: CGSize = .zero

    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        setupBackground()
        setupEagle()
        startSpawningObjects()
    }

    func setupBackground() {
        let part1 = SKSpriteNode(texture: SKTexture(imageNamed: "1"))
        let part2 = SKSpriteNode(texture: SKTexture(imageNamed: "2"))
        let part3 = SKSpriteNode(texture: SKTexture(imageNamed: "3"))
        let part4 = SKSpriteNode(texture: SKTexture(imageNamed: "4"))

        [part1, part2, part3, part4].forEach { $0.setScale(mapScale) }

        let mapWidth = part1.size.width + part2.size.width
        let mapHeight = part1.size.height + part3.size.height
        mapSize = CGSize(width: mapWidth, height: mapHeight)

        part1.anchorPoint = CGPoint(x: 0, y: 1)
        part2.anchorPoint = CGPoint(x: 0, y: 1)
        part3.anchorPoint = CGPoint(x: 0, y: 1)
        part4.anchorPoint = CGPoint(x: 0, y: 1)

        part1.position = CGPoint(x: 0, y: mapHeight)
        part2.position = CGPoint(x: part1.size.width, y: mapHeight)
        part3.position = CGPoint(x: 0, y: mapHeight - part1.size.height)
        part4.position = CGPoint(x: part1.size.width, y: mapHeight - part2.size.height)

        let mapNode = SKNode()
        mapNode.addChild(part1)
        mapNode.addChild(part2)
        mapNode.addChild(part3)
        mapNode.addChild(part4)

        mapNode.zPosition = -1
        addChild(mapNode)

        self.background = mapNode
    }

    func setupEagle() {
        eagle = EagleNode()
        eagle.setScale(0.3)
        eagle.position = CGPoint(x: size.width / 2, y: size.height / 2)
        eagle.zPosition = 10
        addChild(eagle)

        eagle.physicsBody = SKPhysicsBody(circleOfRadius: eagle.size.width / 2)
        eagle.physicsBody?.categoryBitMask = 1
        eagle.physicsBody?.contactTestBitMask = 2
        eagle.physicsBody?.collisionBitMask = 0
        eagle.physicsBody?.affectedByGravity = false
    }

    func startSpawningObjects() {
        let spawnAction = SKAction.sequence([
            SKAction.run { self.spawnObject() },
            SKAction.wait(forDuration: 2.0)
        ])
        run(SKAction.repeatForever(spawnAction))
    }

    func spawnObject() {
        let margin: CGFloat = 100
        let spawnPosition = GameObjectNode.randomSpawnPosition(in: mapSize, margin: margin)

        let object = GameObjectNode(type: .random())
        object.setScale(0.2)
        object.position = spawnPosition
        object.physicsBody = SKPhysicsBody(circleOfRadius: object.size.width / 2)
        object.physicsBody?.categoryBitMask = 2
        object.physicsBody?.contactTestBitMask = 1
        object.physicsBody?.collisionBitMask = 0
        object.physicsBody?.affectedByGravity = false

        background.addChild(object)

        updateNearestHelper()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: self)
            if location.x < size.width / 2 {
                isTurningLeft = true
            } else {
                isTurningRight = true
            }
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        isTurningLeft = false
        isTurningRight = false
    }

    override func update(_ currentTime: TimeInterval) {
        if isTurningLeft {
            eagle.rotate(left: true)
        } else if isTurningRight {
            eagle.rotate(left: false)
        }

        let movement = eagle.movementVector()

        var newPosition = background.position
        newPosition.x -= movement.dx
        newPosition.y -= movement.dy

        let minX = size.width - mapSize.width
        let minY = size.height - mapSize.height

        newPosition.x = max(minX, min(0, newPosition.x))
        newPosition.y = max(minY, min(0, newPosition.y))

        background.position = newPosition

        updateGameObjects()
        updateHelperArrow()

        timeSinceStart += 1 / 60
        enemySpawnTimer += 1 / 60
        let spawnInterval = max(0.5, 5.0 - timeSinceStart / 15)
        if enemySpawnTimer >= spawnInterval {
            enemySpawnTimer = 0
            spawnEnemy()
        }
    }

    func spawnEnemy() {
        let margin: CGFloat = 100
        let spawnPosition = GameObjectNode.randomSpawnPosition(in: mapSize, margin: margin)

        let enemy = GameObjectNode(type: .enemyEagle)
        enemy.setScale(0.2)
        enemy.position = spawnPosition
        enemy.physicsBody = SKPhysicsBody(circleOfRadius: enemy.size.width / 2)
        enemy.physicsBody?.categoryBitMask = 2
        enemy.physicsBody?.contactTestBitMask = 2 | 1
        enemy.physicsBody?.collisionBitMask = 0
        enemy.physicsBody?.affectedByGravity = false

        background.addChild(enemy)
    }

    func updateGameObjects() {
        let objects = background.children.compactMap { $0 as? GameObjectNode }
        let eagleWorldPosition = CGPoint(
            x: -background.position.x + size.width / 2,
            y: -background.position.y + size.height / 2
        )
        for object in objects {
            object.update(towards: eagleWorldPosition)
        }
    }

    func didBegin(_ contact: SKPhysicsContact) {
        guard let nodeA = contact.bodyA.node, let nodeB = contact.bodyB.node else { return }

        // Если столкнулись два врага-орла — удалить обоих
        if let a = nodeA as? GameObjectNode, let b = nodeB as? GameObjectNode,
           a.type == .enemyEagle, b.type == .enemyEagle {
            a.removeFromParent()
            b.removeFromParent()
            return
        }

        // Проверить, участвует ли игрок в столкновении
        let isEagleA = nodeA == eagle
        let isEagleB = nodeB == eagle

        guard isEagleA || isEagleB else { return }

        // Найдём объект, не являющийся орлом
        let objectNode = isEagleA ? nodeB : nodeA

        if let obj = objectNode as? GameObjectNode {
            updateNearestHelper()
            gameManager.handleCollision(eagle: eagle, object: obj)

            if gameManager.health <= 0 {
                onGameOver?(gameManager.score)
                self.removeAllActions()
                self.removeAllChildren()
                self.physicsWorld.contactDelegate = nil
            }
        }
    }

    func updateNearestHelper() {
        nearestHelper = findNearestObject(ofType: .helper)
    }

    func updateHelperArrow() {
        guard let helper = nearestHelper else {
            helperArrow?.removeFromParent()
            helperArrow = nil
            return
        }

        let helperPositionInScene = convert(helper.position, from: background)

        if helperArrow == nil {
            helperArrow = NavigationArrow()
            addChild(helperArrow!)
        }

        helperArrow!.pointToward(target: helperPositionInScene, from: eagle.position)

        let offsetDistance: CGFloat = 120
        let angle = helperArrow!.zRotation + .pi / 2
        let direction = CGVector(dx: cos(angle), dy: sin(angle))
        helperArrow!.position = CGPoint(
            x: eagle.position.x + direction.dx * offsetDistance,
            y: eagle.position.y + direction.dy * offsetDistance
        )
    }

    func findNearestObject(ofType type: ObjectType) -> SKNode? {
        let objects = background.children.compactMap { $0 as? GameObjectNode }
        return objects.filter { $0.type == type }
            .sorted { $0.position.distance(to: eagle.position) < $1.position.distance(to: eagle.position) }
            .first
    }
}

extension CGPoint {
    func distance(to point: CGPoint) -> CGFloat {
        return hypot(self.x - point.x, self.y - point.y)
    }
}

extension GameScene {
    
    // Удаление всех объектов и очистка сцены после завершения игры
    func cleanupGame() {
        removeAllActions()
        removeAllChildren()
        physicsWorld.contactDelegate = nil
        helperArrow = nil
        nearestHelper = nil
        eagle = nil
        background = nil
    }
    
    // Полный перезапуск игры с новым орлом, картой и объектами
    func restartGame() {
        cleanupGame()
        gameManager.reset() // обнуление счёта, хп и т.д.
        isTurningLeft = false
        isTurningRight = false
        enemySpawnTimer = 0
        timeSinceStart = 0

        // Повторная инициализация
        physicsWorld.contactDelegate = self
        setupBackground()
        setupEagle()
        startSpawningObjects()
    }
}
