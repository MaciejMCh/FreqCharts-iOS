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
        let frac = FCFracSymbol(overSymbol: FCNumberSymbol(value: 10), underSymbol: FCNumberSymbol(value: 14))
        var mainEquation = FCEquation(mainSymbol: frac, font: UIFont.systemFontOfSize(16, weight: UIFontWeightLight))
        NSLog(mainEquation.htmlRepresentation())
        
        self.webView.loadHTMLString(mainEquation.htmlRepresentation(), baseURL: nil)
    }

}

