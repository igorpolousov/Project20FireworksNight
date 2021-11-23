//
//  GameScene.swift
//  Project20FireworksNight
//  Day 70-71
//  Created by Igor Polousov on 22.11.2021.
//

import SpriteKit


class GameScene: SKScene {
    
    // Надпись с количеством очков
    var scoreLabel: SKLabelNode!
    
    // Надпись с новой игрой
    var newGameLabel: SKLabelNode!
    // Надпись игра окончена
    var gameOverLabel: SKLabelNode!
    // Переменная начала или конца игры
    var gameOver = false
    // Счетчик запусков
    var launchesCounter = 0
    
    // Таймер для запуска метода launchFireworks()
    var gameTimer: Timer?
    // Массив с нодами fireworks
    var fireworks = [SKNode]()
    
    // Начальные координаты старта fireworks
    let leftEdge = -22
    let bottomEdge = -22
    let rightEdge = 1024 + 22
    
    
    // Переменная с подсчетом очков со свойством наблюдателя
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    override func didMove(to view: SKView) {
        
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.position = CGPoint(x: 36, y: 36)
        scoreLabel.horizontalAlignmentMode = .left
        scoreLabel.fontColor = .red
        addChild(scoreLabel)
        
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
        
        newGameLabel = SKLabelNode(fontNamed: "Chalkduster")
        newGameLabel.position = CGPoint(x: 16, y: 700)
        newGameLabel.horizontalAlignmentMode = .left
        newGameLabel.fontColor = .red
        newGameLabel.text = "New Game"
        addChild(newGameLabel)
        
        startStopTimer()
        
        score = 0
        
    }
    
