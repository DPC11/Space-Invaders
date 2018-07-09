//
//  BackgroundMusic.swift
//  daix_a5
//
//  Created by DPC on 16/2/20.
//  Copyright © 2016年 DPC. All rights reserved.
//

import AVFoundation

class BackgroundMusic: NSObject
{
    // Play and stop background music through this player singleton
    static let sharedPlayer = BackgroundMusic()
    
    fileprivate var player: AVAudioPlayer!
    fileprivate var playing = true
    
    override init()
    {
        super.init()
        
        do {
            try player = AVAudioPlayer(contentsOf: Bundle.main.url(forResource: "backgroundMusic", withExtension: "mpeg")!)
        } catch {}
        player.numberOfLoops = -1
        player.prepareToPlay()
    }
    
    func play()
    {
        player.play()
        playing = true
    }
    
    func stop()
    {
        player.stop()
        playing = false
    }
    
    func shouldPlay() -> Bool
    {
        return playing
    }
}
