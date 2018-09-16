//
//  Firebug.swift
//  PestControl
//
//  Created by James Small on 6/20/17.
//  Copyright © 2017 Razeware LLC. All rights reserved.
//

import SpriteKit

class Firebug: Bug {
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  override init() {
    super.init()
    name = "Firebug"
    color = .red
    colorBlendFactor  = 0.8
    physicsBody?.categoryBitMask = PC.FireBug
  }
}
