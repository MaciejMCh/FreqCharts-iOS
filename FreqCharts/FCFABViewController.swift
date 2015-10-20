//
//  FCFABViewController.swift
//  FreqCharts
//
//  Created by Maciej Chmielewski on 14.10.2015.
//  Copyright © 2015 maciejCh. All rights reserved.
//

import UIKit

class FCFABViewController: UIViewController {
    
    var childController: FCBubblesCollectionViewController!
    
    @IBOutlet var FAB: UIButton!
    
    @IBOutlet var nyquistButton: UIButton!
    @IBOutlet var phaseButton: UIButton!
    @IBOutlet var amplitudeButton: UIButton!
    @IBOutlet var deleteButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func FABAction(sender: AnyObject) {
        
        self.childController.exitAnimation()
        
        var animation = CABasicAnimation(keyPath: "transform")
        animation.delegate = self
        
        let initialFrame = self.FAB.frame
        let containerFrame = self.view.frame
        let centeredX = CGRectGetMidX(containerFrame) - (CGRectGetWidth(initialFrame) / 2)
        let xDiff = CGRectGetMinX(initialFrame) - centeredX
        let centeredY = CGRectGetMidY(containerFrame) - (CGRectGetHeight(initialFrame) / 2)
        let yDiff = CGRectGetMinY(initialFrame) - centeredY
        let translation = CATransform3DMakeTranslation(-xDiff, -yDiff, 0)
        
        
        let factor = (CGRectGetWidth(self.view.frame) - 30) / CGRectGetWidth(FAB.frame)
        let scale = CATransform3DMakeScale(factor, factor, 1)
        let model = CATransform3DConcat(scale, translation)
        
        animation.toValue = NSValue(CATransform3D: model)
        animation.duration = 1.0
        animation.fillMode = kCAFillModeForwards
        animation.timingFunction = CAMediaTimingFunction(controlPoints: 0.1, 1, 0.1, 1)
        animation.removedOnCompletion = false
        self.FAB.layer.addAnimation(animation, forKey: "grow bubble")
    }
    
    override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
        var animation = CABasicAnimation(keyPath: "transform.scale")
        animation.toValue = NSValue(CATransform3D: CATransform3DMakeScale(0, 0, 1))
        animation.duration = 0.5
        animation.fillMode = kCAFillModeForwards
        animation.timingFunction = CAMediaTimingFunction(controlPoints: 0.1, 1, 0.1, 1)
        animation.removedOnCompletion = false
        self.FAB.layer.addAnimation(animation, forKey: "explode bubble")
        
        self.showCreatingController()
    }
    
    func resetFAB() {
        FAB.layer.removeAllAnimations()
        FAB.transform = CGAffineTransformMakeScale(0, 0)
        UIView.animateWithDuration(0.3) { () -> Void in
            self.FAB.transform = CGAffineTransformIdentity
        }
    }
    
    func enterAnimation() {
        self.resetFAB()
        self.childController.enterAnimation()
    }
    
    func showMenu(show: Bool) {
        self.nyquistButton.enabled = show
        self.phaseButton.enabled = show
        self.amplitudeButton.enabled = show
        self.deleteButton.enabled = show
    }
    
    @IBAction func nyquistAction(sender: AnyObject) {
        self.presentViewController(FCNyquistViewController.controllerWithSymbol(self.childController.selectedCell.equationView.equation), animated: true, completion: nil)
        NSLog("saas")
    }
    @IBAction func deleteAction(sender: AnyObject) {
        self.childController.deleteSelected()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        self.childController = segue.destinationViewController as! FCBubblesCollectionViewController
    }
    
    func showCreatingController() {
        var newVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("FCCreateEquationViewController")
        self.addChildViewController(newVC)
        newVC.didMoveToParentViewController(self)
        self.view.addSubview(newVC.view)
        newVC.view.frame = self.view.frame
    }

}
