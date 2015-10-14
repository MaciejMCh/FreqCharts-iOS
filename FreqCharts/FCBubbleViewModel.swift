//
//  KPBubbleViewModel.swift
//  FreqCharts
//
//  Created by Maciej Chmielewski on 12.10.2015.
//  Copyright © 2015 maciejCh. All rights reserved.
//

import UIKit

class FCBubbleViewModel: NSObject {

    var radius: Float
    var equation: FCEquation
    var connections: [FCBubbleViewModel] = [FCBubbleViewModel]()
    
    override init() {
        self.radius = 20
        self.equation = FCEquation(mainSymbol: FCNullSymbol(), font: UIFont.systemFontOfSize(18))
    }
    
    init(radius: Float, equation: FCEquation) {
        self.radius = radius;
        self.equation = equation
    }
    
    init(equation: FCEquation) {
        self.radius = Float(equation.displayingSize!.width / 2)
        self.equation = equation
    }
    
    func connect(bubble: FCBubbleViewModel) {
        if (self.connections .contains(bubble)) {
            return
        }
        self.connections.append(bubble)
        NSLog("connecitons " + String(radius) + String(self.connections))
    }
    
    func isConnected(bubble: FCBubbleViewModel) -> Bool {
        if (self.connections.contains(bubble)) {
            return true
        }
        return false
    }
    
}
