//
//  FCCreateEquationViewController.swift
//  FreqCharts
//
//  Created by Maciej Chmielewski on 14.10.2015.
//  Copyright © 2015 maciejCh. All rights reserved.
//

import UIKit

class FCCreateEquationViewController: UIViewController {
    
    @IBOutlet var operation: UIView!
    @IBOutlet var propeller: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let timer = NSTimer(timeInterval: 0.01, target: self, selector: Selector("animate"), userInfo: nil, repeats: true)
        NSRunLoop.mainRunLoop().addTimer(timer, forMode: NSDefaultRunLoopMode)
        
//        self.rotateImageView()
    }

    func rotateImageView() {
        
        
        
        
        
        UIView.animateWithDuration(10.0, delay: 0.0, options: UIViewAnimationOptions.AllowUserInteraction, animations: { () -> Void in
            self.propeller.transform = CGAffineTransformRotate(self.propeller.transform, CGFloat(M_PI_2))
            }) { (finished) -> Void in
                self.rotateImageView()
        }
        
    }
    
    func animate() {
        let circleRadius = CGFloat(25)
        let middle = CGPointMake(CGRectGetMidX(self.view.frame) - circleRadius, CGRectGetMidY(self.view.frame) - circleRadius)
        var radius = Double(150)
        let speed = Double(2)
        
        var offset = Double(0)
        x0.constant = CGFloat(radius * sin(CACurrentMediaTime() * speed)) + middle.x
        y0.constant = CGFloat(radius * cos(CACurrentMediaTime() * speed)) + middle.y
    }
    
    @IBAction func Add(sender: AnyObject) {
//        NSLog(String(self.operation.layer.presentationLayer()))
//        NSLog("Add!")
    }
    
    
    
    
    // animations
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
