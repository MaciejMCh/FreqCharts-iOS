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
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.equation = FCEquation()
        self.update()
    }
    
    func update() {
        for view in self.subviews {
            view .removeFromSuperview()
        }
        
        let equationContainer = UIView()
        let eqView = self.equation.view(FCMovingButton.greenColor, font: UIFont.systemFontOfSize(25))
        equationContainer.addSubview(eqView)
        self.addSubview(equationContainer)
        equationContainer.autoCenterInSuperview()
        eqView.autoPinEdgesToSuperviewEdges()
    }

}