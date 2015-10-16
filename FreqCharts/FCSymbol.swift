//
//  FCSymbol.swift
//  FreqCharts
//
//  Created by Maciej Chmielewski on 12.10.2015.
//  Copyright © 2015 maciejCh. All rights reserved.
//

import Foundation
import UIKit

class FCNumberFormatter {
    class func stringForDouble(double: Double) -> String {
        var string = NSString(format: "%.1f", double)
        string = string.stringByReplacingOccurrencesOfString(".0", withString: "")
        return string as String
    }
}

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
        self.completionBlock(size: fittingSize)
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
    func view(color: UIColor, font: UIFont) -> UIView
    func nulls() -> [FCNullSymbol]
    func fillNull(null: AnyObject, symbol: AnyObject)
//    func responseForFrequency(frequency: Double) -> Double
    
}

extension FCSymbol {
    func nulls() -> [FCNullSymbol] {
        return []
    }
    func fillNull(null: AnyObject, symbol: AnyObject) {
        
    }
}

class FCEquation: NSObject, FCSymbol {
    private var mainSymbol: FCSymbol!
    private var font: UIFont!
    var displayingSize: CGSize?
    
    init(mainSymbol: FCSymbol, font: UIFont) {
        self.mainSymbol = mainSymbol
        self.font = font
    }
    
    override init() {
        super.init()
        self.mainSymbol = FCNullSymbol(parent: self)
        self.font = UIFont()
    }
    
    func htmlRepresentation() -> String {
        let colorString = "2F92E5"
        return "<body style=\"background:none\"><math><mstyle mathsize='2.0em' mathcolor=" + colorString + ">" +
                self.mainSymbol.htmlRepresentation() +
                "</mstyle></math></body>"
    }
    
    func dictionaryValue() -> [String: AnyObject] {
        var dict: [String: AnyObject] = ["mainSymbol": self.mainSymbol.dictionaryValue()]
        if (self.displayingSize != nil) {
            dict["width"] = self.displayingSize!.width
            dict["height"] = self.displayingSize!.height
        }
        
        return [String(self.classForCoder): dict]
    }
    
    init(dictionary: [String: AnyObject]) {
        self.mainSymbol = FCSymbolParser.parse(dictionary["mainSymbol"]! as! [String : AnyObject])
        self.displayingSize = CGSizeMake(CGFloat(dictionary["width"] as! NSNumber), CGFloat(dictionary["height"] as! NSNumber))
        self.font = UIFont()
    }
    
    func view(color: UIColor, font: UIFont) -> UIView {
        return self.mainSymbol.view(color, font: font)
    }
    
    func nulls() -> [FCNullSymbol] {
        return self.mainSymbol.nulls()
    }
    
    func fillNull(null: AnyObject, symbol: AnyObject) {
        self.mainSymbol = symbol as? FCSymbol
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
    
    func view(color: UIColor, font: UIFont) -> UIView {
        let label = UILabel()
        label.font = font
        label.textColor = color
        label.text = FCNumberFormatter.stringForDouble(self.value)
        return label
    }
}

class FCNullSymbol: NSObject, FCSymbol {
    
    var nullView: UIView?
    var parentSymbol: FCSymbol
    
    init(parent: FCSymbol) {
        self.parentSymbol = parent
    }
    
    func htmlRepresentation() -> String {
        return "<mn mathcolor=FF0000>▢</mn>"
    }
    
    func dictionaryValue() -> [String: AnyObject] {
        return [String(self.classForCoder): "null"]
    }
    
    func view(color: UIColor, font: UIFont) -> UIView {
        let view = FCDropView()
        
        view.layer.cornerRadius = 5
        view.layer.borderColor = FCMovingButton.greenColor.CGColor
        view.layer.borderWidth = 2
        view.backgroundColor = FCMovingButton.greenColor.colorWithAlphaComponent(0.4)
        
        view.autoSetDimensionsToSize(CGSizeMake(font.pointSize, font.pointSize / 2 * 3))
        self.nullView = view
        return view
    }
    
