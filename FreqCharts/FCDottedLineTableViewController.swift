//
//  FCDottedLineTableViewController.swift
//  FreqCharts
//
//  Created by Maciej Chmielewski on 16.10.2015.
//  Copyright © 2015 maciejCh. All rights reserved.
//

import UIKit

class FCDottedLineTableViewController: UITableViewController {

    var tick: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.registerClass(UITableViewCell.classForCoder(), forCellReuseIdentifier: "ri")
        self.tableView.separatorStyle = .None
        self.tableView.backgroundColor = UIColor.clearColor()
        self.tableView.showsHorizontalScrollIndicator = false
        self.tableView.showsVerticalScrollIndicator = false
        self.animate()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ri", forIndexPath: indexPath)

        cell.backgroundColor = indexPath.row % 2 == 0 ? UIColor.clearColor() : FCMovingButton.greenColor
        cell.layer.cornerRadius = 5

        return cell
    }
    
    func animate() {
        self.tableView.scrollToRowAtIndexPath(NSIndexPath(forItem: 2, inSection: 0), atScrollPosition: .Top, animated: false)
        UIView.animateWithDuration(0.5, delay: 0.0, options: UIViewAnimationOptions.CurveLinear, animations: { () -> Void in
            self.tableView.scrollToRowAtIndexPath(NSIndexPath(forItem: 0, inSection: 0), atScrollPosition: .Top, animated: false)
            }) { (finished) -> Void in
                self.animate()
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 10
    }
    
}
