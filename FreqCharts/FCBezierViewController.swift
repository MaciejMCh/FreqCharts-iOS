//
//  FCBezierViewController.swift
//  FreqCharts
//
//  Created by Maciej Chmielewski on 19.10.2015.
//  Copyright © 2015 maciejCh. All rights reserved.
//

import UIKit

class FCBezierViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
//        (self.view as! FCBezierPathView).passPoints([CGPointMake(100, 100), CGPointMake(120, 100), CGPointMake(100, 140), CGPointMake(200, 200), CGPointMake(140, 89)])
        
        var iner: FCSymbol = FCFractionSymbol(overSymbol: FCNumberSymbol(value: 1), underSymbol: FCAddSymbol(LHSSymbol: FCOperatorSymbol(multipler: 1), RHSSymbol: FCNumberSymbol(value: 1)))
        
//        iner = FCAddSymbol(LHSSymbol: FCOperatorSymbol(multipler: 1), RHSSymbol: FCNumberSymbol(value: 10))
        
        let zeroResponse = iner.responseForFrequency(0)
        let infinityResponse = iner.responseForFrequency(Double.infinity)
        
        let size = (zeroResponse - infinityResponse).abs
        
        let numberOfSteps = 100
        
        let stepSize = size / Double(numberOfSteps)
        
        var step = Double(1)
        
        var stepDiff = 0.1
        
        let accuracy = 0.01
        let maxError = stepDiff * accuracy
        
        var tooBig = false
        var changesCount = Int(0)
        
        while(true) {
            
            let response = iner.responseForFrequency(step)
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
            complexes.append(iner.responseForFrequency(step))
            
            if (complexes.count > numberOfSteps) {
                break
            }
        }
        
        let points = complexes.map { (me) -> CGPoint in
            return CGPointMake(CGFloat(me.real), CGFloat(me.imag))
        }
        
        (self.view as! FCBezierPathView).passPoints(points)
        
    }
    
}
