//
//  ViewController.swift
//  Calculator
//
//  Created by James Small on 4/21/16.
//  Copyright © 2016 SmallJames. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet private weak var display: UILabel!
    
    @IBOutlet weak var logDisplay: UILabel!
    
    private var userIsInTheMiddleOfTyping = false
    
    @IBAction private func touchDigit(sender: UIButton) {
        
        let digit = sender.currentTitle!
        
        self.logKeyInputs(digit)
        
        if userIsInTheMiddleOfTyping {
            let textCurrentlyInDisplay = display.text!
            display.text = textCurrentlyInDisplay + digit
        } else {
            display.text = digit
        }
        
        userIsInTheMiddleOfTyping = true
    }
    
    private var displayValue: Double {
        get {
            return Double(display.text!)!
        }
        set {
            display.text = String(newValue)
        }
    }
    
    private func logKeyInputs(valueToLog: String) {
        logDisplay.text = logDisplay.text! + " " + valueToLog
    }
    
    private var brain = CalculatorBrain()
    
    @IBAction private func performOperation(sender: UIButton) {
        if userIsInTheMiddleOfTyping {
            brain.setOperand(displayValue)
            userIsInTheMiddleOfTyping = false
        }
        
        if let mathmaticalSymbol = sender.currentTitle {
            self.logKeyInputs(mathmaticalSymbol)
            brain.performOperation((mathmaticalSymbol))
        }
        
        displayValue = brain.result
    }
}

