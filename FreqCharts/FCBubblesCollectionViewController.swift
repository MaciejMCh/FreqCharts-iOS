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
    
    private var calculator = FCSymbolSizeCalculator()
    
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
        for cell in self.collectionView!.visibleCells() {
            cell.layer.removeAllAnimations()
        }
        
        for cell in self.collectionView!.visibleCells() {
            cell.transform = CGAffineTransformMakeScale(0, 0)
        }
        
        UIView.animateWithDuration(0.3) { () -> Void in
            for cell in self.collectionView!.visibleCells() {
                cell.transform = CGAffineTransformIdentity
            }
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
//        self.viewModels = [
//            FCBubbleViewModel(radius: 70, equation: self.equation),
//            FCBubbleViewModel(radius: 90, equation: self.equation),
//            FCBubbleViewModel(radius: 110, equation: self.equation),
//            ]
//
//        
//        self.calculator.calculateSizeOfEquation(self.equation) { (size) -> () in
//            self.dupa(self.equation, size: size)
////            self.equation.displayingSize = size
//            NSKeyedArchiver.archiveRootObject([self.equation.dictionaryValue()], toFile: self.storagePath())
//            NSLog(String(size))
//        }
        
        let array: [[String: AnyObject]] = NSKeyedUnarchiver.unarchiveObjectWithFile(self.storagePath()) as! [[String: AnyObject]]
        
        
        self.viewModels = [FCBubbleViewModel]()
        for dict in array {
            for index in 1...30 {
                self.viewModels.append(FCBubbleViewModel(equation: FCSymbolParser.parse(dict) as! FCEquation))
            }
        }
        
        self.collectionView!.registerClass(FCBubbleCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        (self.collectionViewLayout as! FCBubbleCollectionViewFlowLayout).passViewModels(self.viewModels)
        NSLog(String(self.collectionView!.collectionViewLayout.collectionViewContentSize()))
    }
    
    func dupa(eq: FCEquation, size: CGSize) {
        eq.displayingSize = size
        NSKeyedArchiver.archiveRootObject([eq.dictionaryValue()], toFile: self.storagePath())
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModels.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> FCBubbleCollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! FCBubbleCollectionViewCell
    
        cell.layer.cornerRadius = CGFloat(self.viewModels[indexPath.row].radius)
        cell.webView.loadHTMLString(self.viewModels[indexPath.row].equation.htmlRepresentation(), baseURL: nil)
        cell.widthConstraint.constant = self.viewModels[indexPath.row].equation.displayingSize!.width
        cell.heightConstraint.constant = self.viewModels[indexPath.row].equation.displayingSize!.height
        
        return cell
    }
    
    func storagePath() -> String {
        var storageDirectory = NSSearchPathForDirectoriesInDomains(.CachesDirectory, .UserDomainMask, true).last as String!
        storageDirectory = storageDirectory + "/models"
        return storageDirectory
    }
    
}
