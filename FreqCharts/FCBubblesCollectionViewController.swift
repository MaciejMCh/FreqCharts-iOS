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
        let mainEquation = FCEquation(mainSymbol: par, font: UIFont.systemFontOfSize(16, weight: UIFontWeightLight))
        return mainEquation
    }
    
    private var viewModels: [FCBubbleViewModel]!// = [
//        FCBubbleViewModel(radius: 70, equation: self.equation),
//        FCBubbleViewModel(radius: 90, equation: self.equation),
//        FCBubbleViewModel(radius: 110, equation: self.equation),
//        FCBubbleViewModel(radius: 50),
//        FCBubbleViewModel(radius: 20),
//        FCBubbleViewModel(radius: 80),
//        FCBubbleViewModel(radius: 50),
//        FCBubbleViewModel(radius: 40),
//        FCBubbleViewModel(radius: 90),
//        FCBubbleViewModel(radius: 60),
//        FCBubbleViewModel(radius: 50),
//        FCBubbleViewModel(radius: 40),
//        FCBubbleViewModel(radius: 60),
//        FCBubbleViewModel(radius: 50),
//        FCBubbleViewModel(radius: 20),
//        FCBubbleViewModel(radius: 80),
//        FCBubbleViewModel(radius: 50),
//        FCBubbleViewModel(radius: 40),
//        FCBubbleViewModel(radius: 90),
//        FCBubbleViewModel(radius: 60),
//        FCBubbleViewModel(radius: 50),
//        FCBubbleViewModel(radius: 40),
//        FCBubbleViewModel(radius: 60),
//        FCBubbleViewModel(radius: 50),
//        FCBubbleViewModel(radius: 20),
//        FCBubbleViewModel(radius: 80),
//        FCBubbleViewModel(radius: 50),
//        FCBubbleViewModel(radius: 40),
//        FCBubbleViewModel(radius: 90),
//        FCBubbleViewModel(radius: 60),
//        FCBubbleViewModel(radius: 50),
//        FCBubbleViewModel(radius: 40),
//    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.viewModels = [
            FCBubbleViewModel(radius: 70, equation: self.equation),
            FCBubbleViewModel(radius: 90, equation: self.equation),
            FCBubbleViewModel(radius: 110, equation: self.equation),
            ]
        
//        NSKeyedArchiver.archiveRootObject(self.viewModels, toFile: self.storagePath())
        
        let dict = self.equation.dictionaryValue()
//        let eq = FCEquation(dictionary: dict)
        let eq = FCSymbolParser.parse(dict)
        
    
        self.collectionView!.registerClass(FCBubbleCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        (self.collectionViewLayout as! FCBubbleCollectionViewFlowLayout).passViewModels(self.viewModels)
        NSLog(String(self.collectionView!.collectionViewLayout.collectionViewContentSize()))
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModels.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> FCBubbleCollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! FCBubbleCollectionViewCell
    
        cell.layer.cornerRadius = CGFloat(self.viewModels[indexPath.row].radius)
        cell.webView.loadHTMLString(self.viewModels[indexPath.row].equation.htmlRepresentation(), baseURL: nil)
        
        return cell
    }
    
    func storagePath() -> String {
        var storageDirectory = NSSearchPathForDirectoriesInDomains(.CachesDirectory, .UserDomainMask, true).last as String!
        storageDirectory = storageDirectory + "/models"
        return storageDirectory
    }
    
}
