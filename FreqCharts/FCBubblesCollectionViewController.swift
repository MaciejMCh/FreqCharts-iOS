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
        FCBubbleViewModel(radius: 65),
        FCBubbleViewModel(radius: 25),
        FCBubbleViewModel(radius: 40),
        FCBubbleViewModel(radius: 30),
        FCBubbleViewModel(radius: 15),
        FCBubbleViewModel(radius: 30),
        FCBubbleViewModel(radius: 40),
        FCBubbleViewModel(radius: 50),
        FCBubbleViewModel(radius: 20),
        FCBubbleViewModel(radius: 70),
        FCBubbleViewModel(radius: 35),
        FCBubbleViewModel(radius: 40),
        FCBubbleViewModel(radius: 45),
        FCBubbleViewModel(radius: 60),
        FCBubbleViewModel(radius: 100)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView!.registerClass(FCBubbleCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }

    // MARK: UICollectionViewDataSource

//    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 16
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> FCBubbleCollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! FCBubbleCollectionViewCell
    
        cell.backgroundColor = UIColor.whiteColor()
        // Configure the cell
    
        cell.layer.cornerRadius = CGFloat(self.viewModels[indexPath.row].radius)
        
        return cell
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
    
    }
    */

}
