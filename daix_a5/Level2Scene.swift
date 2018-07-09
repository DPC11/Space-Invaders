//
//  Level2Scene.swift
//  daix_a5
//
//  Created by DPC on 16/2/22.
//  Copyright © 2016年 DPC. All rights reserved.
//

import SpriteKit

class Level2Scene: SKScene, SKPhysicsContactDelegate
{
    fileprivate let offset: CGFloat = 42
    fileprivate let scale: CGFloat = 0.92
    fileprivate let shipMove: CGFloat = 15
    fileprivate let moveInterval: CFTimeInterval = 0.8
    fileprivate let rockRate: UInt32 = 5   // Means invader shoot nearly a rock every 5 moveIntervals
    fileprivate let invaderMove: CGFloat = 22
    
    fileprivate var moveRight = true
    fileprivate var lastMoveTime: CFTimeInterval = 0
    fileprivate var groundLine: CGFloat!   // The ground line of playing area
    fileprivate var shipNode: SKSpriteNode!
    fileprivate var invaderNodeName = "InvaderNode"
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
        addChild(leftButton)
        addChild(rightButton)
        
        addInvaders()
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
            
            // Gather all alive invaderNode
            var invaderNodes: [SKNode?] = []
            enumerateChildNodes(withName: invaderNodeName, using: { (invaderNode: SKNode, stop: UnsafeMutablePointer<ObjCBool>) -> Void in
                invaderNodes.append(invaderNode)
                })
            
            if invaderNodes.count > 0 {
                
                // Update invaders' movement
                if (invaderNodes.first!?.position.x)! <= frame.minX {
                    
                    enumerateChildNodes(withName: invaderNodeName, using: { (invaderNode: SKNode, stop: UnsafeMutablePointer<ObjCBool>) -> Void in
                        invaderNode.position.x += self.invaderMove
                        if !self.moveRight {
                            invaderNode.position.y += self.invaderMove
                        }})
                    self.moveRight = true
                } else if (invaderNodes.last!?.position.x)! >= frame.maxX {
                    enumerateChildNodes(withName: invaderNodeName, using: { (invaderNode: SKNode, stop: UnsafeMutablePointer<ObjCBool>) -> Void in
                        invaderNode.position.x -= self.invaderMove
                        if self.moveRight {
                            invaderNode.position.y -= self.invaderMove
                        }})
                    self.moveRight = false
                } else {
                    enumerateChildNodes(withName: invaderNodeName, using: { (invaderNode: SKNode, stop: UnsafeMutablePointer<ObjCBool>) -> Void in
                        invaderNode.position.x += (self.moveRight ? self.invaderMove : -self.invaderMove)
                    })
                }

                // Choose one invader to shoot a rock randomly
                if arc4random_uniform(rockRate) == 0 {
                    invaderRock(invaderNodes[Int(arc4random_uniform(UInt32(invaderNodes.count)))]!)
                }
            }
        }
    }
    
    // MARK: Physics contact delegate
    func didBegin(_ contact: SKPhysicsContact)
    {
        // There are bugs when one shoot attack at two invaders at the same time
        if contact.bodyA.node == nil || contact.bodyB.node == nil {
            return
        }
        let nodeNames = [contact.bodyA.node!.name!, contact.bodyB.node!.name!]
        
        // Ship shoot at invader
        if (nodeNames as NSArray).contains(invaderNodeName) {
            
            let explosionNode = SKSpriteNode(imageNamed: "explosion1-invader")
            if contact.bodyA.node!.name == invaderNodeName {
                explosionNode.position = contact.bodyA.node!.position
            } else {
                explosionNode.position = contact.bodyB.node!.position
            }
            contact.bodyA.node!.removeFromParent()
            contact.bodyB.node!.removeFromParent()
            addChild(explosionNode)
            
            // Play explosion animation and sound
            if childNode(withName: invaderNodeName) != nil {
                let explosionAction = SKAction.sequence([SKAction.repeat(SKAction.animate(with: [(SKTexture(imageNamed: "explosion1-invader")), (SKTexture(imageNamed: "explosion2-invader"))], timePerFrame: 0.2), count: 3), SKAction.removeFromParent()])

                explosionNode.run(SKAction.group([explosionAction, SKAction.playSoundFileNamed("explosion.wav", waitForCompletion: true)]))
            } else {
                
                // If all invaders are cleared then transit to end scene
                explosionNode.run(SKAction.group([SKAction.repeat(SKAction.animate(with: [(SKTexture(imageNamed: "explosion1-invader")), (SKTexture(imageNamed: "explosion2-invader"))], timePerFrame: 0.2), count: 5), SKAction.playSoundFileNamed("explosion.wav", waitForCompletion: true)]), completion: {
                    self.view?.presentScene(EndScene(size: self.size, won: true), transition: SKTransition.moveIn(with: .right, duration: 0.5))
                })
            }

            // Invader shoot rock at ship
        } else if ((nodeNames as NSArray).contains(shipNode.name!)) {
            contact.bodyA.node!.removeFromParent()
            contact.bodyB.node!.removeFromParent()
            
            let explosionNode = SKSpriteNode(imageNamed: "explosion1-ship")
            explosionNode.position = shipNode.position
            addChild(explosionNode)
            
            // Play explosion animation and sound and transit to end scene
            explosionNode.run(SKAction.group([SKAction.repeat(SKAction.animate(with: [(SKTexture(imageNamed: "explosion1-ship")), (SKTexture(imageNamed: "explosion2-ship"))], timePerFrame: 0.2), count: 5), SKAction.playSoundFileNamed("explosion.wav", waitForCompletion: true)]), completion: {
                self.view?.presentScene(EndScene(size: self.size, won: false), transition: SKTransition.moveIn(with: .right, duration: 0.5))
                })
        }
    }
    
    // MARK: Other helper functions
    func addInvaders()
    {
        let invaderRow = 3
        let invaderColumn = 6
        
        for i in 0 ..< invaderRow {
            for j in 0 ..< invaderColumn {
                let invaderNode = SKSpriteNode(imageNamed: "invader\(i % 3 + 1)")
                invaderNode.name = invaderNodeName
                invaderNode.position = CGPoint(x: frame.midX + (CGFloat(j) - CGFloat(invaderColumn) / 2) * offset, y: frame.maxY - (CGFloat(i) * 0.8 + 1) * offset)
                invaderNode.physicsBody = SKPhysicsBody(rectangleOf: invaderNode.size)
                invaderNode.physicsBody?.categoryBitMask = PhysicsCategory.InvaderCategory
                invaderNode.physicsBody?.collisionBitMask = PhysicsCategory.None
                
                addChild(invaderNode)
            }
        }
    }
    
    func invaderRock(_ invaderNode: SKNode)
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
