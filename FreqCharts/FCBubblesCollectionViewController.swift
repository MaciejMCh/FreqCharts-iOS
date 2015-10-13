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
        FCBubbleViewModel(radius: 40),
        FCBubbleViewModel(radius: 60),
        FCBubbleViewModel(radius: 50),
        FCBubbleViewModel(radius: 20),
        FCBubbleViewModel(radius: 80),
        FCBubbleViewModel(radius: 50),
        FCBubbleViewModel(radius: 40),
        FCBubbleViewModel(radius: 90),
        FCBubbleViewModel(radius: 60),
        FCBubbleViewModel(radius: 50),
        FCBubbleViewModel(radius: 40),
        FCBubbleViewModel(radius: 60),
        FCBubbleViewModel(radius: 50),
        FCBubbleViewModel(radius: 20),
        FCBubbleViewModel(radius: 80),
        FCBubbleViewModel(radius: 50),
        FCBubbleViewModel(radius: 40),
        FCBubbleViewModel(radius: 90),
        FCBubbleViewModel(radius: 60),
        FCBubbleViewModel(radius: 50),
        FCBubbleViewModel(radius: 40),
        FCBubbleViewModel(radius: 60),
        FCBubbleViewModel(radius: 50),
        FCBubbleViewModel(radius: 20),
        FCBubbleViewModel(radius: 80),
        FCBubbleViewModel(radius: 50),
        FCBubbleViewModel(radius: 40),
        FCBubbleViewModel(radius: 90),
        FCBubbleViewModel(radius: 60),
        FCBubbleViewModel(radius: 50),
        FCBubbleViewModel(radius: 40),
        
        
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
    
        cell.backgroundColor = UIColor.whiteColor()
        // Configure the cell
    
        cell.layer.cornerRadius = CGFloat(self.viewModels[indexPath.row].radius)
        
        return cell
    }
    
}
