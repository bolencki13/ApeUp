//
//  APUGameScene.swift
//  ApeUp
//
//  Created by Brian Olencki on 4/19/17.
//  Copyright © 2017 Brian Olencki. All rights reserved.
//

import SpriteKit
import UIKit
class APUGameScene: APUBaseScene, SKPhysicsContactDelegate {
    private let monkeyOffset = CGFloat(SKTexture.init(image: UIImage.init(named: "Tree")!).size().width+5)
    private var sprContact: SKNode?
    private let kObstacleScore = CGFloat(200)
    private var lblScore: SKLabelNode?
    private var btnRetry: UIButton?
    public var score = Int(0) {
        didSet {
            lblScore?.text = "\(score)"
        }
    }
    
    let monkeyCategory: UInt32 = 0x1 << 0
    let branchCategory: UInt32 = 0x1 << 1
    let scoreCategory: UInt32 = 0x1 << 2
    let nullCategory: UInt32 = 0x1 << 13
    
    override func didMove(to view: SKView) {
        background()
        
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVector.init(dx: 0, dy: 0)
        
        lblScore = SKLabelNode.init(fontNamed: "AvenirNext-Bold")
        lblScore?.position = CGPoint.init(x: size.width-40, y: size.height-40)
        lblScore?.fontColor = UIColor.black
        lblScore?.horizontalAlignmentMode = .left
        lblScore?.zPosition = 100
        self.addChild(lblScore!)
        
        score = 0
        
        self.sprMonkey?.physicsBody = SKPhysicsBody.init(rectangleOf: (self.sprMonkey?.size)!)
        self.sprMonkey?.physicsBody?.isDynamic = true
        self.sprMonkey?.physicsBody?.categoryBitMask = monkeyCategory
        self.sprMonkey?.physicsBody?.contactTestBitMask = branchCategory | scoreCategory
        self.sprMonkey?.physicsBody?.collisionBitMask = branchCategory
        self.sprMonkey?.physicsBody?.allowsRotation = false
        self.sprMonkey?.physicsBody?.usesPreciseCollisionDetection = true
        
        self.sprMonkey?.position = CGPoint.init(x: 80, y: (self.sprGround?.size.height)!-CGFloat(15))
        self.sprMonkey?.run(SKAction.move(to: CGPoint.init(x: size.width/2-monkeyOffset, y: (self.sprGround?.size.height)!+CGFloat(50)), duration: 0.65), completion: {
            self.startBackground()
            self.run(SKAction.sequence([SKAction.wait(forDuration: 1.0),SKAction.repeatForever(SKAction.sequence([SKAction.perform(#selector(self.startObstacle), onTarget: self),SKAction.wait(forDuration: self.spacing())]))]), withKey: "obsSpawn")
        })
    }
    func crashAndExit() {
        if ((sprGround?.position.y)! > CGFloat(0)) {
            return
        }
        
        enumerateChildNodes(withName: "obs") { (node, pointer) in
            node.removeAction(forKey: "moveDown")
            let duration = (self.size.height+30-node.position.y)*0.001
            node.run(SKAction.sequence([SKAction.moveTo(y: self.size.height+30, duration: TimeInterval(duration)),SKAction.removeFromParent()]), withKey: "moveUp")
        }
        
        stopBackground()
        self.removeAction(forKey: "obsSpawn")        
        
        self.sprGround?.physicsBody?.collisionBitMask = monkeyCategory
        
        self.sprMonkey?.physicsBody?.collisionBitMask = groundCategory
        self.sprMonkey?.physicsBody?.contactTestBitMask = groundCategory
        self.sprMonkey?.run(SKAction.rotate(toAngle: CGFloat(Double.pi), duration: 0.25, shortestUnitArc: true))
        self.sprMonkey?.physicsBody?.isDynamic = true
        physicsWorld.gravity = CGVector.init(dx: 0, dy: -1)
        
        sprGround?.run(SKAction.moveBy(x: 0, y: 80, duration: 1.0))
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let point = touches.first?.location(in: self)

        if ((point?.x)! < size.width/2) {
            monkeyLeft()
        } else {
            monkeyRight()
        }
    }
    
    func monkeyLeft() {
        self.sprMonkey?.run(SKAction.move(to: CGPoint.init(x: size.width/2-monkeyOffset, y: (self.sprGround?.size.height)!+CGFloat(50)), duration: 0.2))
        if ((self.sprMonkey?.xScale)! <= CGFloat(0)) {
            self.run(SKAction.sequence([SKAction.wait(forDuration: 0.1),SKAction.run({
                self.sprMonkey?.xScale = (self.sprMonkey?.xScale)! * -1;
            })]))
        }
    }
    func monkeyRight() {
        self.sprMonkey?.run(SKAction.move(to: CGPoint.init(x: size.width/2+monkeyOffset, y: (self.sprGround?.size.height)!+CGFloat(50)), duration: 0.2))
        if ((self.sprMonkey?.xScale)! > CGFloat(0)) {
            self.run(SKAction.sequence([SKAction.wait(forDuration: 0.1),SKAction.run({
                self.sprMonkey?.xScale = (self.sprMonkey?.xScale)! * -1;
            })]))
        }
    }
    
    func startObstacle() {
        let obsPair = SKNode.init()
        obsPair.name = "obs"
        obsPair.position = CGPoint.init(x: 0, y: size.height+30);
        obsPair.zPosition = 2
        
        let sprBranch = SKSpriteNode.init(texture: SKTexture.init(image: UIImage.init(named: "Branch")!))
        sprBranch.physicsBody = SKPhysicsBody.init(rectangleOf: CGSize.init(width: sprBranch.size.width, height: sprBranch.size.height/2), center: CGPoint.init(x: 0, y: sprBranch.size.height/2-sprBranch.size.height/2))
        sprBranch.physicsBody?.isDynamic = false
        sprBranch.physicsBody?.categoryBitMask = branchCategory
        sprBranch.physicsBody?.contactTestBitMask = monkeyCategory
        sprBranch.physicsBody?.collisionBitMask = monkeyCategory
        sprBranch.name = "branch"
        obsPair.addChild(sprBranch)
        
        sprContact = SKNode.init()
        sprContact?.physicsBody = SKPhysicsBody.init(rectangleOf: (CGSize.init(width: kObstacleScore, height: sprBranch.size.height)))
        sprContact?.physicsBody?.isDynamic = false
        sprContact?.physicsBody?.categoryBitMask = scoreCategory
        sprContact?.physicsBody?.contactTestBitMask = monkeyCategory
        sprContact?.name = "score"
        obsPair.addChild(sprContact!)
      
        if (arc4random_uniform(10) < UInt32(5)) {
            sprBranch.position = CGPoint.init(x: size.width/2-sprBranch.size.width/5*3, y: 0)
            sprContact?.position = CGPoint.init(x: size.width/2+kObstacleScore/5*3, y: 0)
        } else {
            sprBranch.position = CGPoint.init(x: size.width/2+sprBranch.size.width/5*3, y: 0)
            sprBranch.xScale = sprBranch.xScale * CGFloat(-1)
            sprContact?.position = CGPoint.init(x: size.width/2-kObstacleScore/5*3, y: 0)
        }
        
        obsPair.run(SKAction.sequence([SKAction.moveTo(y: -30, duration: 7.0),SKAction.removeFromParent()]), withKey: "moveDown")
        self.addChild(obsPair)
    }
    func spacing() -> TimeInterval {
        return 2.0
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let nodes = NSArray.init(objects: (contact.bodyA.node!.name! as NSString), (contact.bodyB.node!.name! as NSString)) as NSArray
        
        if (nodes.contains("branch") && nodes.contains("monkey")) {
            crashAndExit()
            if let branch = contact.bodyA.node?.parent?.childNode(withName: "branch") {
                branch.physicsBody?.contactTestBitMask = nullCategory
            } else if let branch = contact.bodyB.node?.parent?.childNode(withName: "branch") {
                branch.physicsBody?.contactTestBitMask = nullCategory
            }
        } else if (nodes.contains("score") && nodes.contains("monkey")) {
            score += 1
            if let branch = contact.bodyA.node?.parent?.childNode(withName: "branch") {
                branch.physicsBody?.contactTestBitMask = nullCategory
            } else if let branch = contact.bodyB.node?.parent?.childNode(withName: "branch") {
                branch.physicsBody?.contactTestBitMask = nullCategory
            }
        } else if (nodes.contains("monkey") && nodes.contains("ground")) {
            if ((btnRetry) != nil) {
                return
            }
            btnRetry = UIButton.init(frame: CGRect.init(x: (self.view!.frame.size.height-100)/2, y: self.view!.center.y, width: 100, height: 50))
            btnRetry?.center = self.view!.center
            btnRetry?.setTitle("Retry", for: .normal)
            btnRetry?.setTitleColor(UIColor(red: CGFloat(67.0 / 255.0), green: CGFloat(67.0 / 255.0), blue: CGFloat(67.0 / 255.0), alpha: CGFloat(1.0)), for: .normal)
            btnRetry?.addTarget(self, action: #selector(retryGame), for: .touchUpInside)
            btnRetry?.backgroundColor = UIColor(red: CGFloat(255.0 / 255.0), green: CGFloat(242.0 / 255.0), blue: CGFloat(204.0 / 255.0), alpha: CGFloat(1.0))
            btnRetry?.layer.cornerRadius = 8
            btnRetry?.layer.borderWidth = 4
            btnRetry?.layer.borderColor = UIColor(red: CGFloat(67.0 / 255.0), green: CGFloat(67.0 / 255.0), blue: CGFloat(67.0 / 255.0), alpha: CGFloat(1.0)).cgColor
            self.view?.addSubview(btnRetry!)
        }
    }
    
    func retryGame() {
        self.btnRetry?.removeFromSuperview()
        self.btnRetry = nil
        
        let nextScene = APUGameScene(size: self.size)
        nextScene.scaleMode = .resizeFill
        scene?.view?.presentScene(nextScene)
    }
}
