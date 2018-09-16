//
//  AnalogControl.swift
//  CircuitRacer
//
//  Created by James Small on 9/24/15.
//  Copyright © 2015 SmallJames. All rights reserved.
//

import UIKit

protocol AnalogControlPositionChange {
    func analogControlPositionChanged(analogControl: AnalogControl,position: CGPoint)
}

class AnalogControl: UIView {

    let baseCenter: CGPoint
    let knobImageView: UIImageView
    private var relativePosition: CGPoint!
    var delegate: AnalogControlPositionChange?
    
    func updateKnobWithPosition(position: CGPoint) {
        //1
        var positionToCenter = position - baseCenter
        var direction: CGPoint
        
        if positionToCenter == CGPointZero {
            direction = CGPointZero
        } else {
            direction = positionToCenter.normalized()
        }
        
        //2
        let radius = frame.size.width / 2
        var length = positionToCenter.length()
        
        //3
        if length > radius {
            length = radius
            positionToCenter = direction * radius
        }
        
        let relPosition = CGPoint(x: direction.x * (length/radius), y: direction.y * (length/radius))
        knobImageView.center = baseCenter + positionToCenter
        relativePosition = relPosition
        delegate?.analogControlPositionChanged(self, position: relativePosition)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touchLocation = (touches.first! as UITouch).locationInView(self)
        updateKnobWithPosition(touchLocation)
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touchLocation = (touches.first! as UITouch).locationInView(self)
        updateKnobWithPosition(touchLocation)
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        updateKnobWithPosition(baseCenter)
    }
    
    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        updateKnobWithPosition(baseCenter)
    }
    
    override init(frame viewFrame: CGRect) {
        //1
        baseCenter = CGPoint(x: viewFrame.size.width/2, y: viewFrame.size.height/2)
        
        //2
        knobImageView = UIImageView(image: UIImage(named: "knob"))
        knobImageView.frame.size.width /= 2
        knobImageView.frame.size.height /= 2
        knobImageView.center = baseCenter
        
        super.init(frame: viewFrame)
        
        //3
        userInteractionEnabled = true
        
        let baseImageView = UIImageView(frame: bounds)
        baseImageView.image = UIImage(named: "base")
        addSubview(baseImageView)
        
        //5
        
        addSubview(knobImageView)
        
        //6
        assert(CGRectContainsRect(bounds, knobImageView.bounds), "Analog control should be larger than the knob in size")
    }
    
    

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
