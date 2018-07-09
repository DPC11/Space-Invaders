//
//  GuideScene.swift
//  daix_a5
//
//  Created by DPC on 16/2/19.
//  Copyright © 2016年 DPC. All rights reserved.
//

import SpriteKit

class GuideScene: SKScene
{
    fileprivate let offset: CGFloat = 30
    fileprivate let scale: CGFloat = 0.92
    
    fileprivate var backButton: SKLabelNode!
    
    override func didMove(to view: SKView)
    {
        // Setup gudie scene
        let backgroundImage = SKSpriteNode(imageNamed: "background")
        backgroundImage.position = CGPoint(x: frame.midX, y: frame.midY)
        backgroundImage.size = frame.size
        backgroundImage.zPosition = -1
        
        let guideLabel1 = SKLabelNode(fontNamed: "Chalkduster")
        guideLabel1.text = "Same as the classic Space Invaders!"
        guideLabel1.fontSize = 14
        guideLabel1.position = CGPoint(x: frame.midX, y: frame.midY + 5 * offset)
        
        let guideLabel2 = SKLabelNode(fontNamed: "Chalkduster")
        guideLabel2.text = "Shoot at invader stay away from rock."
        guideLabel2.fontSize = 14
        guideLabel2.position = CGPoint(x: frame.midX, y: frame.midY + 4 * offset)
        
        let guideLabel3 = SKLabelNode(fontNamed: "Chalkduster")
        guideLabel3.text = "Tap arrows or darg ship to move,"
        guideLabel3.fontSize = 14
        guideLabel3.position = CGPoint(x: frame.midX, y: frame.midY + 3 * offset)
        
        let guideLabel4 = SKLabelNode(fontNamed: "Chalkduster")
        guideLabel4.text = "and tap anywhere else to shoot."
        guideLabel4.fontSize = 14
        guideLabel4.position = CGPoint(x: frame.midX, y: frame.midY + 2 * offset)
        
        let guideLabel5 = SKLabelNode(fontNamed: "Chalkduster")
        guideLabel5.text = "There are two levels to be completed,"
        guideLabel5.fontSize = 14
        guideLabel5.position = CGPoint(x: frame.midX, y: frame.midY + 1 * offset)
        
        let guideLabel6 = SKLabelNode(fontNamed: "Chalkduster")
        guideLabel6.text = "from easy to hard."
        guideLabel6.fontSize = 14
        guideLabel6.position = CGPoint(x: frame.midX, y: frame.midY)
        
        let guideLabel7 = SKLabelNode(fontNamed: "Chalkduster")
        guideLabel7.text = "Come on and have fun!"
        guideLabel7.fontSize = 14
        guideLabel7.position = CGPoint(x: frame.midX, y: frame.midY - 1 * offset)
        
        backButton = SKLabelNode(fontNamed: "Chalkduster")
        backButton.name = "Back"
        backButton.text = "Back"
        backButton.fontSize = 35
        backButton.position = CGPoint(x: frame.midX, y: frame.midY - 5 * offset)
        
        addChild(backgroundImage)
        addChild(guideLabel1)
        addChild(guideLabel2)
        addChild(guideLabel3)
        addChild(guideLabel4)
        addChild(guideLabel5)
        addChild(guideLabel6)
        addChild(guideLabel7)
        addChild(backButton)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        // Scale down the button when a touch begins and scale back when ended as a button pressed feedback
        for touch: AnyObject in touches {
            let node = atPoint(touch.location(in: self))
            if node.name == backButton!.name {
                node.setScale(scale)
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        // Respond to different events when a touch ended
        for touch: AnyObject in touches {
            let node = atPoint(touch.location(in: self))
            if node.name == backButton!.name {
                node.setScale(1 / scale)
                
                view?.presentScene(MenuSecne(size: size), transition: SKTransition.flipHorizontal(withDuration: 0.5))
            }
        }
    }
}
