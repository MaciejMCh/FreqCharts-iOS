//
//  FCSymbol.swift
//  FreqCharts
//
//  Created by Maciej Chmielewski on 12.10.2015.
//  Copyright © 2015 maciejCh. All rights reserved.
//

import Foundation
import UIKit

protocol FCSymbol {
    func htmlRepresentation() -> String
//    func responseForFrequency(frequency: Double) -> Double
}

class FCEquation: NSObject, FCSymbol {
    private let mainSymbol: FCSymbol
    private let font: UIFont
    
    init(mainSymbol: FCSymbol, font: UIFont) {
        self.mainSymbol = mainSymbol
        self.font = font
    }
    
    func htmlRepresentation() -> String {
        return "<math>" +
                self.mainSymbol.htmlRepresentation() +
                "</math>"
    }
}

class FCNumberSymbol: NSObject, FCSymbol {
    var numberFormatter: NSNumberFormatter {
        return NSNumberFormatter()
    }
    
    private let value: Double
    
    init(value: Double) {
        self.value = value
    }
    
    func htmlRepresentation() -> String {
        let numberFormatter = NSNumberFormatter()
        numberFormatter.decimalSeparator = ","
        
        var numberString = numberFormatter.stringFromNumber(self.value)!
        
        return "<mn>" + numberString + "</mn>"
    }
}

class FCNullSymbol: NSObject, FCSymbol {
    func htmlRepresentation() -> String {
        return "<mn>0</mn>"
    }
}

class FCParenthesesSymbol: NSObject, FCSymbol {
    private var childSymbol: FCSymbol
    
    override init() {
        self.childSymbol = FCNullSymbol()
    }
    
    init(childSymbol: FCSymbol) {
        self.childSymbol = childSymbol
    }
    
    func htmlRepresentation() -> String {
        return "<mfenced>" +
            self.childSymbol.htmlRepresentation()
        "</mfenced>"
    }
}

class FCOperatorSymbol: NSObject, FCSymbol {
    private var multipler: Double
    
    override init() {
        self.multipler = 1
    }
    
    init(multipler: Double) {
        self.multipler = multipler
    }
    
    func htmlRepresentation() -> String {
        return "<mtext>S</mtext>"
    }
    
}

class FCFractionSymbol: NSObject, FCSymbol {
    private var overSymbol: FCSymbol
    private var underSymbol: FCSymbol
    
    override init() {
        self.overSymbol = FCNullSymbol()
        self.underSymbol = FCNullSymbol()
    }
    
    init(overSymbol: FCSymbol, underSymbol: FCSymbol) {
        self.overSymbol = overSymbol
        self.underSymbol = underSymbol
    }
    
    func htmlRepresentation() -> String {
        return "<mfrac>" +
                self.overSymbol.htmlRepresentation() +
                "<mrow>" +
                self.underSymbol.htmlRepresentation() +
                "</mrow></mfrac>"
    }
}

class FCSidedSymbol: NSObject, FCSymbol {
    private var LHSSymbol: FCSymbol
    private var RHSSymbol: FCSymbol
    private var operationSymbol: String
    
    override init() {
        self.LHSSymbol = FCNullSymbol()
        self.RHSSymbol = FCNullSymbol()
        self.operationSymbol = " "
    }
    
    init(LHSSymbol: FCSymbol, RHSSymbol: FCSymbol, operatorSymbol: String) {
        self.LHSSymbol = LHSSymbol
        self.RHSSymbol = RHSSymbol
        self.operationSymbol = operatorSymbol
    }
    
    func htmlRepresentation() -> String {
        return self.LHSSymbol.htmlRepresentation() +
                "<mo>" +
                self.operationSymbol +
                "</mo>" +
                self.RHSSymbol.htmlRepresentation()
    }
}

class FCAddSymbol: FCSidedSymbol {
    init(LHSSymbol: FCSymbol, RHSSymbol: FCSymbol) {
        super.init(LHSSymbol: LHSSymbol, RHSSymbol: RHSSymbol, operatorSymbol: "+")
    }
}

