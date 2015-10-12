//
//  ViewController.swift
//  FreqCharts
//
//  Created by Maciej Chmielewski on 12.10.2015.
//  Copyright © 2015 maciejCh. All rights reserved.
//

import UIKit

class FCEquationViewController: UIViewController {
    
    @IBOutlet var webView: UIWebView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.webView.opaque = false
        
        let frac = FCFractionSymbol(overSymbol: FCNumberSymbol(value: 10), underSymbol: FCAddSymbol(LHSSymbol: FCOperatorSymbol(), RHSSymbol: FCNumberSymbol(value: 1000)))
        let par = FCParenthesesSymbol(childSymbol: frac)
        var mainEquation = FCEquation(mainSymbol: par, font: UIFont.systemFontOfSize(16, weight: UIFontWeightLight))
        NSLog(mainEquation.htmlRepresentation())
        
        self.webView.loadHTMLString(mainEquation.htmlRepresentation(), baseURL: nil)
        NSLog("asd")
    }

}

