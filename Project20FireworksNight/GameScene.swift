//
//  GameScene.swift
//  Project20FireworksNight
//
//  Created by Igor Polousov on 22.11.2021.
//

import SpriteKit


class GameScene: SKScene {
    
    var scoreLabel: SKLabelNode!
    var gameTimer: Timer?
    var fireworks = [SKNode]()
    
    let leftEdge = -22
    let bottomEdge = -22
    let rightEdge = 1024 + 22
    
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    override func didMove(to view: SKView) {
        
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: 512, y: 385)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
      
    }
    
}
