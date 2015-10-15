//
//  ViewController.swift
//  FreqCharts
//
//  Created by Maciej Chmielewski on 12.10.2015.
//  Copyright © 2015 maciejCh. All rights reserved.
//

import UIKit
import WebKit

class FCEquationViewController: UIViewController, UIWebViewDelegate {
    
    @IBOutlet var webView: UIWebView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.webView.opaque = false
        
//        let frac = FCFractionSymbol(overSymbol: FCNumberSymbol(value: 10), underSymbol: FCAddSymbol(LHSSymbol: FCOperatorSymbol(), RHSSymbol: FCNumberSymbol(value: 1000)))
//        let par = FCParenthesesSymbol(childSymbol: frac)
//        var mainEquation = FCEquation(mainSymbol: par, font: UIFont.systemFontOfSize(16, weight: UIFontWeightLight))
//        NSLog(mainEquation.htmlRepresentation())
        
        let filePath = NSBundle.mainBundle().pathForResource("test", ofType: "html")
        let data = NSData(contentsOfFile: filePath!)
        
        self.webView.delegate = self
        self.webView.loadData(data!, MIMEType: "text/html", textEncodingName: "UTF-8", baseURL: NSURL())
//        self.webView.loadHTMLString(mainEquation.htmlRepresentation(), baseURL: nil)
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        var frame = webView.frame
        frame.size.height = 1
        frame.size.width = 1
        webView.frame = frame
        var fittingSize = webView.sizeThatFits(CGSizeZero)
        frame.size = fittingSize
        webView.frame = frame
        NSLog(String(frame))
    }
    
    func displayEquation(equation: FCEquation) {
        
        if (self.webView == nil) {
            self.webView = UIWebView()
            self.webView.delegate = self
            self.view.addSubview(self.webView)
        }
        
        self.webView.loadHTMLString(equation.htmlRepresentation(), baseURL: nil)
    }

}
