//
//  GameScene.swift
//  CarGame
//
//  Created by selin eylül bilen on 4/02/21.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene,SKPhysicsContactDelegate {
    
    var Car = SKSpriteNode()
    var canMove = false
    var ToMoveLeft = true
    var CarAtRight = false
    var centerPoint : CGFloat!
    var score = 0

    let CarMinimumX :CGFloat = -180
    let CarMaximumX : CGFloat = 180

    var countDown = 1
    var stopEverything = true
    var scoreText = SKLabelNode()
    
    var gameSettings = Settings.sharedInstance
    
    override func didMove(to view: SKView) {
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        setUp()
        physicsWorld.contactDelegate = self
        Timer.scheduledTimer(timeInterval: TimeInterval(0.1), target: self, selector: #selector(GameScene.createRoadStrip), userInfo: nil, repeats: true)
        Timer.scheduledTimer(timeInterval: TimeInterval(1), target: self, selector: #selector(GameScene.startCountDown), userInfo: nil, repeats: true)
        Timer.scheduledTimer(timeInterval: TimeInterval(Helper().randomBetweenTwoNumbers(firstNumber: 0.8, secondNumber: 1.8)), target: self, selector: #selector(GameScene.leftTraffic), userInfo: nil, repeats: true)
        Timer.scheduledTimer(timeInterval: TimeInterval(0.5), target: self, selector: #selector(GameScene.removeItems), userInfo: nil, repeats: true)
        let deadTime = DispatchTime.now() + 1
        DispatchQueue.main.asyncAfter(deadline: deadTime) { 
            Timer.scheduledTimer(timeInterval: TimeInterval(1), target: self, selector: #selector(GameScene.increaseScore), userInfo: nil, repeats: true)
        }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        if canMove{
            move(leftSide:ToMoveLeft)
        }
        showRoadStrip()
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        var firstBody = SKPhysicsBody()
        var secondBody = SKPhysicsBody()
        if contact.bodyA.node?.name == "Car"{
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        }
        else{
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        firstBody.node?.removeFromParent()
        afterCollision()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if CarAtRight{
            CarAtRight = false
            ToMoveLeft = true
        }else{
            CarAtRight = true
            ToMoveLeft = false
        }
        canMove = true
        
    }
    
    func setUp(){
        Car = self.childNode(withName: "Car") as! SKSpriteNode
        centerPoint = self.frame.size.width / self.frame.size.height
        
        Car.physicsBody?.categoryBitMask = ColliderType.CAR_COLLIDER
        Car.physicsBody?.contactTestBitMask = ColliderType.ITEM_COLLIDER
        Car.physicsBody?.collisionBitMask = 0

        
        let scoreBackGround = SKShapeNode(rect:CGRect(x:-self.size.width/2 + 70 ,y:self.size.height/2 - 130 ,width:180,height:80), cornerRadius: 20)
        scoreBackGround.zPosition = 4
        scoreBackGround.fillColor = SKColor.black.withAlphaComponent(0.3)
        scoreBackGround.strokeColor = SKColor.black.withAlphaComponent(0.3)
        addChild(scoreBackGround)
        
        scoreText.name = "score"
        scoreText.fontName = "AvenirNext-Bold"
        scoreText.text = "0"
        scoreText.fontColor = SKColor.white
        scoreText.position = CGPoint(x: -self.size.width/2 + 160, y: self.size.height/2 - 110)
        scoreText.fontSize = 50
        scoreText.zPosition = 4
        addChild(scoreText)
    }
    
    @objc func createRoadStrip(){
        let leftRoadStrip = SKShapeNode(rectOf: CGSize(width: 10, height: 40))
        leftRoadStrip.strokeColor = SKColor.white
        leftRoadStrip.fillColor = SKColor.white
        leftRoadStrip.alpha = 0.4
        leftRoadStrip.name = "leftRoadStrip"
        leftRoadStrip.zPosition = 10
        leftRoadStrip.position.x = 0
        leftRoadStrip.position.y = 700
        addChild(leftRoadStrip)
    }
    
    func showRoadStrip(){
        
        enumerateChildNodes(withName: "leftRoadStrip", using: { (roadStrip, stop) in
            let strip = roadStrip as! SKShapeNode
            strip.position.y -= 30
        })
        
        enumerateChildNodes(withName: "barrier_bigger", using: { (leftCar, stop) in
            let car = leftCar as! SKSpriteNode
            car.position.y -= 15
        })
        
        enumerateChildNodes(withName: "truck", using: { (rightCar, stop) in
            let car = rightCar as! SKSpriteNode
            car.position.y -= 15
        })
        enumerateChildNodes(withName: "pedestrian", using: { (leftCar, stop) in
            let car = leftCar as! SKSpriteNode
            car.position.y -= 5
        })
    }

    @objc func removeItems(){
        for child in children{
            if child.position.y < -self.size.height - 100{
                child.removeFromParent()
            }
        }
    }
    
    func move(leftSide:Bool){
        if leftSide{
            Car.position.x -= 20
            if Car.position.x < CarMinimumX{
                Car.position.x = CarMinimumX
            }
        }else{
            Car.position.x += 20
            if Car.position.x > CarMaximumX{
                Car.position.x = CarMaximumX
            }
        }
    }
    
    
    @objc func leftTraffic(){
        if !stopEverything{
        let leftTrafficItem : SKSpriteNode!
        let randonNumber = Helper().randomBetweenTwoNumbers(firstNumber: 1, secondNumber: 8)
        switch Int(randonNumber) {
        case 1...4:
        leftTrafficItem = SKSpriteNode(imageNamed: "barrier_bigger")
        leftTrafficItem.name = "barrier_bigger"
            break
        case 5...8:
            leftTrafficItem = SKSpriteNode(imageNamed: "truck")
            leftTrafficItem.name = "truck"
            break
        default:
            leftTrafficItem = SKSpriteNode(imageNamed: "pedestrian")
            leftTrafficItem.name = "pedestrian"
        }
        leftTrafficItem.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        leftTrafficItem.zPosition = 10
        let randomNum = Helper().randomBetweenTwoNumbers(firstNumber: 1, secondNumber: 10)
        switch Int(randomNum) {
        case 1...4:
            leftTrafficItem.position.x = -150
            break
        case 5...10:
            leftTrafficItem.position.x = 100
            break
        default:
            leftTrafficItem.position.x = -280
        }
        leftTrafficItem.position.y = 700
        leftTrafficItem.physicsBody = SKPhysicsBody(circleOfRadius: leftTrafficItem.size.height/2)
        leftTrafficItem.physicsBody?.categoryBitMask = ColliderType.ITEM_COLLIDER
        leftTrafficItem.physicsBody?.collisionBitMask = 0
        leftTrafficItem.physicsBody?.affectedByGravity = false
        addChild(leftTrafficItem)
        }
    }
    
    func afterCollision(){
        if gameSettings.highScore < score{
            gameSettings.highScore = score
        }
        let menuScene = SKScene(fileNamed: "GameMenu")!
        menuScene.scaleMode = .aspectFill
        view?.presentScene(menuScene, transition: SKTransition.doorsCloseHorizontal(withDuration: TimeInterval(2)))
    }
    
    @objc func startCountDown(){
        if countDown>0{
            if countDown < 4{
                let countDownLabel = SKLabelNode()
                countDownLabel.fontName = "AvenirNext-Bold"
                countDownLabel.fontColor = SKColor.white
                countDownLabel.fontSize = 300
                countDownLabel.text = String(countDown)
                countDownLabel.position = CGPoint(x: 0, y: 0)
                countDownLabel.zPosition = 300
                countDownLabel.name = "cLabel"
                countDownLabel.horizontalAlignmentMode = .center
                addChild(countDownLabel)
                
                let deadTime = DispatchTime.now() + 0.5
                DispatchQueue.main.asyncAfter(deadline: deadTime, execute: { 
                    countDownLabel.removeFromParent()
                })
            }
            countDown += 1
            if countDown == 4 {
                self.stopEverything = false
            }
        }
    }
    
    @objc func increaseScore(){
        if !stopEverything{
            score += 1
            scoreText.text = String(score)
        }
    }

}
