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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.whiteColor()
        self.clipsToBounds = true
        
        self.webView.backgroundColor = UIColor.redColor()
        
        
        self.contentView.addSubview(self.webView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
