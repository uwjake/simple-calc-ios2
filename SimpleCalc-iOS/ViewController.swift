//
//  ViewController.swift
//  SimpleCalc-iOS
//
//  Created by iGuest on 10/15/18.
//  Copyright © 2018 Jake Jin. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    // init calc object
    var calc = Calculator()
    
    var history = History()
    
    // determine which func in Calculator object to call
    func determineOp(_ op:String, _ num:String, _ source:String){
        if Double(num) != nil {
            switch op {
            case "+":
                calc.add(num)
            case "-":
                calc.sub(num)
            case "×":
                calc.mul(num)
            case "÷":
                calc.div(num)
            case "MOD":
                calc.mod(num)
            case "CT":
                if (source == "op"){
                    calc.count(num)
                } else{
                    // triggered from equal btn
                    if (dispayLabel.text! != "") {
                        calc.count(num)
                    }
                    dispayLabel.text = calc.getResult()
                }
            case "AVG":
                if (source == "op"){
                    calc.avg(num)
                } else{
                    // triggered from equal btn
                    if (dispayLabel.text! != "") {
                        calc.avg(num)
                    }
                    dispayLabel.text = calc.getResult()
                }
            case "FACT":
                // special case, no need to press equal
                calc.add(num)
                calc.fact()
                dispayLabel.text = calc.getResult()
                calc.done = true
            default:
                print("no last op")
            }
        }
        
    }
    // define result display label var
    @IBOutlet weak var dispayLabel: UILabel!
    
    @IBAction func btnMinusPressed(_ sender: UIButton) {
        let currentNum:String = dispayLabel.text!
        if currentNum.contains("-") {
            dispayLabel.text = String(currentNum.dropFirst())
        } else {
            dispayLabel.text = "-" + currentNum
//            print("-" + currentNum)
        }
    }
    
    @IBAction func btnClearPressed(_ sender: UIButton) {
        let type = sender.currentTitle!
        if (type == "AC") {
             reInit()
        } else{
            dispayLabel.text = ""
        }
    }
    
    func reInit(){
        calc = Calculator()
        dispayLabel.text = ""
    }
    
    @IBAction func btnSpacePressed(_ sender: UIButton) {
        
        calc.OpExpression += dispayLabel.text! + " "
        dispayLabel.text = ""
    }
    
    @IBAction func btnNumberPressed(_ sender: UIButton){
        // Init
        if (calc.done){
            reInit()
        }
        let num = sender.currentTitle!
        let oldNum = dispayLabel.text!
        if oldNum == "" {
            dispayLabel.text = num
        } else {
            dispayLabel.text = oldNum + num
        }
        if num == "." {
            calc.isDecimal = true
        }
    }
    
    @IBAction func btnEqualsPressed(_ sender: UIButton) {
        if !calc.done {
            // call right method
            determineOp(calc.lastOp, dispayLabel.text!, "equal")
            dispayLabel.text = calc.getResult()
            
            // clear last Op to handle multiple equal press
//            print(calc.getResult(), calc.lastOp)
            // set done = true
            calc.done = true
        }
        history.add(calc.getfullExpression())
        print(history.history)
        
    }
    
    @IBAction func btnOpPressed(_ sender: UIButton) {
        let currentOp = sender.currentTitle!
        if calc.OpExpression == "" {
            // regular case
            //        print(calc.lastOp)
            if calc.lastOp == "" && Double(dispayLabel.text!) != nil && currentOp != "FACT" && currentOp != "CT"{
                // store first number
                if (currentOp == "AVG"){
                    calc.fullExpressionHistory += "\(dispayLabel.text!) "
                }
                calc.add(dispayLabel.text!, true)
                
            } else {
                determineOp(currentOp, dispayLabel.text!, "op")
            }
            // special case for fact
            if (currentOp != "FACT") {
                dispayLabel.text = ""
            }
            calc.lastOp = currentOp
            //        dispayLabel.text = calc.getResult()
            //        print(calc.getResult(), calc.lastOp)
        } else {
            // RPN case
            if dispayLabel.text! != "" {
                // if user is too eager to press op button
                // this is to prevent a case in which last num is not recorded
                calc.OpExpression += dispayLabel.text!
            }
            reversePolishNotation(currentOp)
            dispayLabel.text = calc.getResult()
            calc.done = true
        }
    }
    
    func reversePolishNotation(_ op: String) {
        let nums = calc.OpExpression.split(separator: " ")
        print(nums)
        if nums.count > 0 && Double(nums[0]) != nil {
            if (op != "CT"){
                calc.add(String(nums[0]), true)

            } else {
                 determineOp(op, String(nums[0]), "op")
            }
            for i in 1..<nums.count {
                if Double(nums[i]) != nil {
                    determineOp(op, String(nums[i]), "op")
                }
            }
        }
        
    }
}

