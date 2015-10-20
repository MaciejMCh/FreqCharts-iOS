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
        
        var complexesStraight = [Complex<Double>]()
        var complexesInverse = [Complex<Double>]()
        
        let stepFrac = 0.1
        var straightStep = Double(1)
        var inverseStep = Double(1)
        
        for index in 0...1000 {
            
            complexesStraight.append(self.symbol.responseForFrequency(straightStep))
            complexesInverse.insert(self.symbol.responseForFrequency(inverseStep), atIndex: 0)
            
            straightStep *= 1 + stepFrac
            inverseStep *= 1 - stepFrac
        }
        
        let complexes = complexesInverse + complexesStraight
        
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

