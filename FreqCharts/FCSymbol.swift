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

class FCFracSymbol: NSObject, FCSymbol {
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