class Calculator {
    var lastOp = ""
    var currentResult = 0.0
    var isDecimal = false
    var count = 1
    var done = false
    var OpExpression = ""
    var sum = 0.0
    var fullExpressionHistory = ""
    
    func add(_ num: String, _ storeFirst: Bool = false){
        self.currentResult = self.currentResult + Double(num)!
        if (storeFirst){
            self.sum += Double(num)!
        }
        self.addToExpression("+", num)
    }
    
    func sub(_ num: String){
        self.currentResult = self.currentResult - Double(num)!
        self.addToExpression("-", num)
    }
    
    func mul(_ num: String){
        self.currentResult = self.currentResult * Double(num)!
        self.addToExpression("×", num)
    }
    
    func div(_ num: String){
        self.currentResult = self.currentResult / Double(num)!
        if self.currentResult.exponent >= 0 || abs(self.currentResult) < 1 {
            self.isDecimal = true
        }
        self.addToExpression("÷", num)
    }
    
    func mod(_ num: String){
        self.currentResult = Double( Int(self.currentResult) % Int(num)!)
        self.addToExpression("%", num)
    }
    
    func count(_ num: String){
        self.currentResult += 1
        self.addToExpression("CT", num)
    }
    
    func avg(_ num: String){
        self.sum += Double(num)!
        self.count += 1
        self.currentResult = self.sum / Double(count)
        if self.currentResult.exponent >= 0 || abs(self.currentResult) < 1 {
            self.isDecimal = true
        }
        self.addToExpression("AVG", num)
    }
    
    func fact(){
        let num = String(Int(self.currentResult))
        self.currentResult = Double(calcFact(factor: Int(self.currentResult)))
        self.addToExpression("!", num)
    }
    
    func calcFact(factor: Int)->Int{
        if (factor == 0 || factor == 1 ){
            return 1
        } else {
            return (1...factor).reduce(1, {a, b in a * b})
        }
    }
    
    func getResult()->String {
        if (self.isDecimal) {
            return String(self.currentResult)
        } else {
            return String(Int(self.currentResult))
        }
    }
    
    func addToExpression(_ op: String, _ num: String) {
        switch op {
        case "!":
            self.fullExpressionHistory += "\(num) \(op) "
        default:
            self.fullExpressionHistory += "\(op) \(num) "
        }
    }
    
    func getfullExpression()->String {
        var result = ""
        switch self.lastOp {
        case "+", "-", "×", "÷", "%", "!":
            result = String("\(self.fullExpressionHistory)= \(self.getResult())".dropFirst(2))
        case "CT":
            result = String("\(self.fullExpressionHistory)= \(self.getResult())".dropFirst(3))
        // AVG
        default:
            result = String("\(self.fullExpressionHistory)= \(self.getResult())".dropFirst(4))
        }
        return result
    }
    
}

class History {
    var history: Array<String> = []
    
    
    func add(_ expression: String){
        self.history.insert(expression, at:0)
    }
    
}


