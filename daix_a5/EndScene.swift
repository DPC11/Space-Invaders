//
//  EndScene.swift
//  daix_a5
//
//  Created by DPC on 16/2/21.
//  Copyright © 2016年 DPC. All rights reserved.
//

import SpriteKit

class EndScene: SKScene
{
    private let offset: CGFloat = 30
    private let scale: CGFloat = 0.92
    
    private var endLabel: SKLabelNode!
    private var backButton: SKLabelNode!
    
    init(size: CGSize, won: Bool)
    {
        super.init(size: size)
        
        endLabel = SKLabelNode(fontNamed: "Chalkduster")
        endLabel.name = "EndLabel"
        endLabel.text = won ? "You cleared invaders!" : "You are defeated..."
        endLabel.fontSize = 25
        endLabel.position = CGPoint(x: CGRectGetMidX(frame), y: CGRectGetMidY(frame) + 1 * offset)

        addChild(endLabel)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToView(view: SKView)
    {
        // Setup end scene
        let backgroundImage = SKSpriteNode(imageNamed: "background")
        backgroundImage.position = CGPoint(x: CGRectGetMidX(frame), y: CGRectGetMidY(frame))
        backgroundImage.size = frame.size
        backgroundImage.zPosition = -1
        
        backButton = SKLabelNode(fontNamed: "Chalkduster")
        backButton.name = "Back"
        backButton.text = "Back"
        backButton.fontSize = 35
        backButton.position = CGPoint(x: CGRectGetMidX(frame), y: CGRectGetMidY(frame) - 3 * offset)
        
        addChild(backgroundImage)
        addChild(backButton)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?)
    {
        // Scale down the button when a touch begins and scale back when ended as a button pressed feedback
        for touch: AnyObject in touches {
            let node = nodeAtPoint(touch.locationInNode(self))
            if node.name == backButton!.name {
                node.setScale(scale)
            }
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?)
    {
        // Respond to different events when a touch ended
        for touch: AnyObject in touches {
            let node = nodeAtPoint(touch.locationInNode(self))
            if node.name == backButton!.name {
                node.setScale(1 / scale)
                
                view?.presentScene(MenuSecne(size: size), transition: SKTransition.pushWithDirection(.Right, duration: 0.5))
            }
        }
    }
}

