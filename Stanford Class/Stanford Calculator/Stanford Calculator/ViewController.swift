//
//  ViewController.swift
//  Stanford Calculator
//
//  Created by James Small on 10/5/16.
//  Copyright © 2016 SmallJames. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var display: UILabel!
    
    var userIsInTheMiddleOfTyping = false
    
    @IBAction func touchDigit(_ sender: UIButton) {
        let digit = sender.currentTitle!
        
        if userIsInTheMiddleOfTyping {
            let textCurrentlyInDisplay = display.text!
            display.text = textCurrentlyInDisplay + digit
        } else {
            display.text = digit
        }
        userIsInTheMiddleOfTyping = true
        
    }
    
    
    @IBAction func performOperation(_ sender: UIButton) {
        
        userIsInTheMiddleOfTyping = false
        
        if let mathmaticalSymbol = sender.currentTitle {
            if mathmaticalSymbol == "π" {
                display.text = String(M_PI)
                
            }
        }
        
    }
    


}

