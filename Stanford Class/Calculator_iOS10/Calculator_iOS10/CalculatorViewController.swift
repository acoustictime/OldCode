//
//  ViewController.swift
//  Calculator_iOS10
//
//  Created by James Small on 2/10/17.
//  Copyright © 2017 SmallJames. All rights reserved.
//

import UIKit

class CalculatorViewController: UIViewController, UISplitViewControllerDelegate {
    
    @IBOutlet weak var display: UILabel!
    @IBOutlet weak var displayDescription: UILabel!
    @IBOutlet weak var displayVariableValue: UILabel!
    @IBOutlet weak var graphButton: UIButton!

    
    var userIsInTheMiddleOfTyping = false
    var userIsTypingDecimalNumber = false
    
    private var brain = CalculatorBrain()
    private var variables = [String: Double]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.splitViewController?.delegate = self
    }
    
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
       return true
    }
    
    @IBAction func touchDigit(_ sender: UIButton) {
        let digit = sender.currentTitle!
        
        
        if userIsInTheMiddleOfTyping {
            
            if digit == "." {
                if userIsTypingDecimalNumber {
                    return
                }
                userIsTypingDecimalNumber = true
            }
            
            let textCurrentlyInDisplay = display.text!
            display.text = textCurrentlyInDisplay + digit
        } else {
            
            if digit == "." {
                display.text = "0."
                userIsTypingDecimalNumber = true
            } else {
                display.text = digit
            }
            
            userIsInTheMiddleOfTyping = true
        }
        
        
    }
    
    var displayValue: Double {
        get {
            return Double(display.text!)!
        }
        set {
            display.text = String(format:"%g",newValue)
            graphButton.isEnabled = !brain.resultIsPending
            
            if brain.calculatorDescription == " " {
                displayDescription.text = " "
                displayVariableValue.text = " "
            } else {
                displayDescription.text = brain.calculatorDescription + (brain.resultIsPending ? " ..." : " =")
                let currentVariableValue = variables["M"] ?? 0
                
                displayVariableValue.text = "M = \(currentVariableValue)"
            }
            
            
            
        }
    }
    
    @IBAction func performOperation(_ sender: UIButton) {
        if userIsInTheMiddleOfTyping {
            brain.setOperand(displayValue)
            userIsInTheMiddleOfTyping = false
        }
        
        if let mathematicalSymbol = sender.currentTitle {
            brain.performOperation(mathematicalSymbol)
        }
        
        if let result = brain.result {
            displayValue = result
        } else {
            displayValue = 0
        }
        
    }
    
    @IBAction func performAdjustment(_ sender: UIButton) {
        
        let button = sender.currentTitle!
        
        switch button {
        case "C":
            brain.clear()
            display.text = "0"
            displayDescription.text = " "
            displayVariableValue.text = " "
            variables.removeAll()
        case "⇾M":
            variables["M"] = displayValue
            let evaluateResult = brain.evaluate(using: variables)
            
            if let result = evaluateResult.result {
                displayValue = result
                userIsInTheMiddleOfTyping = false
            }
            
            

        case "M":
            brain.setOperand(variable: button)
        case "<-":
            if userIsInTheMiddleOfTyping {
                if var text = display.text {
                    text.remove(at: text.index(before: text.endIndex))
                    if text.isEmpty {
                        text = "0"
                        userIsInTheMiddleOfTyping = false
                        userIsTypingDecimalNumber = false
                    }
                    display.text = text
                }
            } else {
                brain.undo()
                let evaluateResult = brain.evaluate(using: variables)
                let result = evaluateResult.result ?? 0

                displayValue = result
                userIsInTheMiddleOfTyping = false
            }
        default:
            break
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "graphSegue" {
            if !brain.resultIsPending {
                return true
            }
        }
        return false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        var destinationViewController = segue.destination
        
        if let navigationController = destinationViewController as? UINavigationController {
           destinationViewController = navigationController.visibleViewController ?? destinationViewController
        }
        
        if let graphViewController = destinationViewController as? GraphViewController,
            let identifier = segue.identifier {
                if identifier == "graphSegue" {
                    graphViewController.navigationItem.title = brain.calculatorDescription

                    var closureBrain = self.brain
                    
                    graphViewController.function = {
                        xValue in
                        return closureBrain.evaluate(using: ["M":xValue]).result!
                    }
                }
            }
        }
    }
    
    
    


