//
//  GameScene.swift
//  ApeUp
//
//  Created by Brian Olencki on 4/19/17.
//  Copyright © 2017 Brian Olencki. All rights reserved.
//

import SpriteKit

class APUBaseScene: SKScene {
    public var sprMonkey: SKSpriteNode?
    public var sprGround: SKSpriteNode?
    private var aryBackground: NSMutableArray?
    private var actSkyForever: SKAction?
    private var aryTree: NSMutableArray?
    private var  actTreeForever: SKAction?
    public var treeSpeed = CGFloat(0.01)
    
    public let groundCategory: UInt32 = 0x1 << 6;

    
    public func background() {
        aryBackground = NSMutableArray.init()
        aryTree = NSMutableArray.init()

        sprMonkey = SKSpriteNode.init(texture: SKTexture.init(image: UIImage.init(named: "Monkey")!)) as SKSpriteNode
        sprMonkey?.name = "monkey"
        sprMonkey?.setScale(2.0)
        sprMonkey?.zPosition = 5
        self.addChild(sprMonkey!)
        
        let textSky = SKTexture.init(image: UIImage.init(named: "Background")!) as SKTexture
        
        let actSky = SKAction.moveBy(x: 0, y: -textSky.size().height, duration: TimeInterval(textSky.size().height*CGFloat(0.2))) as SKAction
        let actSkyReset = SKAction.moveBy(x: 0, y: textSky.size().height, duration: TimeInterval(0)) as SKAction
        actSkyForever = SKAction.repeatForever(SKAction.sequence([actSky,actSkyReset]))
        
        for i in 0 ..< NSInteger(CGFloat(2) + self.frame.size.height / textSky.size().height) {
            let sprSky = SKSpriteNode.init(texture: textSky) as SKSpriteNode
            sprSky.setScale(2.0)
            sprSky.anchorPoint = CGPoint(x: 0, y: 0)
            sprSky.position = CGPoint(x: 0, y: CGFloat(i) * sprSky.size.height);
            self.addChild(sprSky)
            aryBackground?.add(sprSky)
        }
        
        let textTree = SKTexture.init(image: UIImage.init(named: "Tree")!) as SKTexture
        
        let actTree = SKAction.moveBy(x: 0, y: -textTree.size().height, duration: TimeInterval(textTree.size().height*CGFloat(self.treeSpeed))) as SKAction
        let actTreeReset = SKAction.moveBy(x: 0, y: textTree.size().height, duration: TimeInterval(0)) as SKAction
        actTreeForever = SKAction.repeatForever(SKAction.sequence([actTree,actTreeReset]))
        
        for i in 0 ..< NSInteger(4) {
            let sprTree = SKSpriteNode.init(texture: textTree) as SKSpriteNode
            sprTree.setScale(2.0)
            sprTree.position = CGPoint(x: size.width/2, y: CGFloat(i) * sprTree.size.height);
            sprTree.zPosition = 1
            self.addChild(sprTree)
            aryTree?.add(sprTree)
        }
        
        let textGround = SKTexture.init(image: UIImage.init(named: "Ground")!) as SKTexture
        sprGround = SKSpriteNode.init(texture: textGround) as SKSpriteNode
        sprGround?.setScale(3.0)
        sprGround?.position = CGPoint(x: size.width/2, y: 40);
        sprGround?.zPosition = 2
        sprGround?.name = "ground"
        sprGround?.physicsBody = SKPhysicsBody.init(rectangleOf: CGSize.init(width: (sprGround?.size.width)!, height: (sprGround?.size.height)!/4), center: CGPoint.init(x: 0, y: 0))
        sprGround?.physicsBody?.isDynamic = false
        sprGround?.physicsBody?.categoryBitMask = groundCategory
        sprGround?.physicsBody?.allowsRotation = false
        sprGround?.physicsBody?.usesPreciseCollisionDetection = true
        self.addChild(sprGround!)
    }
    
    public func startBackground() {
        sprGround?.run(SKAction.moveBy(x: 0, y: -80, duration: 1.0))
        
        for sky in aryBackground! {
            (sky as! SKSpriteNode).run(actSkyForever!, withKey: "skyMove")
        }
        
        for tree in aryTree! {
            (tree as! SKSpriteNode).run(actTreeForever!, withKey: "treeMove")
        }
    }
    
    func stopBackground() {
        for sky in aryBackground! {
            (sky as! SKSpriteNode).removeAction(forKey: "skyMove")
        }
        
        for tree in aryTree! {
            (tree as! SKSpriteNode).removeAction(forKey: "treeMove")
        }
    }
}
