//
//  FCCreateEquationViewController.swift
//  FreqCharts
//
//  Created by Maciej Chmielewski on 14.10.2015.
//  Copyright © 2015 maciejCh. All rights reserved.
//

import UIKit

class FCCreateEquationViewController: UIViewController {
    
    @IBOutlet var equationBubble: UIView!
    @IBOutlet var operatorsContainer: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.enterAnimation()

        let timer = NSTimer(timeInterval: 0.01, target: self, selector: Selector("animate"), userInfo: nil, repeats: true)
        NSRunLoop.mainRunLoop().addTimer(timer, forMode: NSDefaultRunLoopMode)
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
        x0.constant = CGFloat(radius * sin((CACurrentMediaTime() * speed) + offset)) + middle.x
        y0.constant = CGFloat(radius * cos((CACurrentMediaTime() * speed) + offset)) + middle.y
        
        offset += dAngle
        x1.constant = CGFloat(radius * sin((CACurrentMediaTime() * speed) + offset)) + middle.x
        y1.constant = CGFloat(radius * cos((CACurrentMediaTime() * speed) + offset)) + middle.y
        
        offset += dAngle
        x2.constant = CGFloat(radius * sin((CACurrentMediaTime() * speed) + offset)) + middle.x
        y2.constant = CGFloat(radius * cos((CACurrentMediaTime() * speed) + offset)) + middle.y
        
        offset += dAngle
        x3.constant = CGFloat(radius * sin((CACurrentMediaTime() * speed) + offset)) + middle.x
        y3.constant = CGFloat(radius * cos((CACurrentMediaTime() * speed) + offset)) + middle.y
        
        offset += dAngle
        x4.constant = CGFloat(radius * sin((CACurrentMediaTime() * speed) + offset)) + middle.x
        y4.constant = CGFloat(radius * cos((CACurrentMediaTime() * speed) + offset)) + middle.y
        
        offset += dAngle
        x5.constant = CGFloat(radius * sin((CACurrentMediaTime() * speed) + offset)) + middle.x
        y5.constant = CGFloat(radius * cos((CACurrentMediaTime() * speed) + offset)) + middle.y
    
        offset += dAngle
        x6.constant = CGFloat(radius * sin((CACurrentMediaTime() * speed) + offset)) + middle.x
        y6.constant = CGFloat(radius * cos((CACurrentMediaTime() * speed) + offset)) + middle.y
        
        offset += dAngle
        x7.constant = CGFloat(radius * sin((CACurrentMediaTime() * speed) + offset)) + middle.x
        y7.constant = CGFloat(radius * cos((CACurrentMediaTime() * speed) + offset)) + middle.y
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

}
