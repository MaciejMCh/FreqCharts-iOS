//
//  FCBezierViewController.swift
//  FreqCharts
//
//  Created by Maciej Chmielewski on 19.10.2015.
//  Copyright © 2015 maciejCh. All rights reserved.
//

import UIKit

class FCNyquistViewController: UIViewController {

    var symbol: FCSymbol!
    
    class func controllerWithSymbol(symbol: FCSymbol) -> FCNyquistViewController {
        var controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("FCNyquistViewController") as! FCNyquistViewController
        controller.symbol = symbol
        return controller
    }
    
    @IBAction func backAction(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var zeroResponse = self.symbol.responseForFrequency(0)
        var infinityResponse = self.symbol.responseForFrequency(Double.infinity)
//        if infinityResponse.re.isNaN {
//            infinityResponse.re = 0
//        }
//        if infinityResponse.im.isNaN {
//            infinityResponse.im = 0
//        }
        
        zeroResponse = self.normalize(zeroResponse)
        infinityResponse = self.normalize(infinityResponse)
        
        var size = (zeroResponse - infinityResponse).abs
        if size == 0 {
            size = 1
        }
        
        let numberOfSteps = 100
        
        let stepSize = size / Double(numberOfSteps)
        
        var step = Double(1)
        
        var stepDiff = 0.1
        
        let accuracy = 0.01
        let maxError = stepDiff * accuracy
        
        var tooBig = false
        var changesCount = Int(0)
        
        while(true) {
            
            let response = self.symbol.responseForFrequency(step)
            let diff = (zeroResponse - response).abs
            
            let previousToo = tooBig
            if (diff > stepSize) {
                tooBig = true
            } else {
                tooBig = false
            }
            if (previousToo != tooBig) {
                changesCount += 1
            } else {
                changesCount = 0
            }
            if (changesCount > 4) {
                stepDiff /= 2
                changesCount = 0
            }
            
            if (tooBig) {
                step *= (1 - stepDiff)
            } else {
                step *= (1 + stepDiff)
            }
            
            NSLog(String(diff))
            if (abs(diff - stepSize) < maxError) {
                break
            }
            
        }
        
        var complexes = [Complex<Double>]()
        complexes.append(zeroResponse)
        
        while(true) {
            step *= (1 + stepDiff)
            complexes.append(self.symbol.responseForFrequency(step))
            
            if (complexes.count > numberOfSteps) {
                break
            }
        }
        
        let points = complexes.map { (me) -> CGPoint in
            return CGPointMake(CGFloat(me.real), CGFloat(me.imag))
        }
        
        (self.view as! FCBezierPathView).passPoints(points)
        
    }
    
    func normalize(var complex: Complex<Double>) -> Complex<Double>{
        if (complex.re.isNaN) {
            complex.re = 0
        }
        if (complex.im.isNaN) {
            complex.im = 0
        }
        if (complex.re.isInfinite) {
            complex.re = 99999
        }
        if (complex.im.isInfinite) {
            complex.im = 99999
        }
        return complex
    }
    
}