    func nulls() -> [FCNullSymbol] {
        return [self]
    }
    
}

class FCParenthesesSymbol: NSObject, FCSymbol {
    private var childSymbol: FCSymbol!
    
    override init() {
        super.init()
        self.childSymbol = FCNullSymbol(parent: self)
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
    
    func view(color: UIColor, font: UIFont) -> UIView {
        let childView = self.childSymbol.view(color, font: font)
        let container = UIView()
        let leftParenthesis = UIImageView()
        leftParenthesis.translatesAutoresizingMaskIntoConstraints = false
        leftParenthesis.image = UIImage(named: "leftPar")!.imageWithRenderingMode(.AlwaysTemplate)
        leftParenthesis.tintColor = color
        let rightParenthesis = UIImageView()
        rightParenthesis.translatesAutoresizingMaskIntoConstraints = false
        rightParenthesis.image = UIImage(named: "rightPar")!.imageWithRenderingMode(.AlwaysTemplate)
        rightParenthesis.tintColor = color
        container.addSubview(childView)
        container.addSubview(leftParenthesis)
        container.addSubview(rightParenthesis)
        
        childView.autoPinEdgeToSuperviewEdge(.Top)
        childView.autoPinEdgeToSuperviewEdge(.Bottom)
        
        childView.autoPinEdge(.Leading, toEdge: .Trailing, ofView: leftParenthesis)
        childView.autoPinEdge(.Trailing, toEdge: .Leading, ofView: rightParenthesis)
        
        leftParenthesis.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsZero, excludingEdge: .Trailing)
        rightParenthesis.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsZero, excludingEdge: .Leading)
        
        leftParenthesis.autoMatchDimension(.Width, toDimension: .Height, ofView: leftParenthesis, withMultiplier: 0.2)
        rightParenthesis.autoMatchDimension(.Width, toDimension: .Height, ofView: rightParenthesis, withMultiplier: 0.2)
        
        leftParenthesis.setContentCompressionResistancePriority(100, forAxis: UILayoutConstraintAxis.Vertical)
        rightParenthesis.setContentCompressionResistancePriority(100, forAxis: UILayoutConstraintAxis.Vertical)
        leftParenthesis.setContentCompressionResistancePriority(100, forAxis: UILayoutConstraintAxis.Horizontal)
        rightParenthesis.setContentCompressionResistancePriority(100, forAxis: UILayoutConstraintAxis.Horizontal)
        
        return container
    }
    
    func nulls() -> [FCNullSymbol] {
        return self.childSymbol.nulls()
    }
    
    func fillNull(null: AnyObject, symbol: AnyObject) {
        self.childSymbol = symbol as? FCSymbol
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
    

    func view(color: UIColor, font: UIFont) -> UIView {
        let label = UILabel()
        label.font = font
        label.textColor = color
        var string = FCNumberFormatter.stringForDouble(self.multipler) + "s"
        string.stringByReplacingOccurrencesOfString("1s", withString: "s")
        label.text = string
        return label
    }
    
}

class FCFractionSymbol: NSObject, FCSymbol {
    private var overSymbol: FCSymbol!
    private var underSymbol: FCSymbol!
    
