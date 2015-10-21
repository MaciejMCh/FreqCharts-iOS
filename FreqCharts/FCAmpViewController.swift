//
//  FCAmpViewController.swift
//  FreqCharts
//
//  Created by Maciej Chmielewski on 21.10.2015.
//  Copyright © 2015 maciejCh. All rights reserved.
//

import UIKit

class FCAmpViewController: UIViewController {

    var symbol: FCSymbol!
    
    class func controllerWithSymbol(symbol: FCSymbol) -> FCAmpViewController {
        var controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("FCAmpViewController") as! FCAmpViewController
        controller.symbol = symbol
        return controller
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.symbol = FCFractionSymbol(overSymbol: FCNumberSymbol(value: 1), underSymbol: FCAddSymbol(LHSSymbol: FCOperatorSymbol(multipler: 1), RHSSymbol: FCNumberSymbol(value: 1)))
        
        
        
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
            let index = complexes.indexOf(me)!
            return CGPointMake(CGFloat(index), CGFloat(me.abs))
        }
        
        (self.view as! FCBodeView).passPoints(points)
    }
}
