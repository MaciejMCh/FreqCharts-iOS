//
//  FCCircleView.swift
//  FreqCharts
//
//  Created by Maciej Chmielewski on 15.10.2015.
//  Copyright © 2015 maciejCh. All rights reserved.
//

import UIKit

class FCCircleView: UIView {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = CGRectGetWidth(self.frame) / 2
    }

}
