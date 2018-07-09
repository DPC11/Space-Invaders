//
//  MenuSecne.swift
//  daix_a5
//
//  Created by DPC on 16/2/19.
//  Copyright © 2016年 DPC. All rights reserved.
//

import SpriteKit

class MenuSecne: SKScene
{
    fileprivate let offset: CGFloat = 50
    fileprivate let scale: CGFloat = 0.92
    
    fileprivate var logoImage: SKSpriteNode!
    fileprivate var playButton: SKLabelNode!
    fileprivate var guideButton: SKLabelNode!
    fileprivate var playMusicButton: SKLabelNode!
    fileprivate var stopMusicButton: SKLabelNode!
    
    override func didMove(to view: SKView)
    {
        // Setup menu scene
        let logoImage = SKSpriteNode(imageNamed: "logo")
        logoImage.position = CGPoint(x: frame.midX, y: frame.midY + 3 * offset)
        logoImage.setScale(1.5)
        
        let backgroundImage = SKSpriteNode(imageNamed: "background")
        backgroundImage.position = CGPoint(x: frame.midX, y: frame.midY)
        backgroundImage.size = frame.size
        backgroundImage.zPosition = -1
        
        playButton = SKLabelNode(fontNamed: "Chalkduster")
        playButton.name = "Play"
        playButton.text = "Play"
        playButton.fontSize = 45
        playButton.position = CGPoint(x: frame.midX, y: frame.midY)
        
        guideButton = SKLabelNode(fontNamed: "Chalkduster")
        guideButton.name = "Guide Manual"
        guideButton.text = "Guide Manual"
        guideButton.fontSize = 25
        guideButton.position = CGPoint(x: frame.midX, y: frame.midY - 2 * offset)
        
        playMusicButton = SKLabelNode(fontNamed: "Chalkduster")
        playMusicButton.name = "Play Music"
        playMusicButton.text = "Play Music"
        playMusicButton.fontSize = 25
        playMusicButton.position = CGPoint(x: frame.midX, y: frame.midY - 3.5 * offset)
        
        stopMusicButton = SKLabelNode(fontNamed: "Chalkduster")
        stopMusicButton.name = "Stop Music"
        stopMusicButton.text = "Stop Music"
        stopMusicButton.fontSize = 25
        stopMusicButton.position = CGPoint(x: frame.midX, y: frame.midY - 3.5 * offset)
        
        if BackgroundMusic.sharedPlayer.shouldPlay() {
            BackgroundMusic.sharedPlayer.play()
            playMusicButton.isHidden = true
            stopMusicButton.isHidden = false
        } else {
            playMusicButton.isHidden = false
            stopMusicButton.isHidden = true
        }
        
        addChild(backgroundImage)
        addChild(logoImage)
        addChild(playButton)
        addChild(guideButton)
        addChild(playMusicButton)
        addChild(stopMusicButton)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        // Scale down the button when a touch begins and scale back when ended as a button pressed feedback
        for touch: AnyObject in touches {
            let node = atPoint(touch.location(in: self))
            if node.name == playButton.name {
                node.setScale(scale)
            } else if node.name == guideButton.name {
                node.setScale(scale)
            } else if node.name == playMusicButton.name {
                node.setScale(scale)
            } else if node.name == stopMusicButton.name {
                node.setScale(scale)
            }
        }
    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        // Respond to different events when a touch ended
        for touch: AnyObject in touches {
            let node = atPoint(touch.location(in: self))
            if node.name == playButton.name {
                node.setScale(1 / scale)
                
                view?.presentScene(Level1Scene(size: size), transition: SKTransition.reveal(with: .left, duration: 0.5))
            } else if node.name == guideButton.name {
                node.setScale(1 / scale)
                
                view?.presentScene(GuideScene(size: size), transition: SKTransition.flipHorizontal(withDuration: 0.5))
            } else if node.name == playMusicButton.name {
                node.setScale(1 / scale)
                
                BackgroundMusic.sharedPlayer.play()
                playMusicButton.isHidden = true
                stopMusicButton.isHidden = false
            } else if node.name == stopMusicButton.name {
                node.setScale(1 / scale)
                
                BackgroundMusic.sharedPlayer.stop()
                playMusicButton.isHidden = false
                stopMusicButton.isHidden = true
            }
        }
    }
}
