//
//  Level1Scene.swift
//  daix_a5
//
//  Created by DPC on 16/2/20.
//  Copyright © 2016年 DPC. All rights reserved.
//

import SpriteKit

class Level1Scene: SKScene, SKPhysicsContactDelegate
{
    fileprivate let offset: CGFloat = 40
    fileprivate let scale: CGFloat = 0.92
    fileprivate let shipMove: CGFloat = 15
    fileprivate let moveInterval: CFTimeInterval = 1
    fileprivate let rockRate: UInt32 = 5   // Means invader shoot nearly a rock every 5 moveIntervals
    
    fileprivate var invaderMove: CGFloat = 22
    fileprivate var lastMoveTime: CFTimeInterval = 0
    fileprivate var groundLine: CGFloat!   // The ground line of playing area
    fileprivate var shipNode: SKSpriteNode!
    fileprivate var invaderNode: SKSpriteNode!
    fileprivate var leftButton: SKSpriteNode!
    fileprivate var rightButton: SKSpriteNode!
    
    override func didMove(to view: SKView)
    {
        groundLine = frame.minY + 2.2 * offset
        
        // Set the physical world
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        physicsWorld.contactDelegate = self
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        physicsBody?.categoryBitMask = PhysicsCategory.SceneCategory
        
        // Setup game level 1 scene
        let backgroundImage = SKSpriteNode(imageNamed: "background")
        backgroundImage.position = CGPoint(x: frame.midX, y: frame.midY)
        backgroundImage.size = frame.size
        backgroundImage.zPosition = -1
        
        shipNode = SKSpriteNode(imageNamed: "ship")
        shipNode.name = "ShipNode"
        shipNode.position = CGPoint(x: frame.midX, y: groundLine)
        shipNode.physicsBody = SKPhysicsBody(rectangleOf: shipNode.size)
        shipNode.physicsBody?.categoryBitMask = PhysicsCategory.ShipCategory
        shipNode.physicsBody?.collisionBitMask = PhysicsCategory.SceneCategory
        
        invaderNode = SKSpriteNode(imageNamed: "invader1")
        invaderNode.name = "InvaderNode"
        invaderNode.position = CGPoint(x: frame.midX, y: frame.maxY - 1.5 * offset)
        invaderNode.physicsBody = SKPhysicsBody(rectangleOf: invaderNode.size)
        invaderNode.physicsBody?.categoryBitMask = PhysicsCategory.InvaderCategory
        invaderNode.physicsBody?.collisionBitMask = PhysicsCategory.None
        
        leftButton = SKSpriteNode(imageNamed: "left")
        leftButton.name = "LeftButton"
        leftButton.anchorPoint = CGPoint(x: 0, y: 0)
        leftButton.position = CGPoint(x: frame.minX, y: frame.minY)
        
        rightButton = SKSpriteNode(imageNamed: "right")
        rightButton.name = "RightButton"
        rightButton.anchorPoint = CGPoint(x: 1, y: 0)
        rightButton.position = CGPoint(x: frame.maxX, y: frame.minY)
        rightButton.setScale(1.12)
        
        addChild(backgroundImage)
        addChild(shipNode)
        addChild(invaderNode)
        addChild(leftButton)
        addChild(rightButton)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        // Scale down the button when a touch begins and scale back when ended as a button pressed feedback
        for touch: AnyObject in touches {
            let node = atPoint(touch.location(in: self))
            if node.name == leftButton!.name {
                node.setScale(scale)
            } else if node.name == rightButton!.name {
                node.setScale(scale)
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        for touch: AnyObject in touches {
            let node = atPoint(touch.location(in: self))
            if node.name == leftButton!.name {
                node.setScale(1 / scale)
                
                shipNode.position.x -= shipMove
            } else if node.name == rightButton!.name {
                node.setScale(1 / scale)

                shipNode.position.x += shipMove
            } else {
                shipShoot()
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        for touch: AnyObject in touches {
            let node = atPoint(touch.location(in: self))
            if node.name == shipNode!.name {
                shipNode.position.x = touch.location(in: self).x
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval)
    {
        if currentTime - lastMoveTime >= moveInterval {
            lastMoveTime = currentTime
            
            if childNode(withName: invaderNode.name!) != nil {
                
                // Update the invader's movement
                if invaderNode.position.x <= frame.minX || invaderNode.position.x >= frame.maxX {
                    invaderMove = -invaderMove
                    invaderNode.position = CGPoint(x: invaderNode.position.x + invaderMove, y: invaderNode.position.y + invaderMove)
                } else {
                    invaderNode.position.x += invaderMove
                }
                
                // Invader shoot a rock
                if arc4random_uniform(rockRate) == 0 {
                    invaderRock()
                }
            }
        }
    }
    
    // MARK: Physics contact delegate
    func didBegin(_ contact: SKPhysicsContact)
    {
        let nodeNames = [contact.bodyA.node!.name!, contact.bodyB.node!.name!]
        
        // Ship shoot at invader
        if (nodeNames as NSArray).contains(invaderNode.name!) {
            contact.bodyA.node!.removeFromParent()
            contact.bodyB.node!.removeFromParent()
            
            let explosionNode = SKSpriteNode(imageNamed: "explosion1-invader")
            explosionNode.position = invaderNode.position
            addChild(explosionNode)
            
            // Play explosion animation and sound then transit to level2 scene
            explosionNode.run(SKAction.group([SKAction.repeat(SKAction.animate(with: [(SKTexture(imageNamed: "explosion1-invader")), (SKTexture(imageNamed: "explosion2-invader"))], timePerFrame: 0.2), count: 5), SKAction.playSoundFileNamed("explosion.wav", waitForCompletion: true)]), completion: {
                self.view?.presentScene(Level2Scene(size: self.size), transition: SKTransition.push(with: .left, duration: 0.5))
                })

            
        // Invader shoot rock at ship
        } else if ((nodeNames as NSArray).contains(shipNode.name!)) {
            contact.bodyA.node!.removeFromParent()
            contact.bodyB.node!.removeFromParent()
            
            let explosionNode = SKSpriteNode(imageNamed: "explosion1-ship")
            explosionNode.position = shipNode.position
            addChild(explosionNode)
            
            // Play explosion animation and sound then transit to end scene
            explosionNode.run(SKAction.group([SKAction.repeat(SKAction.animate(with: [(SKTexture(imageNamed: "explosion1-ship")), (SKTexture(imageNamed: "explosion2-ship"))], timePerFrame: 0.2), count: 5), SKAction.playSoundFileNamed("explosion.wav", waitForCompletion: true)]), completion: {
                self.view?.presentScene(EndScene(size: self.size, won: false), transition: SKTransition.moveIn(with: .right, duration: 0.5))
                })
        }
    }
    
    // MARK: Other helper functions
    func invaderRock()
    {
        let rockNode = SKSpriteNode(imageNamed: "rock")
        rockNode.name = "Rock"
        rockNode.position = invaderNode.position
        rockNode.physicsBody = SKPhysicsBody(rectangleOf: rockNode.size)
        rockNode.physicsBody?.categoryBitMask = PhysicsCategory.RockCategory
        rockNode.physicsBody?.isDynamic = true
        rockNode.physicsBody?.contactTestBitMask = PhysicsCategory.ShipCategory
        rockNode.physicsBody?.collisionBitMask = PhysicsCategory.None
        
        let rockAction = SKAction.sequence([SKAction.move(to: CGPoint(x: invaderNode.position.x, y: groundLine), duration: 1.5), SKAction.removeFromParent()])
        let soundAction = SKAction.playSoundFileNamed("rock", waitForCompletion: true)
        
        rockNode.run(SKAction.group([rockAction, soundAction]))
        addChild(rockNode)
    }
    
    func shipShoot()
    {
        // Ship shoot need time to reload until the last shoot has gone
        if childNode(withName: "Shoot") == nil {
            let shootNode = SKSpriteNode(imageNamed: "shoot")
            shootNode.name = "Shoot"
            shootNode.position = shipNode.position
            shootNode.physicsBody = SKPhysicsBody(rectangleOf: shootNode.size)
            shootNode.physicsBody?.isDynamic = true
            shootNode.physicsBody?.categoryBitMask = PhysicsCategory.ShootCategory
            shootNode.physicsBody?.contactTestBitMask = PhysicsCategory.InvaderCategory
            shootNode.physicsBody?.collisionBitMask = PhysicsCategory.None
            
            let shootAction = SKAction.sequence([SKAction.move(to: CGPoint(x: shipNode.position.x, y: frame.maxY), duration: 2), SKAction.removeFromParent()])
            let soundAction = SKAction.playSoundFileNamed("shoot", waitForCompletion: true)
            
            shootNode.run(SKAction.group([shootAction, soundAction]))
            addChild(shootNode)
        }
    }
}
