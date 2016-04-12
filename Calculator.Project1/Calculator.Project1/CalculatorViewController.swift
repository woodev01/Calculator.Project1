//
//  ViewController.swift
//  Calculator.Project1
//
//  Created by Evan on 4/6/16.
//  Copyright © 2016 Evan. All rights reserved.
//

import UIKit

class CalculatorViewController: UIViewController {


    @IBOutlet weak var DisplayValue: UILabel!
    @IBOutlet weak var StackValue: UILabel!
    
    var checkForNumStart: Bool = false
    var checkForAlreadyAFloat: Bool = false
    var firstInStack: Bool = true
    
    @IBAction func numKeys(sender: UIButton) {
        var keyValue = sender.currentTitle!
        if(keyValue == "π") {
            if checkForNumStart {
                enterKey()
                keyValue = String(M_PI)
            } else {
                keyValue = String(M_PI)
            }
        }
        if(keyValue == ".") {
            if checkForNumStart {
                if checkForAlreadyAFloat {
                    keyValue = ""
                } else {
                    checkForAlreadyAFloat = true
                }
            }
        }
        if checkForNumStart {
            DisplayValue.text = DisplayValue.text! + keyValue
        } else {
            DisplayValue.text = keyValue
            checkForNumStart = true
        }
    }
    
    
    @IBAction func operatorKeys(sender: UIButton) {
        let operation = sender.currentTitle!
        if checkForNumStart {
            enterKey()
        }
        
        StackValue.text = StackValue.text! + ", " + (String)(operation)
        
        switch operation {
        case "×": performOperation{ $0 * $1 }
        case "÷": performOperation{ $1 / $0 }
        case "+": performOperation{ $0 + $1 }
        case "-": performOperation{ $1 - $0 }
        case "√": performOperation{ sqrt($0)}
        case "Sin": performOperation{ sin($0) }
        case "Cos": performOperation{ cos($0) }
        default: break
        }
        
    }

    func performOperation(operation: (Double, Double) -> Double) {
        if operandStack.count > 1 {
            displayedValue = operation(operandStack.removeLast(), operandStack.removeLast())
            enterKey()
        }
    }
    
    @objc(performOperation2:) func performOperation(operation: (Double) -> Double) {
        if operandStack.count > 0 {
            displayedValue = operation(operandStack.removeLast())
            enterKey()
        }
    }
    
    var operandStack = Array<Double>()
    
    @IBAction func enterKey() {
        operandStack.append(displayedValue);
        if firstInStack {
            StackValue.text = StackValue.text! + " " + DisplayValue.text!
        } else {
            StackValue.text = StackValue.text! + ", " + DisplayValue.text!
        }
        print("Operand Stack = \(operandStack)")
        DisplayValue.text = "0"
        checkForNumStart = false
        checkForAlreadyAFloat = false
        firstInStack = false
        
    }
    
    
    @IBAction func clearKey() {
        DisplayValue.text = "0"
        StackValue.text = "Stack: "
        operandStack.removeAll()
        firstInStack = true
        checkForNumStart = false
        checkForAlreadyAFloat = false
    }
    
    
    
    
    var displayedValue: Double {
        get {
            return NSNumberFormatter().numberFromString(DisplayValue.text!)!.doubleValue
        }
        set {
            DisplayValue.text = "\(newValue)"
            checkForNumStart = false
            checkForAlreadyAFloat = false
        }
    }
}

