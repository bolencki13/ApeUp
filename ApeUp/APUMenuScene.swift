//
//  APUGameScene.swift
//  ApeUp
//
//  Created by Brian Olencki on 4/19/17.
//  Copyright © 2017 Brian Olencki. All rights reserved.
//

import SpriteKit
import UIKit

class APUMenuScene: APUBaseScene {
    var btnStart: UIButton?
    var lblTitle: UILabel?
    
    override func didMove(to view: SKView) {
        background()
        
        lblTitle = UILabel.init(frame: CGRect.init(x: 20, y: 45, width: (self.view?.frame.size.width)!-40, height: 60))
        lblTitle?.textAlignment = .center
        lblTitle?.textColor = UIColor(red: CGFloat(255.0 / 255.0), green: CGFloat(242.0 / 255.0), blue: CGFloat(204.0 / 255.0), alpha: CGFloat(1.0))
        lblTitle?.font = UIFont.boldSystemFont(ofSize: UIFont.systemFontSize+28)
        lblTitle?.adjustsFontSizeToFitWidth = true
        lblTitle?.text = "ApeUp"
        self.view?.addSubview(lblTitle!)
        
        btnStart = UIButton.init(frame: CGRect.init(x: (self.view!.frame.size.height-100)/2, y: self.view!.center.y, width: 100, height: 50))
        btnStart?.center = self.view!.center
        btnStart?.setTitle("Start", for: .normal)
        btnStart?.setTitleColor(UIColor(red: CGFloat(67.0 / 255.0), green: CGFloat(67.0 / 255.0), blue: CGFloat(67.0 / 255.0), alpha: CGFloat(1.0)), for: .normal)
        btnStart?.addTarget(self, action: #selector(startGame), for: .touchUpInside)
        btnStart?.backgroundColor = UIColor(red: CGFloat(255.0 / 255.0), green: CGFloat(242.0 / 255.0), blue: CGFloat(204.0 / 255.0), alpha: CGFloat(1.0))
        btnStart?.layer.cornerRadius = 8
        btnStart?.layer.borderWidth = 4
        btnStart?.layer.borderColor = UIColor(red: CGFloat(67.0 / 255.0), green: CGFloat(67.0 / 255.0), blue: CGFloat(67.0 / 255.0), alpha: CGFloat(1.0)).cgColor
        self.view?.addSubview(btnStart!)
        
        sprMonkey?.position = CGPoint.init(x: 80, y: (self.sprGround?.size.height)!-CGFloat(15))
    }
    
    func startGame() {
        UIView.animate(withDuration: 0.25, animations: { 
            self.btnStart?.alpha = 0.0
            self.lblTitle?.alpha = 0.0
        }) { (complete) in
            self.btnStart?.removeFromSuperview()
            self.lblTitle?.removeFromSuperview()
        }
        
        let nextScene = APUGameScene(size: self.size)
        nextScene.scaleMode = .resizeFill
        scene?.view?.presentScene(nextScene)
    }
}
