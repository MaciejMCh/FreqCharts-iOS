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

    
    private var viewModels: [FCBubbleViewModel] = [
        FCBubbleViewModel(radius: 50),
        FCBubbleViewModel(radius: 50),
        FCBubbleViewModel(radius: 50),
        FCBubbleViewModel(radius: 50),
        FCBubbleViewModel(radius: 50),
        FCBubbleViewModel(radius: 50),
        FCBubbleViewModel(radius: 50),
        FCBubbleViewModel(radius: 50),
        FCBubbleViewModel(radius: 50),
        FCBubbleViewModel(radius: 50),
    ]
    
    private var colors: [UIColor] = [
        UIColor(white: 1.0, alpha: 1.0),
        UIColor(white: 1.0, alpha: 0.9),
        UIColor(white: 1.0, alpha: 0.8),
        UIColor(white: 1.0, alpha: 0.7),
        UIColor(white: 1.0, alpha: 0.6),
        UIColor(white: 1.0, alpha: 0.5),
        UIColor(white: 1.0, alpha: 0.4),
        UIColor(white: 1.0, alpha: 0.3),
        UIColor(white: 1.0, alpha: 0.2),
        UIColor(white: 1.0, alpha: 0.1),
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView!.registerClass(FCBubbleCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        (self.collectionViewLayout as! FCBubbleCollectionViewFlowLayout).viewModels = self.viewModels
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return self.viewModels.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> FCBubbleCollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! FCBubbleCollectionViewCell
    
        cell.backgroundColor = self.colors[indexPath.row]
        // Configure the cell
    
        cell.layer.cornerRadius = CGFloat(self.viewModels[indexPath.row].radius)
        
        return cell
    }
    
}
