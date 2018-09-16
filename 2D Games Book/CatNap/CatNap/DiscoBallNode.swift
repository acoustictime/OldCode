//
//  DiscoBallNode.swift
//  CatNap
//
//  Created by James Small on 6/14/17.
//  Copyright © 2017 SmallJames. All rights reserved.
//

import SpriteKit
import AVFoundation

class DiscoBallNode: SKSpriteNode, EventListenerNode, InteractiveNode {
    
    private var player: AVPlayer!
    private var video: SKVideoNode!
    
    func didMoveToScene() {
        isUserInteractionEnabled = true
        
        let fileUrl = Bundle.main.url(forResource: "discolights-loop", withExtension: "mov")!
        player = AVPlayer(url: fileUrl)
        video = SKVideoNode(avPlayer: player)
        
        video.size = scene!.size
        video.position = CGPoint(x: scene!.frame.midX, y: scene!.frame.midY)
        video.zPosition = -1
        scene!.addChild(video)
        
        video.play()
        
        NotificationCenter.default.addObserver(self, selector: #selector(didReachEndOfVideo), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
    }
    
    func interact() {
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        interact()
    }
    
    func didReachEndOfVideo() {
        print("rewind")
        player.currentItem!.seek(to: kCMTimeZero)
        player.play()
    }
    
}


