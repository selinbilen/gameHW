//
//  GameMenu.swift
//  CarGame
//
//  Created by selin eylül bilen on 4/02/21.
//

import Foundation
import SpriteKit


class GameMenu: SKScene{
    
    var startGame = SKLabelNode()
    var bestScore = SKLabelNode()
    var diff = SKLabelNode()
    var current_diff = SKLabelNode()
    var gameSettings = Settings.sharedInstance
    
    override func didMove(to view: SKView) {
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        startGame = self.childNode(withName: "startGame") as! SKLabelNode
        bestScore = self.childNode(withName: "bestScore") as! SKLabelNode
        diff = self.childNode(withName: "diff") as! SKLabelNode
        current_diff = self.childNode(withName: "current_diff") as! SKLabelNode
        
        current_diff.text = "Easy"
        bestScore.text = "Best Score: \(gameSettings.highScore)"
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches{
            let touchLocation = touch.location(in: self)
            if  atPoint(touchLocation).name == "diff"{
                if current_diff.text == "Easy"{
                    current_diff.text = "Hard"
                }
                else{
                    current_diff.text = "Easy"
                }
            }
            if atPoint(touchLocation).name == "startGame" && current_diff.text == "Easy"{
                let gameScene = SKScene(fileNamed: "GameScene")!
                gameScene.scaleMode = .aspectFill
                view?.presentScene(gameScene, transition: SKTransition.doorsOpenHorizontal(withDuration: TimeInterval(2)))
            }
            if atPoint(touchLocation).name == "startGame" && current_diff.text == "Hard"{
                let gameScene = SKScene(fileNamed: "GameScene_harder")!
                gameScene.scaleMode = .aspectFill
                view?.presentScene(gameScene, transition: SKTransition.doorsOpenHorizontal(withDuration: TimeInterval(2)))
            }
        }
    }
}
