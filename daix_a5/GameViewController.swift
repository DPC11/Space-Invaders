//
//  GameViewController.swift
//  daix_a5
//
//  Title: CP 469 - Assignment5
//  Author: Payton Dai 164177000
//  Email: daxi7000@mylaurier.ca
//  Created: 2016-02-19
//  Description: implement the simplest version of the classic computer game Space Invaders. Our earth is being invaded by alien ships, it is your job as a fighter jet pilot to shoot down the invaders and save the earth.

import UIKit
import SpriteKit

class GameViewController: UIViewController
{
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Configure the view.
        let skView = self.view as! SKView
        skView.showsFPS = true
        skView.showsNodeCount = true
        
        // Sprite Kit applies additional optimizations to improve rendering performance
        skView.ignoresSiblingOrder = true
        
        let menuScene = MenuSecne(size: view.frame.size)
        skView.presentScene(menuScene)
    }
    
    override func shouldAutorotate() -> Bool
    {
        return true
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask
    {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return .AllButUpsideDown
        } else {
            return .All
        }
    }
    
    override func prefersStatusBarHidden() -> Bool
    {
        return true
    }
}