    override init() {
        super.init()
        self.overSymbol = FCNullSymbol(parent: self)
        self.underSymbol = FCNullSymbol(parent: self)
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
    
    func view(color: UIColor, font: UIFont) -> UIView {
        let line = UIView()
        line.backgroundColor = color
        
        let viewUnder = self.underSymbol.view(color, font: font)
        let viewOver = self.overSymbol.view(color, font: font)
        
        let container = UIView()
        container.addSubview(line)
        container.addSubview(viewUnder)
        container.addSubview(viewOver)
        
        line.autoSetDimension(.Height, toSize: 1)
        line.autoPinEdgeToSuperviewEdge(.Leading)
        line.autoPinEdgeToSuperviewEdge(.Trailing)
        
        viewOver.autoPinEdgeToSuperviewEdge(.Top)
        viewOver.autoPinEdge(.Bottom, toEdge: .Top, ofView: line)
        viewOver.autoAlignAxisToSuperviewAxis(.Vertical)
        
        viewUnder.autoPinEdgeToSuperviewEdge(.Bottom)
        viewUnder.autoPinEdge(.Top, toEdge: .Bottom, ofView: line)
        viewUnder.autoAlignAxisToSuperviewAxis(.Vertical)
        
        
        line.autoMatchDimension(.Width, toDimension: .Width, ofView: viewUnder, withMultiplier: 1.0, relation: NSLayoutRelation.GreaterThanOrEqual)
        let constraint = line.autoMatchDimension(.Width, toDimension: .Width, ofView: viewOver, withMultiplier: 1.0, relation: NSLayoutRelation.Equal)
        constraint.priority = 100
        
        return container
    }
    
    func nulls() -> [FCNullSymbol] {
        return underSymbol.nulls() + overSymbol.nulls()
    }
    
    func fillNull(null: AnyObject, symbol: AnyObject) {
        if (null === self.overSymbol as? AnyObject) {
            self.overSymbol = symbol as? FCSymbol
        } else {
            self.underSymbol = symbol as? FCSymbol
        }
    }
}

class FCSidedSymbol: NSObject, FCSymbol {
    private var LHSSymbol: FCSymbol!
    private var RHSSymbol: FCSymbol!
    private var operationSymbol: String!
    
    override init() {
        super.init()
        self.LHSSymbol = FCNullSymbol(parent: self)
        self.RHSSymbol = FCNullSymbol(parent: self)
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
    
    func view(color: UIColor, font: UIFont) -> UIView {
        let container = UIView()
        
        let LHSView = self.LHSSymbol.view(color, font: font)
        let RHSView = self.RHSSymbol.view(color, font: font)
        
        let operatorLabel = UILabel()
        operatorLabel.text = self.operationSymbol
        operatorLabel.textColor = color
        operatorLabel.font = font
        
        container.addSubview(LHSView)
        container.addSubview(RHSView)
        container.addSubview(operatorLabel)
        
        LHSView.autoPinEdgeToSuperviewEdge(.Leading)
        LHSView.autoAlignAxisToSuperviewAxis(.Horizontal)
        
        operatorLabel.autoPinEdge(.Leading, toEdge: .Trailing, ofView: LHSView)
        operatorLabel.autoPinEdgeToSuperviewEdge(.Top)
        operatorLabel.autoPinEdgeToSuperviewEdge(.Bottom)
        
        RHSView.autoPinEdge(.Leading, toEdge: .Trailing, ofView: operatorLabel)
        RHSView.autoPinEdgeToSuperviewEdge(.Trailing)
        RHSView.autoAlignAxisToSuperviewAxis(.Horizontal)
        
        operatorLabel.autoMatchDimension(.Height, toDimension: .Height, ofView: LHSView, withOffset: 0.0, relation: NSLayoutRelation.GreaterThanOrEqual)
        operatorLabel.autoMatchDimension(.Height, toDimension: .Height, ofView: RHSView, withOffset: 0.0, relation: NSLayoutRelation.Equal).priority -= 1
        
        return container
    }
    
    func nulls() -> [FCNullSymbol] {
        return LHSSymbol.nulls() + RHSSymbol.nulls()
    }
    
    func fillNull(null: AnyObject, symbol: AnyObject) {
        if (null === self.LHSSymbol as? AnyObject) {
            self.LHSSymbol = symbol as? FCSymbol
        } else {
            self.RHSSymbol = symbol as? FCSymbol
        }
    }
}

class FCAddSymbol: FCSidedSymbol {
    init(LHSSymbol: FCSymbol, RHSSymbol: FCSymbol) {
        super.init(LHSSymbol: LHSSymbol, RHSSymbol: RHSSymbol, operatorSymbol: "+")
    }
    
