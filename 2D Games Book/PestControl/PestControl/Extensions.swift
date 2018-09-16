//
//  Extensions.swift
//  PestControl
//
//  Created by James Small on 6/19/17.
//  Copyright © 2017 Razeware LLC. All rights reserved.
//

import SpriteKit

extension SKTexture {
  convenience init(pixelImageNamed: String) {
    self.init(imageNamed: pixelImageNamed)
    self.filteringMode = .nearest 
  }
}
