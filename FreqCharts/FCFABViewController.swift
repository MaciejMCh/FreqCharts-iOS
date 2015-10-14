//
//  FCFABViewController.swift
//  FreqCharts
//
//  Created by Maciej Chmielewski on 14.10.2015.
//  Copyright © 2015 maciejCh. All rights reserved.
//

import UIKit

class FCFABViewController: UIViewController {
    
    @IBOutlet var FAB: UIButton!
    
    @IBAction func FABAction(sender: AnyObject) {
        
        var animation = CABasicAnimation(keyPath: "transform")
        animation.delegate = self
        
        let initialFrame = self.FAB.frame
        let containerFrame = self.view.frame
        let centeredX = CGRectGetMidX(containerFrame) - (CGRectGetWidth(initialFrame) / 2)
        let xDiff = CGRectGetMinX(initialFrame) - centeredX
        let centeredY = CGRectGetMidY(containerFrame) - (CGRectGetHeight(initialFrame) / 2)
        let yDiff = CGRectGetMinY(initialFrame) - centeredY
        let translation = CATransform3DMakeTranslation(-xDiff, -yDiff, 0)
        
        let scale = CATransform3DMakeScale(4, 4, 1)
        let model = CATransform3DConcat(scale, translation)
        
        animation.toValue = NSValue(CATransform3D: model)
        animation.duration = 0.3
        animation.fillMode = kCAFillModeForwards
        animation.removedOnCompletion = false
        self.FAB.layer.addAnimation(animation, forKey: "transform")
        
        
        
        
        
    }

}
