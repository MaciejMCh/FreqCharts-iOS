//
//  FCBezierViewController.swift
//  FreqCharts
//
//  Created by Maciej Chmielewski on 19.10.2015.
//  Copyright © 2015 maciejCh. All rights reserved.
//

import UIKit

class FCBezierViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        (self.view as! FCBezierPathView).passPoints([CGPointMake(100, 100), CGPointMake(120, 100), CGPointMake(100, 140), CGPointMake(200, 200), CGPointMake(140, 89)])
    }
    
}
