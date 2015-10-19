//
//  FCBubblesCollectionViewController.swift
//  FreqCharts
//
//  Created by Maciej Chmielewski on 12.10.2015.
//  Copyright © 2015 maciejCh. All rights reserved.
//

import UIKit

private let reuseIdentifier = "FCBubbleCollectionViewCell"

class FCBubblesCollectionViewController: UICollectionViewController {

    var menuIsShowing = false
    private var selectedCell: FCBubbleCollectionViewCell!
    
    private var equation: FCEquation {
        let frac = FCFractionSymbol(overSymbol: FCNumberSymbol(value: 10), underSymbol: FCAddSymbol(LHSSymbol: FCOperatorSymbol(), RHSSymbol: FCNumberSymbol(value: 1000)))
        let par = FCParenthesesSymbol(childSymbol: frac)
        let mainEquation = FCEquation(mainSymbol: par, font: UIFont())
        return mainEquation
    }
    
    private var viewModels: [FCBubbleViewModel]!
    
    func exitAnimation() {
        for cell in self.collectionView!.visibleCells() {
            let animation = CABasicAnimation(keyPath: "transform.scale")
            animation.toValue = NSValue(CATransform3D: CATransform3DMakeScale(0, 0, 1))
            animation.duration = 0.5
            animation.fillMode = kCAFillModeForwards
            animation.timingFunction = CAMediaTimingFunction(controlPoints: 0.1, 1, 0.1, 1)
            animation.removedOnCompletion = false
            cell.layer.addAnimation(animation, forKey: "explode bubble")
        }
    }
    
    func backAnimation() {
        self.collectionView?.reloadData()
        self.collectionView!.alpha = 0.0
        UIView.animateWithDuration(0.3) { () -> Void in
            self.collectionView!.alpha = 1.0
        }
    }
    
    func enterAnimation() {
        self.collectionView!.alpha = 0.0
        self.update()
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            UIView.animateWithDuration(0.3) { () -> Void in
                self.collectionView!.alpha = 1.0
            }
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView!.registerClass(FCBubbleCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        self.update()
    }
    
    func update() {
        self.viewModels = [FCBubbleViewModel]()
        for equation in FCEquationsDataSource().equations() {
            self.viewModels.append(FCBubbleViewModel(equation: equation))
        }
        
        self.collectionView?.reloadData()
        (self.collectionViewLayout as! FCBubbleCollectionViewFlowLayout).passViewModels(self.viewModels)
        
        let foam = (self.collectionViewLayout as! FCBubbleCollectionViewFlowLayout).foam
        let topInset = max(0, (CGRectGetHeight(self.collectionView!.frame) - foam.size.height) / 2)
        let leftInset = max(0, (CGRectGetWidth(self.collectionView!.frame) - foam.size.width) / 2)
        self.collectionView!.contentInset = UIEdgeInsetsMake(topInset, leftInset, 0, 0)
        
        let topOffset = max(0, (foam.size.height - CGRectGetHeight(UIScreen.mainScreen().bounds)) / 2)
        let leftOffset = max(0, (foam.size.width - CGRectGetWidth(UIScreen.mainScreen().bounds)) / 2)
        self.collectionView?.contentOffset = CGPointMake(leftOffset, leftOffset)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let foam = (self.collectionViewLayout as! FCBubbleCollectionViewFlowLayout).foam
        let topOffset = max(0, (foam.size.height - CGRectGetHeight(UIScreen.mainScreen().bounds)) / 2)
        let leftOffset = max(0, (foam.size.width - CGRectGetWidth(UIScreen.mainScreen().bounds)) / 2)
        self.collectionView?.contentOffset = CGPointMake(leftOffset, leftOffset)
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModels.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> FCBubbleCollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! FCBubbleCollectionViewCell
    
        cell.layer.cornerRadius = CGFloat(self.viewModels[indexPath.row].radius)
        cell.equationView.equation = self.viewModels[indexPath.row].equation
        cell.equationView.update()
        
        cell.widthConstraint.constant = self.viewModels[indexPath.row].equation.displayingSize!.width
        cell.heightConstraint.constant = self.viewModels[indexPath.row].equation.displayingSize!.height
        
        return cell
    }
    
    func deleteSelected() {
        (self.parentViewController as! FCFABViewController).showMenu(false)
        self.menuIsShowing = false
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.selectedCell.transform = CGAffineTransformMakeScale(0.0001, 0.0001)
            }) { (finished) -> Void in
                FCEquationsDataSource().removeEquation(self.selectedCell.equationView.equation)
                self.update()
        }
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        self.menuIsShowing = !self.menuIsShowing
        
        let transform = self.menuIsShowing ? CGAffineTransformMakeScale(0.0001, 0.0001) : CGAffineTransformIdentity
        let selectedCell = collectionView.cellForItemAtIndexPath(indexPath)
        self.selectedCell = selectedCell as! FCBubbleCollectionViewCell
        UIView.animateWithDuration(0.3) { () -> Void in
            for cell in self.collectionView!.visibleCells() {
                if (cell == selectedCell) {
                    continue
                }
                cell.transform = transform
            }
        }
        
        (self.parentViewController as! FCFABViewController).showMenu(self.menuIsShowing)
    }
    
    
}
