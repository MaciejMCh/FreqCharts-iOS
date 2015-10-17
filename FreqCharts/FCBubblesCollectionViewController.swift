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
    
    func enterAnimation() {
        self.viewModels = [FCBubbleViewModel]()
        for equation in FCEquationsDataSource().equations() {
            self.viewModels.append(FCBubbleViewModel(equation: equation))
        }
        self.collectionView?.reloadData()
        (self.collectionViewLayout as! FCBubbleCollectionViewFlowLayout).passViewModels(self.viewModels)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView!.registerClass(FCBubbleCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        self.viewModels = [FCBubbleViewModel]()
        for equation in FCEquationsDataSource().equations() {
            self.viewModels.append(FCBubbleViewModel(equation: equation))
        }
        (self.collectionViewLayout as! FCBubbleCollectionViewFlowLayout).passViewModels(self.viewModels)
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
    
}
