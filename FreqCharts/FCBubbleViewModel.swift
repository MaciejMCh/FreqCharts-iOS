//
//  KPBubbleViewModel.swift
//  FreqCharts
//
//  Created by Maciej Chmielewski on 12.10.2015.
//  Copyright © 2015 maciejCh. All rights reserved.
//

import UIKit

class FCBubbleViewModel: NSObject {

    var radius: Float
    var connections: [FCBubbleViewModel] = [FCBubbleViewModel]()
    
    override init() {
        self.radius = 20
    }
    
    init(radius: Float) {
        self.radius = radius;
    }
    
    func connect(bubble: FCBubbleViewModel) {
        if (self.connections .contains(bubble)) {
            return
        }
        self.connections.append(bubble)
        NSLog("connecitons " + String(radius) + String(self.connections))
    }
    
    func isConnected(bubble: FCBubbleViewModel) -> Bool {
        if (self.connections.contains(bubble)) {
            return true
        }
        return false
    }
    
}
