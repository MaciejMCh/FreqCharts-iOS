//
//  FCEquationView.swift
//  FreqCharts
//
//  Created by Maciej Chmielewski on 15.10.2015.
//  Copyright © 2015 maciejCh. All rights reserved.
//

import UIKit

class FCEquationView: UIView {
    
    var equation: FCEquation!
    var font: UIFont!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.grayColor()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        let frac = FCFractionSymbol(overSymbol: FCNumberSymbol(value: 10), underSymbol: FCAddSymbol(LHSSymbol: FCOperatorSymbol(), RHSSymbol: FCNumberSymbol(value: 1000)))
        let par = FCParenthesesSymbol(childSymbol: frac)
        var mainEquation = FCEquation(mainSymbol: par, font: UIFont())
        
        mainEquation = FCEquation()
        self.equation = mainEquation
        self.update()
    }
    
    func update() {
        for view in self.subviews {
            view .removeFromSuperview()
        }
        
        let equationContainer = UIView()
        let eqView = self.equation.view(UIColor .blueColor(), font: UIFont.systemFontOfSize(20))
        equationContainer.addSubview(eqView)
        self.addSubview(equationContainer)
        equationContainer.autoCenterInSuperview()
        eqView.autoPinEdgesToSuperviewEdges()
    }

}