    // Функция запуска или остановки таймера
    func startStopTimer() {
        if !gameOver {
            gameTimer = Timer.scheduledTimer(timeInterval: 6, target: self, selector: #selector(launchFireworks), userInfo: nil, repeats: true)
        } else {
            gameTimer?.invalidate()
        }
    }
    
    // Создание фейерверка
    func createFireworks(xMovement: CGFloat, x: Int, y: Int) {
        // Создали ноду любого типа в точке x y
        let node = SKNode()
        node.position = CGPoint(x: x, y: y)
        
        // Создали firework и добавили его к ноде
        let firework = SKSpriteNode(imageNamed: "rocket")
        // указали это свойство чтобы цвет firework был не смешан с цветом ноды, на данный момент цвет картинки rocket -  белый
        firework.colorBlendFactor = 1
        firework.name = "firework"
        node.addChild(firework)
        
        // Указан цвет firework  случайным образом
        switch Int.random(in: 1...2) {
        case 1:
            firework.color = .cyan
        case 2:
            firework.color = .green
        default:
            firework.color = .red
        }
        // Добавлен путь Безье
        let path = UIBezierPath()
        // Установлена начальная точка координат на 0.0
        path.move(to: .zero)
        // Добавлена прямая линия с конечной точкой
        path.addLine(to: CGPoint(x: xMovement, y: 1000))
        // константа move в которой указан путь от точки и до точки, asOffset - чтобы координаты брались из path, orientToPath чтобы нода была ориентирована по линии path
        let move = SKAction.follow(path.cgPath, asOffset: true, orientToPath: true, speed: 150)
        node.run(move)
        
        // Добавлен огонек к firework кторый будет иммитировать пламя
        if let emitter = SKEmitterNode(fileNamed: "fuse") {
            emitter.position = CGPoint(x: 0, y: -22)
            node.addChild(emitter)
        }
        // Добавили ноду в массив fireworks ноды у нас 2 видов: fireworks и emitter
        fireworks.append(node)
        // Добавили ноду к parentNode
        addChild(node)
    }
    
    @objc func launchFireworks() {
        // Проверка счетчика запусков
        if launchesCounter < 5 {
            launchesCounter += 1
            print(launchesCounter)
            
            let movementAmount: CGFloat = 1800
            // Создание fireworks случайным образом
            switch Int.random(in: 0...3) {
            case 0 :
                createFireworks(xMovement: 0, x: 512, y: bottomEdge)
                createFireworks(xMovement: 0, x: 512 - 200, y: bottomEdge)
                createFireworks(xMovement: 0, x: 512 - 100, y: bottomEdge)
                createFireworks(xMovement: 0, x: 512 + 100, y: bottomEdge)
                createFireworks(xMovement: 0, x: 512 + 200, y: bottomEdge)
                
            case 1:
                createFireworks(xMovement: 0, x: 512, y: bottomEdge)
                createFireworks(xMovement: -200, x: 512 - 200, y: bottomEdge)
                createFireworks(xMovement: -100, x: 512 - 100, y: bottomEdge)
                createFireworks(xMovement: +200, x: 512 + 100, y: bottomEdge)
                createFireworks(xMovement: +100, x: 512 + 200, y: bottomEdge)
                
            case 2:
                createFireworks(xMovement: movementAmount, x: leftEdge, y: bottomEdge + 400)
                createFireworks(xMovement: movementAmount, x: leftEdge, y: bottomEdge + 300)
                createFireworks(xMovement: movementAmount, x: leftEdge, y: bottomEdge + 200)
                createFireworks(xMovement: movementAmount, x: leftEdge, y: bottomEdge + 100)
                createFireworks(xMovement: movementAmount, x: leftEdge, y: bottomEdge)
                
            case 3:
                createFireworks(xMovement: -movementAmount, x: rightEdge, y: bottomEdge + 400)
                createFireworks(xMovement: -movementAmount, x: rightEdge, y: bottomEdge + 300)
                createFireworks(xMovement: -movementAmount, x: rightEdge, y: bottomEdge + 200)
                createFireworks(xMovement: -movementAmount, x: rightEdge, y: bottomEdge + 100)
                createFireworks(xMovement: -movementAmount, x: rightEdge, y: bottomEdge)
                
            default:
                break
            }
            // Если количество запусков 5 или больше тогда game over
        } else {
            gameOver = true
            startStopTimer()
            gameOverLabel = SKLabelNode(fontNamed: "Chalkduster")
            gameOverLabel.position = CGPoint(x: 150, y: 400)
            gameOverLabel.text = "Game Over"
            gameOverLabel.fontSize = 120
            gameOverLabel.horizontalAlignmentMode = .left
            addChild(gameOverLabel)
        }
    }
    
    // Функция которая отфильтровует прикосновения к нодам, потому что когда ноды расположены одна над другой, при касании определяются все сразу
    func checkTouches(_ touches: Set<UITouch>) {
        // Определили касание и ноды в месте касания
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let nodesAtPoint = nodes(at: location)
        // В случае если node как spriteNode в точке касания
        for case let node as SKSpriteNode in nodesAtPoint {
            // Если имя ноды firework тогда пропустить цикл иначе продолжить, нужно чтобы отфильтровать касание одновременно к двум нодам, Переход к MARK!
            guard node.name == "firework" else { continue }
            
            for parent in fireworks {
                // Проверка что нода не является родительской нодой, переход к MARK!
                guard let firework = parent.children.first as? SKSpriteNode else { continue }
                // Если нода имеет имя selected и цвет не равен цвету ноды
                if firework.name == "selected" && firework.color != node.color {
                    firework.name = "firework"
                    firework.colorBlendFactor = 1
                }
            }
            // MARK!
            // Имя ноды становится selected
            node.name = "selected"
            // Цвет ноды становится равным начальному цвету белый
            node.colorBlendFactor = 0
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        checkTouches(touches)
        
        // Проверка касания к newGame для запуска новой игры
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let object = nodes(at: location)
        
        if gameOver && object.contains(newGameLabel) {
            score = 0
            launchesCounter = 0
            gameOver = false
            gameOverLabel.removeFromParent()
            startStopTimer()
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        checkTouches(touches)
    }
    
    // Метод, который делает update по нодам в родительской ноде
    override func update(_ currentTime: TimeInterval) {
        // Удаляем ноды которые ушли за экран
        for (index,firework) in fireworks.enumerated().reversed() {
            // Если позиция по y более 900
            if firework.position.y > 900 {
                // удалить из массива
                fireworks.remove(at: index)
                // удалить из родительской ноды
                firework.removeFromParent()
            }
        }
    }
    
    // Указание что будет с ракетой если будет взрыв
    func explode(firework: SKNode) {
        let duration = SKAction.wait(forDuration: 1)
        let remove = SKAction.removeFromParent()
        let sequence = SKAction.sequence([duration, remove])
        
        if let emitter = SKEmitterNode(fileNamed: "explode") {
            emitter.position = firework.position
            addChild(emitter)
            emitter.run(sequence)
        }
       
        firework.run(sequence)
    }
   
    
    func explodeFireworks() {
        var numExploded = 0

        for (index, fireworkContainer) in fireworks.enumerated().reversed() {
            guard let firework = fireworkContainer.children.first as? SKSpriteNode else { continue }
            
            if firework.name == "selected" {
                explode(firework: fireworkContainer)
                fireworks.remove(at: index)
                numExploded += 1
            }
        }
        
        switch numExploded {
        case 0:
            break
        case 1:
            score += 100
        case 2:
            score += 500
        case 3:
            score += 1500
        case 4:
            score += 2500
        default:
            score += 4000
        }
    }
    
    
    
}
