//
//  FCCreateEquationViewController.swift
//  FreqCharts
//
//  Created by Maciej Chmielewski on 14.10.2015.
//  Copyright © 2015 maciejCh. All rights reserved.
//

import UIKit

class FCCreateEquationViewController: UIViewController, UIWebViewDelegate, UITextFieldDelegate {
    
    @IBOutlet var equationBubble: UIView!
    @IBOutlet var operatorsContainer: UIView!
    @IBOutlet var equationView: FCEquationView!
    
    var completion: ((Double)->())!
    var currentMovingButton: FCMovingButton?
    var lineController: FCDottedLineTableViewController?
    var propellerHeight: NSLayoutConstraint?
    
    
    @IBAction func Back(sender: AnyObject) {
        self.equationView.equation.calculateSizeOfEquation(UIFont.systemFontOfSize(20))
        FCEquationsDataSource().addEquation(self.equationView.equation)
        
        (self.parentViewController as! FCFABViewController).enterAnimation()
        self.removeFromParentViewController()
        self.view.removeFromSuperview()
    }
    
    func createDot() {
        self.lineController = FCDottedLineTableViewController()
        self.addChildViewController(self.lineController!)
        self.lineController!.didMoveToParentViewController(self)
        
        let propeller = UIView()
        
        propeller.addSubview(self.lineController!.view)
        self.view.addSubview(propeller)
        
        self.propellerHeight = propeller.autoSetDimension(.Height, toSize: 100)
        propeller.autoSetDimension(.Width, toSize: 10)
        
        propeller.autoCenterInSuperview()
        
        self.lineController!.view.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsZero, excludingEdge: .Bottom)
        self.lineController!.view.autoMatchDimension(.Height, toDimension: .Height, ofView: propeller, withMultiplier: 0.5)
    }
    
    func selectedSymbol(symbol: String, completion: (FCSymbol)->()) {
        switch (symbol) {
        case "+": completion(FCAddSymbol())
        case "−": completion(FCSubstractSymbol())
        case "×": completion(FCMultipleSymbol())
        case "÷": completion(FCFractionSymbol())
        case "()": completion(FCParenthesesSymbol())
            
        case "#": self.pickNumber({ (number) -> () in
            completion(FCNumberSymbol(value: number))
        })
        case "s": self.pickNumber({ (number) -> () in
            completion(FCOperatorSymbol(multipler: number))
        })
        case "x#": self.pickNumber({ (number) -> () in
            completion(FCPowerSymbol(exponent: Int(number)))
        })
            
        default: break
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.completion(Double(textField.text!)!)
        
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            textField.transform = CGAffineTransformMakeScale(0, 0)
            }) { (finished) -> Void in
                textField.removeFromSuperview()
        }
        
        return true
    }
    
    func pickNumber(completion: (Double)->()) {
        self.completion = completion
        
        let pickerTextView = UITextField()
        pickerTextView.keyboardType = .NamePhonePad
        pickerTextView.delegate = self
        pickerTextView.textColor = FCMovingButton.greenColor
        pickerTextView.contentVerticalAlignment = UIControlContentVerticalAlignment.Center
        pickerTextView.textAlignment = NSTextAlignment.Center
        pickerTextView.font = UIFont.systemFontOfSize(100, weight: UIFontWeightThin)
        self.view.addSubview(pickerTextView)
        let height = CGRectGetWidth(self.view.frame) - 30
        pickerTextView.layer.cornerRadius = height / 2
        pickerTextView.layer.borderWidth = 10
        pickerTextView.layer.borderColor = FCMovingButton.greenColor.CGColor
        pickerTextView.backgroundColor = UIColor.whiteColor()
        pickerTextView.autoSetDimensionsToSize(CGSizeMake(height, height))
        pickerTextView.autoCenterInSuperview()
        
        pickerTextView.becomeFirstResponder()
        
        pickerTextView.transform = CGAffineTransformMakeScale(0, 0)
        UIView.animateWithDuration(0.2) { () -> Void in
            pickerTextView.transform = CGAffineTransformIdentity
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.enterAnimation()

        let timer = NSTimer(timeInterval: 0.01, target: self, selector: Selector("animate"), userInfo: nil, repeats: true)
        NSRunLoop.mainRunLoop().addTimer(timer, forMode: NSDefaultRunLoopMode)
        
        self.operatorsContainer.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: Selector("draggingPending:")))
    }
    
    @IBAction func movingButtonStartDraggingAction(sender: FCMovingButton) {
        
        if (self.equationView.equation.mainSymbol is FCNullSymbol) {
            self.createDot()
        }
        
        self.currentMovingButton = sender
        
        UIView.animateWithDuration(0.3) { () -> Void in
            self.currentMovingButton!.alpha = 0.5
            self.currentMovingButton!.backgroundColor = FCMovingButton.greenColor
            var attrString = self.currentMovingButton!.titleLabel!.attributedText!.mutableCopy()
            attrString.removeAttribute(NSForegroundColorAttributeName, range: NSMakeRange(0, attrString.length))
            attrString.addAttribute(NSForegroundColorAttributeName, value: UIColor.whiteColor(), range: NSMakeRange(0, attrString.length))
            self.currentMovingButton!.setAttributedTitle(attrString as! NSAttributedString, forState: .Normal)
        }
        
        self.updateDragging(CGPointMake(CGRectGetMinX(sender.frame) + CGFloat(25), CGRectGetMinY(sender.frame) + CGFloat(25)))
    }
    
    func draggingPending(gestureRecognizer: UIPanGestureRecognizer) {
        switch(gestureRecognizer.state) {
        case .Changed: self.updateDragging(gestureRecognizer.locationInView(self.view))
        case .Ended: self.draggingFinish(gestureRecognizer.locationInView(self.view))
        default: break
        }
    }
    
    func updateDragging(var point: CGPoint) {
        
        if (self.currentMovingButton == nil) {
            return
        }
        
        point.x -= 50
        point.y -= 50
        if let currentMovingButton = self.currentMovingButton {
            for positionConstraints in self.all() {
                if (currentMovingButton == positionConstraints.b) {
                    positionConstraints.x.constant = point.x
                    positionConstraints.y.constant = point.y
                }
            }
        }
        
        point.x += 25
        point.y += 25
        
        let point1 = Point(px: point.x, py: point.y)
        let point2 = Point(px: CGRectGetMidX(self.view.frame), py: CGRectGetMidY(self.view.frame))
        
        self.propellerHeight?.constant = point1.distance(point2) * 2
        
        let yDiff = point2.y - point1.y
        let xDiff = point2.x - point1.x
        let angle = atan2(xDiff, yDiff)
        
        let rotation = CGAffineTransformMakeRotation(-angle)
        self.lineController?.view.superview?.transform = rotation
        
    }
    
    func draggingFinish(var point: CGPoint) {
        point.x -= 25
        point.y -= 25
        if (self.currentMovingButton == nil) {
            return
        }
        
        
        for nullSymbol in self.equationView.equation.nulls() {
            if (CGRectMake(0, 0, CGRectGetWidth(nullSymbol.nullView!.frame), CGRectGetHeight(nullSymbol.nullView!.frame)).contains(nullSymbol.nullView!.convertPoint(point, fromView: nil))) {
                self.selectedSymbol(self.currentMovingButton!.titleLabel!.text!, completion: { (newSymbol) -> () in
                    nullSymbol.parentSymbol.fillNull(nullSymbol, symbol: newSymbol as! AnyObject)
                    self.equationView.update()
                })
            }
        }
        
        let movingButton = self.currentMovingButton!
        movingButton.alpha = 1.0
        movingButton.backgroundColor = UIColor.whiteColor()
        var attrString = movingButton.titleLabel!.attributedText!.mutableCopy()
        attrString.removeAttribute(NSForegroundColorAttributeName, range: NSMakeRange(0, attrString.length))
        attrString.addAttribute(NSForegroundColorAttributeName, value: FCMovingButton.greenColor, range: NSMakeRange(0, attrString.length))
        movingButton.setAttributedTitle(attrString as! NSAttributedString, forState: .Normal)
        
        self.currentMovingButton!.transform = CGAffineTransformMakeScale(0, 0)
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.currentMovingButton!.transform = CGAffineTransformIdentity
            }) { (finished) -> Void in
        }
        
        self.currentMovingButton = nil
        
        self.lineController?.view.superview?.removeFromSuperview()
        self.lineController = nil
        self.propellerHeight = nil
        
    }
    
    //MARK: enter animation
    
    func enterAnimation() {
        equationBubble.transform = CGAffineTransformMakeScale(0, 0)
        equationBubble.alpha = 0.0
        
        for operatorBubble in self.operatorsContainer.subviews {
            operatorBubble.transform = CGAffineTransformMakeScale(0, 0)
        }
        
        UIView.animateWithDuration(0.1) { () -> Void in
            self.equationBubble.transform = CGAffineTransformIdentity
            self.equationBubble.alpha = 1.0
            
            for operatorBubble in self.operatorsContainer.subviews {
                operatorBubble.transform = CGAffineTransformIdentity
            }
        }
    }
    
    //MARK: spinning animation
    
    func animate() {
        let circleRadius = CGFloat(25)
        let middle = CGPointMake(CGRectGetMidX(self.view.frame) - circleRadius, CGRectGetMidY(self.view.frame) - circleRadius)
        let radius = Double(CGRectGetWidth(self.view.frame) / 2) - Double(circleRadius) - 15
        let speed = Double(0.1)
        let dAngle = M_PI_4
        
        var offset = Double(0)
        for positionConstraints in self.all() {
            if let currentMovingButton = self.currentMovingButton {
                if (currentMovingButton == positionConstraints.b) {
                    offset += dAngle
                    continue
                }
            }
            positionConstraints.x.constant = CGFloat(radius * sin((CACurrentMediaTime() * speed) + offset)) + middle.x
            positionConstraints.y.constant = CGFloat(radius * cos((CACurrentMediaTime() * speed) + offset)) + middle.y
            offset += dAngle
        }
    }
    
    @IBOutlet var x0: NSLayoutConstraint!
    @IBOutlet var y0: NSLayoutConstraint!
    @IBOutlet var x1: NSLayoutConstraint!
    @IBOutlet var y1: NSLayoutConstraint!
    @IBOutlet var x2: NSLayoutConstraint!
    @IBOutlet var y2: NSLayoutConstraint!
    @IBOutlet var x3: NSLayoutConstraint!
    @IBOutlet var y3: NSLayoutConstraint!
    @IBOutlet var x4: NSLayoutConstraint!
    @IBOutlet var y4: NSLayoutConstraint!
    @IBOutlet var x5: NSLayoutConstraint!
    @IBOutlet var y5: NSLayoutConstraint!
    @IBOutlet var x6: NSLayoutConstraint!
    @IBOutlet var y6: NSLayoutConstraint!
    @IBOutlet var x7: NSLayoutConstraint!
    @IBOutlet var y7: NSLayoutConstraint!
    
    @IBOutlet var b0: FCMovingButton!
    @IBOutlet var b1: FCMovingButton!
    @IBOutlet var b2: FCMovingButton!
    @IBOutlet var b3: FCMovingButton!
    @IBOutlet var b4: FCMovingButton!
    @IBOutlet var b5: FCMovingButton!
    @IBOutlet var b6: FCMovingButton!
    @IBOutlet var b7: FCMovingButton!
    
    func x(index: Int) -> NSLayoutConstraint {
        switch (index) {
        case 0: return x0
        case 1: return x1
        case 2: return x2
        case 3: return x3
        case 4: return x4
        case 5: return x5
        case 6: return x6
        case 7: return x7
        default: return x0
        }
    }
    
    func y(index: Int) -> NSLayoutConstraint {
        switch (index) {
        case 0: return y0
        case 1: return y1
        case 2: return y2
        case 3: return y3
        case 4: return y4
        case 5: return y5
        case 6: return y6
        case 7: return y7
        default: return y0
        }
    }
    
    func allX() -> [NSLayoutConstraint] {
        return [x0, x1, x2, x3, x4, x5, x6, x7]
    }
    
    func allY() -> [NSLayoutConstraint] {
        return [y0, y1, y2, y3, y4, y5, y6, y7]
    }
    
    func all() -> [(x: NSLayoutConstraint, y: NSLayoutConstraint, b: FCMovingButton)] {
        return [(x0, y0, b0), (x1, y1, b1), (x2, y2, b2), (x3, y3, b3), (x4, y4, b4), (x5, y5, b5), (x6, y6, b6), (x7, y7, b7)]
    }

}
