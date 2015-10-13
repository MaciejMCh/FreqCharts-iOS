//
//  FCSymbol.swift
//  FreqCharts
//
//  Created by Maciej Chmielewski on 12.10.2015.
//  Copyright © 2015 maciejCh. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    func pb_takeSnapshot() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, UIScreen.mainScreen().scale)
        
        drawViewHierarchyInRect(self.bounds, afterScreenUpdates: true)
        
        // old style: layer.renderInContext(UIGraphicsGetCurrentContext())
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}

protocol spierdolonyNSCodingWSwifcie {
    func dictionaryValue() -> [String: AnyObject]
}

class FCSymbolSizeCalculator: NSObject, UIWebViewDelegate {
    
    private var webView = UIWebView(frame: CGRectMake(0, 0, 10, 10))
    private var completionBlock: ((size: CGSize) -> ())!
    
    func calculateSizeOfEquation(equation: FCEquation, completionBlock: (size: CGSize) -> ()) {
        self.completionBlock = completionBlock
        self.webView.delegate = self
        self.webView.loadHTMLString(equation.htmlRepresentation(), baseURL: nil)
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        
        let image = webView.pb_takeSnapshot()
        
        var frame = webView.frame
        frame.size.height = 1
        frame.size.width = 1
        webView.frame = frame
        var fittingSize = webView.sizeThatFits(CGSizeZero)
        frame.size = fittingSize
        self.completionBlock(size: CGSizeMake(CGRectGetWidth(frame), CGRectGetHeight(frame)))
    }
    
}

class FCSymbolParser {
    class func parse(dictionary: [String: AnyObject]) -> FCSymbol {
        let className = "FreqCharts." + Array(dictionary.keys)[0]
        let parseClass = NSClassFromString(className)!
        let parseDict: [String: AnyObject] = dictionary[Array(dictionary.keys)[0]]! as! [String : AnyObject]
        let object = FCSwiftShitness.instantiateClass(parseClass, dictionary: parseDict)
        return object as! FCSymbol
    }
}

protocol FCSymbol: spierdolonyNSCodingWSwifcie {
    func htmlRepresentation() -> String
//    func responseForFrequency(frequency: Double) -> Double
}

class FCEquation: NSObject, FCSymbol {
    private var mainSymbol: FCSymbol
    private var font: UIFont
    private var displayingSize: CGSize?
    
    init(mainSymbol: FCSymbol, font: UIFont) {
        self.mainSymbol = mainSymbol
        self.font = font
    }
    
    override init() {
        self.mainSymbol = FCNullSymbol()
        self.font = UIFont()
    }
    
    func htmlRepresentation() -> String {
        let colorString = "2F92E5"
        return "<body style=\"background:none\"><math><mstyle mathcolor=" + colorString + ">" +
                self.mainSymbol.htmlRepresentation() +
                "</mstyle></math></body>"
    }
    
    func dictionaryValue() -> [String: AnyObject] {
        return [String(self.classForCoder): ["mainSymbol": self.mainSymbol.dictionaryValue()]]
    }
    
    init(dictionary: [String: AnyObject]) {
        self.mainSymbol = FCSymbolParser.parse(dictionary["mainSymbol"]! as! [String : AnyObject])
        self.font = UIFont()
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
    
    func dictionaryValue() -> [String: AnyObject] {
        return [String(self.classForCoder): ["value": self.value]]
    }
    
    init(dictionary: [String: AnyObject]) {
        self.value = dictionary["value"] as! Double
    }
}

class FCNullSymbol: NSObject, FCSymbol {
    func htmlRepresentation() -> String {
        return "<mn>0</mn>"
    }
    
    func dictionaryValue() -> [String: AnyObject] {
        return [String(self.classForCoder): "null"]
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
    
    func dictionaryValue() -> [String: AnyObject] {
        return [String(self.classForCoder): ["childSymbol" : self.childSymbol.dictionaryValue()]]
    }
    
    init(dictionary: [String: AnyObject]) {
        self.childSymbol = FCSymbolParser.parse(dictionary["childSymbol"]! as! [String : AnyObject])
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
    
    func dictionaryValue() -> [String: AnyObject] {
        return [String(self.classForCoder): ["multipler" : self.multipler]]
    }
    
    init(dictionary: [String: AnyObject]) {
        self.multipler = dictionary["multipler"] as! Double
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
    
    func dictionaryValue() -> [String: AnyObject] {
        return [String(self.classForCoder): ["overSymbol": self.overSymbol.dictionaryValue(), "underSymbol": self.underSymbol.dictionaryValue()]]
    }
    
    init(dictionary: [String: AnyObject]) {
        self.overSymbol = FCSymbolParser.parse(dictionary["overSymbol"]! as! [String : AnyObject])
        self.underSymbol = FCSymbolParser.parse(dictionary["underSymbol"]! as! [String : AnyObject])
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
    
    func dictionaryValue() -> [String: AnyObject] {
        return [String(self.classForCoder): ["LHS": self.LHSSymbol.dictionaryValue(), "RHS": self.RHSSymbol.dictionaryValue(), "oeprator": self.operationSymbol]]
    }
}

class FCAddSymbol: FCSidedSymbol {
    init(LHSSymbol: FCSymbol, RHSSymbol: FCSymbol) {
        super.init(LHSSymbol: LHSSymbol, RHSSymbol: RHSSymbol, operatorSymbol: "+")
    }
    
    override func dictionaryValue() -> [String: AnyObject] {
        return [String(self.classForCoder): ["LHS": self.LHSSymbol.dictionaryValue(), "RHS": self.RHSSymbol.dictionaryValue(), "oeprator": "+"]]
    }
    init(dictionary: [String: AnyObject]) {
        super.init()
        self.LHSSymbol = FCSymbolParser.parse(dictionary["LHS"]! as! [String : AnyObject])
        self.RHSSymbol = FCSymbolParser.parse(dictionary["RHS"]! as! [String : AnyObject])
        self.operationSymbol = dictionary["oeprator"] as! String
    }
}

