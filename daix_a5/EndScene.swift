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
    fileprivate let offset: CGFloat = 30
    fileprivate let scale: CGFloat = 0.92
    
    fileprivate var endLabel: SKLabelNode!
    fileprivate var backButton: SKLabelNode!
    
    init(size: CGSize, won: Bool)
    {
        super.init(size: size)
        
        endLabel = SKLabelNode(fontNamed: "Chalkduster")
        endLabel.name = "EndLabel"
        endLabel.text = won ? "You cleared invaders!" : "You are defeated..."
        endLabel.fontSize = 25
        endLabel.position = CGPoint(x: frame.midX, y: frame.midY + 1 * offset)

        addChild(endLabel)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView)
    {
        // Setup end scene
        let backgroundImage = SKSpriteNode(imageNamed: "background")
        backgroundImage.position = CGPoint(x: frame.midX, y: frame.midY)
        backgroundImage.size = frame.size
        backgroundImage.zPosition = -1
        
        backButton = SKLabelNode(fontNamed: "Chalkduster")
        backButton.name = "Back"
        backButton.text = "Back"
        backButton.fontSize = 35
        backButton.position = CGPoint(x: frame.midX, y: frame.midY - 3 * offset)
        
        addChild(backgroundImage)
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
                
                view?.presentScene(MenuSecne(size: size), transition: SKTransition.push(with: .right, duration: 0.5))
            }
        }
    }
}

