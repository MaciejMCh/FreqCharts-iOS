//
//  FCMenuButton.swift
//  FreqCharts
//
//  Created by Maciej Chmielewski on 17.10.2015.
//  Copyright © 2015 maciejCh. All rights reserved.
//

import UIKit

class FCMenuButton: UIButton {

    
    override var enabled: Bool {
        set {
            
            if (newValue == !self.hidden) {
                return
            }
            
            if (newValue) {
                self.hidden = false
            }
            
            let fromT = newValue ? CGAffineTransformMakeScale(0, 0) : CGAffineTransformIdentity
            let toT = newValue ? CGAffineTransformIdentity : CGAffineTransformMakeScale(0, 0)
            
            self.transform = fromT
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                self.transform = toT
                }) { (finished) -> Void in
                    if !newValue {
                        self.hidden = true
                    }
            }
        }
        
        get {
            return super.enabled
        }
    }
    

}
