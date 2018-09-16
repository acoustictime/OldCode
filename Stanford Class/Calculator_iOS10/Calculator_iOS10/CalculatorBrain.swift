//
//  CalculatorBrain.swift
//  Calculator_iOS10
//
//  Created by James Small on 2/12/17.
//  Copyright © 2017 SmallJames. All rights reserved.
//

import Foundation

struct CalculatorBrain {
    
    private var accumulator: Double? = 0.0
    private var description: String? = "0.0"
    
    private var internalProgram = [sequenceList]()
    private var internalProgramDescriptions = [String]()
    private var currentlyRunningProgram = false
    
    public var resultIsPending = false
    
    public var calculatorDescription: String {
        get {
            if pendingBinaryOperation == nil {
                return description!
            } else {
                return pendingBinaryOperation!.descriptionFunction(pendingBinaryOperation!.descriptionOperand,pendingBinaryOperation!.descriptionOperand != description! ? description! : "")
            }
        }
    }
    
    private enum Operation {
        case constant(Double)
        case unaryOperation((Double) -> Double, (String) -> String)
        case binaryOperation((Double,Double) -> Double, (String, String) -> String)
        case equals
    }
    
    private var operations: Dictionary<String,Operation> = [
        "π" : Operation.constant(Double.pi),
        "e" : Operation.constant(M_E),
        "√" : Operation.unaryOperation(sqrt, {"√(" + $0 + ")"}),
        "cos" : Operation.unaryOperation(cos, {"Cos(" + $0 + ")"}),
        "x" : Operation.binaryOperation({$0 * $1}, {$0 + " x " + $1}),
        "+" : Operation.binaryOperation({$0 + $1}, {$0 + " + " + $1}),
        "-" : Operation.binaryOperation({$0 - $1}, {$0 + " - " + $1}),
        "÷" : Operation.binaryOperation({$0 / $1}, {$0 + " / " + $1}),
        "±" : Operation.unaryOperation({-$0}, {"-(" + $0 + ")"}),
        "x²": Operation.unaryOperation({$0 * $0}, {"(" + $0 + ")²"}),
        "1/x": Operation.unaryOperation({1 / $0}, {"1 / (" + $0 + ")"}),
        "x/2": Operation.unaryOperation({$0 / 2}, {"(" + $0 + ") / 2"}),
        "∛": Operation.unaryOperation({pow($0, 1.0/3.0)}, {"∛(" + $0 + ")"}),
        "=" : Operation.equals
    ]
    
    mutating func performOperation(_ symbol: String) {
        if let operation = operations[symbol] {
            if !currentlyRunningProgram {
                internalProgram.append(sequenceList(type:.operation,value: symbol))
            }
            
            switch operation {
            case .constant(let value):
                accumulator = value
                description = symbol
                
            case .unaryOperation(let function, let descFunction):
                if accumulator != nil {
                    accumulator = function(accumulator!)
                    description = descFunction(description!)
                }
            case .binaryOperation(let function, let descFunction):
                performPendingBinaryOperation()
                if accumulator != nil {
                    pendingBinaryOperation = PendingBinaryOperation(function: function, firstOperand: accumulator!, descriptionFunction: descFunction, descriptionOperand: description!)
                    accumulator = nil
                    resultIsPending = true
                    
                }
            case .equals:
                performPendingBinaryOperation()
            }
        }
    }
    
    mutating private func performPendingBinaryOperation() {
        if pendingBinaryOperation != nil && accumulator != nil {
            accumulator = pendingBinaryOperation!.perform(with: accumulator!)
         //   if !currentlyRunningProgram {
                description = pendingBinaryOperation!.descriptionFunction((pendingBinaryOperation?.descriptionOperand)!, description!)
          
         //   }
            
            pendingBinaryOperation = nil
            resultIsPending = false
        }
        
    }
    
    private var pendingBinaryOperation: PendingBinaryOperation?
    
    private struct PendingBinaryOperation {
        let function: (Double, Double) -> Double
        let firstOperand: Double
        var descriptionFunction: (String, String) -> String
        var descriptionOperand: String
        
        func perform(with secondOperand: Double) -> Double {
            return function(firstOperand, secondOperand)
        }
    }
    
    mutating func setOperand(_ operand: Double) {
        if !currentlyRunningProgram {
            internalProgram.append(sequenceList(type: .operand,value: String(operand)))
            
            
        }
        
        description = String(operand)
        accumulator = operand
        
    }
    
    mutating func setOperand(variable named: String) {
        internalProgram.append(sequenceList(type: .variable,value: named))
        description = named
        accumulator = 0.0
    }
    
    mutating func evaluate(using variables: Dictionary<String,Double>? = nil) -> (result: Double?, isPending: Bool, description: String) {
        
        if let internalVariables = variables {
            currentlyRunningProgram = true
            clearForProgramRunning()
            for item in internalProgram {
                
                switch item.type {
                case .operation:
                    performOperation(item.value)
                case .operand:
                    setOperand(Double(item.value)!)
                case .variable:
                    let variabelValue = internalVariables[item.value] ?? 0
                    setOperand(variabelValue)
                    description = item.value
                }
            }
            currentlyRunningProgram = false
        }

        return (result: result, isPending: resultIsPending, description: description!)
    }
    
    private enum sequenceTypes {
        case operation
        case operand
        case variable
    }
    
    private struct sequenceList {
        var type: sequenceTypes
        var value: String
    }

    var result: Double? {
        get {
            return accumulator
        }
    }
    
    mutating func clearForProgramRunning() {
        accumulator = 0
        pendingBinaryOperation = nil
        description = " "
    }
    
    mutating func clear() {
        clearForProgramRunning()
        internalProgram.removeAll()
    }
    
    mutating func undo() {
        if internalProgram.count > 0 {
            internalProgram.removeLast()
        }
        
    }
    
}
