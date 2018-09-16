//
//  GraphViewController.swift
//  Calculator_iOS10
//
//  Created by James Small on 3/17/17.
//  Copyright © 2017 SmallJames. All rights reserved.
//

import UIKit

class GraphViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        graphView.dataFunction = function
    }
    
    override func viewWillAppear(_ animated: Bool) {
        graphView.origin = CGPoint(x: graphView.bounds.width / 2, y: graphView.bounds.height / 2)
    }

   
    @IBOutlet weak var graphView: GraphView!
    
    // my data structure
    var function : ((Double) -> Double)?     
    
    @IBAction func doubleTapGestureRecognizer(_ recognizer: UITapGestureRecognizer) {
        if recognizer.state == .ended {
            let tapPoint = recognizer.location(ofTouch: 0, in: graphView)
            graphView.origin = tapPoint
        }
    }

    @IBAction func panGestureRecognizer(_ recognizer: UIPanGestureRecognizer) {
        
        switch recognizer.state {
        case .changed, .ended:
            let translation = recognizer.translation(in: graphView)
            recognizer.setTranslation(CGPoint.zero, in: graphView)
            let newPoint = CGPoint(x: graphView.origin.x + translation.x, y: graphView.origin.y + translation.y)
            graphView.origin = newPoint
        default: break
        }
    }
    
    @IBAction func pinchGestureRecognizer(_ recognizer: UIPinchGestureRecognizer) {
        
        switch recognizer.state {
            case .changed, .ended:
            graphView.scale *= recognizer.scale
            recognizer.scale = 1.0
            default: break
        }
    }
}
