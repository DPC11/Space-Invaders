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
    private let offset: CGFloat = 50
    private let scale: CGFloat = 0.92
    
    private var logoImage: SKSpriteNode!
    private var playButton: SKLabelNode!
    private var guideButton: SKLabelNode!
    private var playMusicButton: SKLabelNode!
    private var stopMusicButton: SKLabelNode!
    
    override func didMoveToView(view: SKView)
    {
        // Setup menu scene
        let logoImage = SKSpriteNode(imageNamed: "logo")
        logoImage.position = CGPoint(x: CGRectGetMidX(frame), y: CGRectGetMidY(frame) + 3 * offset)
        logoImage.setScale(1.5)
        
        let backgroundImage = SKSpriteNode(imageNamed: "background")
        backgroundImage.position = CGPoint(x: CGRectGetMidX(frame), y: CGRectGetMidY(frame))
        backgroundImage.size = frame.size
        backgroundImage.zPosition = -1
        
        playButton = SKLabelNode(fontNamed: "Chalkduster")
        playButton.name = "Play"
        playButton.text = "Play"
        playButton.fontSize = 45
        playButton.position = CGPoint(x: CGRectGetMidX(frame), y: CGRectGetMidY(frame))
        
        guideButton = SKLabelNode(fontNamed: "Chalkduster")
        guideButton.name = "Guide Manual"
        guideButton.text = "Guide Manual"
        guideButton.fontSize = 25
        guideButton.position = CGPoint(x: CGRectGetMidX(frame), y: CGRectGetMidY(frame) - 2 * offset)
        
        playMusicButton = SKLabelNode(fontNamed: "Chalkduster")
        playMusicButton.name = "Play Music"
        playMusicButton.text = "Play Music"
        playMusicButton.fontSize = 25
        playMusicButton.position = CGPoint(x: CGRectGetMidX(frame), y: CGRectGetMidY(frame) - 3.5 * offset)
        
        stopMusicButton = SKLabelNode(fontNamed: "Chalkduster")
        stopMusicButton.name = "Stop Music"
        stopMusicButton.text = "Stop Music"
        stopMusicButton.fontSize = 25
        stopMusicButton.position = CGPoint(x: CGRectGetMidX(frame), y: CGRectGetMidY(frame) - 3.5 * offset)
        
        if BackgroundMusic.sharedPlayer.shouldPlay() {
            BackgroundMusic.sharedPlayer.play()
            playMusicButton.hidden = true
            stopMusicButton.hidden = false
        } else {
            playMusicButton.hidden = false
            stopMusicButton.hidden = true
        }
        
        addChild(backgroundImage)
        addChild(logoImage)
        addChild(playButton)
        addChild(guideButton)
        addChild(playMusicButton)
        addChild(stopMusicButton)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?)
    {
        // Scale down the button when a touch begins and scale back when ended as a button pressed feedback
        for touch: AnyObject in touches {
            let node = nodeAtPoint(touch.locationInNode(self))
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
    
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?)
    {
        // Respond to different events when a touch ended
        for touch: AnyObject in touches {
            let node = nodeAtPoint(touch.locationInNode(self))
            if node.name == playButton.name {
                node.setScale(1 / scale)
                
                view?.presentScene(Level1Scene(size: size), transition: SKTransition.revealWithDirection(.Left, duration: 0.5))
            } else if node.name == guideButton.name {
                node.setScale(1 / scale)
                
                view?.presentScene(GuideScene(size: size), transition: SKTransition.flipHorizontalWithDuration(0.5))
            } else if node.name == playMusicButton.name {
                node.setScale(1 / scale)
                
                BackgroundMusic.sharedPlayer.play()
                playMusicButton.hidden = true
                stopMusicButton.hidden = false
            } else if node.name == stopMusicButton.name {
                node.setScale(1 / scale)
                
                BackgroundMusic.sharedPlayer.stop()
                playMusicButton.hidden = false
                stopMusicButton.hidden = true
            }
        }
    }
}
