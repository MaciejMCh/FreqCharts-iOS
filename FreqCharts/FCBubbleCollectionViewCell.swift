//
//  KPBubbleCollectionViewCell.swift
//  FreqCharts
//
//  Created by Maciej Chmielewski on 12.10.2015.
//  Copyright © 2015 maciejCh. All rights reserved.
//

import UIKit

class FCBubbleCollectionViewCell: UICollectionViewCell {
    
    var webView = UIWebView ()
    var widthConstraint: NSLayoutConstraint!
    var heightConstraint: NSLayoutConstraint!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.whiteColor()
        self.clipsToBounds = true
        
        self.webView.backgroundColor = UIColor.redColor()
        self.contentView.addSubview(self.webView)
        
        self.initConstraints()
        
        
        self.webView.alpha = 0.0
    }
    
    func initConstraints() {
        self.webView.translatesAutoresizingMaskIntoConstraints = false
        
        self.heightConstraint = NSLayoutConstraint(item: self.webView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 100.0)
        self.widthConstraint = NSLayoutConstraint(item: self.webView, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 100.0)
        
        let xCenterConstraint = NSLayoutConstraint(item: self.contentView, attribute: .CenterX, relatedBy: .Equal, toItem: self.webView, attribute: .CenterX, multiplier: 1, constant: 0)
        let yCenterConstraint = NSLayoutConstraint(item: self.contentView, attribute: .CenterY, relatedBy: .Equal, toItem: self.webView, attribute: .CenterY, multiplier: 1, constant: 0)
        
        self.contentView.addConstraints([self.widthConstraint, self.heightConstraint, xCenterConstraint, yCenterConstraint])
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