    override init() {
        super.init()
        self.operationSymbol = "+"
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

class FCSubstractSymbol: FCSidedSymbol {
    init(LHSSymbol: FCSymbol, RHSSymbol: FCSymbol) {
        super.init(LHSSymbol: LHSSymbol, RHSSymbol: RHSSymbol, operatorSymbol: "+")
    }
    
    override init() {
        super.init()
        self.operationSymbol = "-"
    }
    
    override func dictionaryValue() -> [String: AnyObject] {
        return [String(self.classForCoder): ["LHS": self.LHSSymbol.dictionaryValue(), "RHS": self.RHSSymbol.dictionaryValue(), "oeprator": "-"]]
    }
    init(dictionary: [String: AnyObject]) {
        super.init()
        self.LHSSymbol = FCSymbolParser.parse(dictionary["LHS"]! as! [String : AnyObject])
        self.RHSSymbol = FCSymbolParser.parse(dictionary["RHS"]! as! [String : AnyObject])
        self.operationSymbol = dictionary["oeprator"] as! String
    }
}

class FCMultipleSymbol: FCSidedSymbol {
    init(LHSSymbol: FCSymbol, RHSSymbol: FCSymbol) {
        super.init(LHSSymbol: LHSSymbol, RHSSymbol: RHSSymbol, operatorSymbol: "")
    }
    
    override init() {
        super.init()
        self.operationSymbol = ""
    }
    
    override func dictionaryValue() -> [String: AnyObject] {
        return [String(self.classForCoder): ["LHS": self.LHSSymbol.dictionaryValue(), "RHS": self.RHSSymbol.dictionaryValue(), "oeprator": ""]]
    }
    init(dictionary: [String: AnyObject]) {
        super.init()
        self.LHSSymbol = FCSymbolParser.parse(dictionary["LHS"]! as! [String : AnyObject])
        self.RHSSymbol = FCSymbolParser.parse(dictionary["RHS"]! as! [String : AnyObject])
        self.operationSymbol = dictionary["oeprator"] as! String
    }
    
}

class FCPowerSymbol: NSObject, FCSymbol {
    private var baseSymbol: FCSymbol!
    private var exponent: Int!
    
    init(exponent: Int) {
        super.init()
        self.baseSymbol = FCNullSymbol(parent: self)
        self.exponent = exponent
    }
    
    override init() {
        super.init()
        self.baseSymbol = FCNullSymbol(parent: self)
        self.exponent = 0
    }
    
    func htmlRepresentation() -> String {
        return ""
    }
    
    func dictionaryValue() -> [String: AnyObject] {
        return [String(self.classForCoder): ["exponent" : self.exponent]]
    }
    
    init(dictionary: [String: AnyObject]) {
        self.exponent = dictionary["exponent"] as! Int
    }
    
    func view(color: UIColor, font: UIFont) -> UIView {
        let container = UIView()
        let baseView = self.baseSymbol.view(color, font: font)
        let exponentLabel = UILabel()
        exponentLabel.textColor = color
        exponentLabel.font = UIFont(name: font.fontName, size: font.pointSize / CGFloat(2))
        exponentLabel.text = String(self.exponent)
        container.addSubview(baseView)
        container.addSubview(exponentLabel)
        
        exponentLabel.autoPinEdgeToSuperviewEdge(.Top)
        exponentLabel.autoPinEdgeToSuperviewEdge(.Trailing)
        exponentLabel.autoPinEdge(.Leading, toEdge: .Trailing, ofView: baseView)
        
        baseView.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsZero, excludingEdge: .Trailing)
        
        return container
    }
    
    func nulls() -> [FCNullSymbol] {
        return self.baseSymbol.nulls()
    }
    
    func fillNull(null: AnyObject, symbol: AnyObject) {
        self.baseSymbol = symbol as! FCSymbol
    }
}

