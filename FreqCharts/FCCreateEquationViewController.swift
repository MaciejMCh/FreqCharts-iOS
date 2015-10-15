//
//  FCCreateEquationViewController.swift
//  FreqCharts
//
//  Created by Maciej Chmielewski on 14.10.2015.
//  Copyright © 2015 maciejCh. All rights reserved.
//

import UIKit

class FCCreateEquationViewController: UIViewController, UIWebViewDelegate {
    
    @IBOutlet var equationBubble: UIView!
    @IBOutlet var operatorsContainer: UIView!
    @IBOutlet var webView: UIWebView!
    
    var currentMovingButton: FCMovingButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.enterAnimation()

        let timer = NSTimer(timeInterval: 0.01, target: self, selector: Selector("animate"), userInfo: nil, repeats: true)
        NSRunLoop.mainRunLoop().addTimer(timer, forMode: NSDefaultRunLoopMode)
        
        self.operatorsContainer.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: Selector("draggingPending:")))
        
        self.webView.delegate = self
        self.webView.loadHTMLString(FCEquation(mainSymbol: FCFractionSymbol(), font: UIFont()).htmlRepresentation(), baseURL: nil)
    }
    @IBAction func movingButtonStartDraggingAction(sender: FCMovingButton) {
        self.findNulls()
        self.currentMovingButton = sender
    }
    
    func findNulls() {
        let snapshot = self.webView.pb_takeSnapshot()
        let points = (ImageProcessor.sharedProcessor().findNullsInImage(snapshot, inColor: UIColor.redColor()) as! [CGPointWrapper]).map { (input) -> CGPoint in
            return input.point
        }
        
        
        
        NSLog("ss")
    }
    
    func draggingPending(gestureRecognizer: UIPanGestureRecognizer) {
        switch(gestureRecognizer.state) {
        case .Changed: self.updateDragging(gestureRecognizer.locationInView(self.view))
        case .Ended: self.draggingFinish()
        default: break
        }
    }
    
    func updateDragging(var point: CGPoint) {
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
    }
    
    func draggingFinish() {
        if (self.currentMovingButton == nil) {
            return
        }
        self.currentMovingButton!.transform = CGAffineTransformMakeScale(0, 0)
        UIView.animateWithDuration(0.2) { () -> Void in
            self.currentMovingButton!.transform = CGAffineTransformIdentity
        }
        self.currentMovingButton = nil
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
