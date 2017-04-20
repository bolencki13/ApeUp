//
//  APUGameOverScene.swift
//  ApeUp
//
//  Created by Brian Olencki on 4/20/17.
//  Copyright © 2017 Brian Olencki. All rights reserved.
//

import SpriteKit

class APUGameOverScene: SKScene {
    var imgBackground: UIImage?
    
    init(size: CGSize, image: UIImage) {
        super.init(size: size)
        
        imgBackground = image
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        let background = SKSpriteNode.init(texture: SKTexture.init(image: imgBackground!) as SKTexture)
        background.position = CGPoint.init(x: 0, y: 0)
        background
    }
}
