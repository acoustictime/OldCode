//
//  GraphView.swift
//  Calculator_iOS10
//
//  Created by James Small on 3/17/17.
//  Copyright © 2017 SmallJames. All rights reserved.
//

import UIKit

@IBDesignable
class GraphView: UIView {
    
    private var originPoint = CGPoint(x: CGFloat(300), y: CGFloat(300))
    private var scaleValue = CGFloat(100)
    
    var dataFunction : ((Double) -> Double)?
    
    @IBInspectable
    var graphLineWidth: CGFloat = 1.0
    
    
    @IBInspectable
    var origin: CGPoint {
        get {
            return originPoint
        }
        set {
            originPoint = newValue
            setNeedsDisplay()
        }
    }
    
    @IBInspectable
    var scale: CGFloat {
        get {
            return scaleValue
        }
        set {
            scaleValue = newValue
            setNeedsDisplay()
        }
    }

    
    override func draw(_ rect: CGRect) {
        // Drawing Axis
        let axisDrawer = AxesDrawer(color: UIColor.blue, contentScaleFactor: contentScaleFactor)
        axisDrawer.drawAxes(in: bounds, origin: origin, pointsPerUnit: scale)
        
        // Drawing Graph
        
        let path = UIBezierPath()
        
        var lineDrawing = false
        
        let maxCount = Int(bounds.width * contentScaleFactor)
        
        for x in 0...maxCount {
            
                       
            let xGraphValue = viewToGraphXValue(CGFloat(x))
            
            let resultValue = functionResultForXValue(xGraphValue)
            
            let yViewValue = graphToViewYValue(Double(resultValue))
            
            if yViewValue.isNormal {
                let pointToGraph = CGPoint(x: CGFloat(x), y: yViewValue)
                
                if lineDrawing == false {
                    lineDrawing = true
                    path.move(to: pointToGraph)
                } else {
                    path.addLine(to: pointToGraph)
                }
            }
            
            
        }
        
        path.lineWidth = graphLineWidth
        path.stroke()
    }
    
    private func functionResultForXValue(_ xValue: Double) -> Double {
        
        if let data = dataFunction {
           return data(xValue)
        } else {
            return 0
        }
        
    }
    
    //convert graph coordinates to view coordinates
    private func graphToViewYValue(_ yValue: Double) -> CGFloat {
        return origin.y - CGFloat(yValue) * scale
    }

    //convert view coordinates to graph coordinates
    private func viewToGraphXValue (_ xValue: CGFloat) -> Double {
        
       return Double((xValue - origin.x) / scale)
    }
    
    

}
