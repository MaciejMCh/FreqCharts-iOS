//
//  KPBubbleCollectionViewFlowLayout.swift
//  FreqCharts
//
//  Created by Maciej Chmielewski on 12.10.2015.
//  Copyright © 2015 maciejCh. All rights reserved.
//

import UIKit

class FCBubbleCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    private var cache = [UICollectionViewLayoutAttributes]()
    
    private var viewModels: [FCBubbleViewModel] = [
        FCBubbleViewModel(radius: 100),
        FCBubbleViewModel(radius: 130),
        FCBubbleViewModel(radius: 50),
        FCBubbleViewModel(radius: 80),
        FCBubbleViewModel(radius: 60),
        FCBubbleViewModel(radius: 30),
        FCBubbleViewModel(radius: 60),
        FCBubbleViewModel(radius: 80),
        FCBubbleViewModel(radius: 100),
        FCBubbleViewModel(radius: 40),
        FCBubbleViewModel(radius: 140),
        FCBubbleViewModel(radius: 70),
        FCBubbleViewModel(radius: 80),
        FCBubbleViewModel(radius: 90),
        FCBubbleViewModel(radius: 120),
        FCBubbleViewModel(radius: 200)
    ]
    
    override func prepareLayout() {
        
        var index = 0
        for viewModel in self.viewModels {
            
            let indexPath = NSIndexPath(forItem: index, inSection: 0)
            let attributes = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
            attributes.frame = self.finalBubbleFrame(indexPath.row)
            cache.append(attributes)
            
            index += 1
        }
        
//        if cache.isEmpty {
//            
//            for item in 0 ..< collectionView!.numberOfItemsInSection(0) {
//                
//                let indexPath = NSIndexPath(forItem: item, inSection: 0)
//                
//                // 5
//                let attributes = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
//                attributes.frame = self.finalBubbleFrame(indexPath.row)
//                cache.append(attributes)
//                
//            }
//        }
    }
    
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        var layoutAttributes = [UICollectionViewLayoutAttributes]()
        
        for attributes in cache {
            if CGRectIntersectsRect(attributes.frame, rect) {
                layoutAttributes.append(attributes)
            }
        }
        return layoutAttributes
    }
    
    
    func finalBubbleFrame(index: NSInteger) -> CGRect {
        let spacing: CGFloat = 10
        let radius = CGFloat(viewModels[index].radius)
        
//        NSLog(String(index) + " " + String(radius))
        
        if (index == 0) {
            var origin = CGPointMake(CGRectGetMidX(self.collectionView!.bounds), CGRectGetMidY(self.collectionView!.bounds))
            origin.x -= radius / 2
            origin.y -= radius / 2
            return CGRectMake(origin.x, origin.y, radius, radius)
        } else if (index == 1) {
            let firstFrame = self.finalBubbleFrame(0)
            var origin = CGPointMake(CGRectGetMinX(firstFrame), CGRectGetMinY(firstFrame))
            origin.y -= radius + spacing
            origin.x += (CGRectGetWidth(firstFrame) - radius) / 2
    
            viewModels[0].connect(viewModels[1])
            
            return CGRectMake(origin.x, origin.y, radius, radius)
        }
        
        else if (index == 2) {
        
        for firstBubble in self.viewModels {
            for secondBubble in self.viewModels {
                if (firstBubble == secondBubble) {
                    continue
                }
                
                if (firstBubble.isConnected(secondBubble)) {
                    let firstMid = CGPointMake(CGRectGetMidX(self.finalBubbleFrame(self.viewModels.indexOf(firstBubble)!)), CGRectGetMidY(self.finalBubbleFrame(self.viewModels.indexOf(firstBubble)!)))
                    let secondMid = CGPointMake(CGRectGetMidX(self.finalBubbleFrame(self.viewModels.indexOf(secondBubble)!)), CGRectGetMidY(self.finalBubbleFrame(self.viewModels.indexOf(secondBubble)!)))
                    let firstRadius = CGFloat(firstBubble.radius)
                    let secondRadius = CGFloat(secondBubble.radius)
                    
                    var circle1 = Circle(cx: Float(firstMid.x), cy: Float(firstMid.y), cr: Float(firstRadius + radius + spacing))
                    var circle2 = Circle(cx: Float(secondMid.x), cy: Float(secondMid.y), cr: Float(secondRadius + radius + spacing))
                    
                    let intersecitons = circle1.intersections(circle2)
                    let intersection = intersecitons[1];
                    
                    
                    
                    NSLog(String(intersection.x) + " " + String(intersection.y))
                    var rect: CGRect =  CGRectMake(CGFloat(intersecitons[1].x) - (radius / 2), CGFloat(intersecitons[1].y) - (radius / 2), radius, radius)
                    rect = CGRectMake(CGFloat(intersecitons[1].x) - radius, CGFloat(intersecitons[1].y) - radius, radius, radius)
                    NSLog(String(rect))
                    
                    
                    return rect
                    
                } else {
                    continue
                }
                
            }
        }
            
        }
        
        return CGRectZero
    }
    
    func vectorLength(point: CGPoint) -> CGFloat {
        return CGFloat(hypotf(Float(point.x), Float(point.y)))
    }

}

class Point{
    var x, y: Float!
    
    init(px: Float, py: Float) {
        x = px;
        y = py;
    }
    
    func sub(p2: Point) -> Point {
        return Point(px: x - p2.x, py: y - p2.y);
    }
    
    func add(p2: Point) -> Point {
        return Point(px: x + p2.x, py: y + p2.y);
    }
    
    func distance(p2: Point) -> Float {
        return sqrt((x - p2.x)*(x - p2.x) + (y - p2.y)*(y - p2.y));
    }
    
    func normal() -> Point {
        let length = sqrt(x*x + y*y);
        return Point(px: x/length, py: y/length);
    }
    
    func scale(s: Float) -> Point {
    return Point(px: x*s, py: y*s);
    }   
}

class Circle {
    var x, y, r, left: Float;
    
    init(cx: Float,cy: Float, cr: Float) {
        x = cx;
        y = cy;
        r = cr;
        left = x - r;
    }
    
    func intersections(c: Circle) -> [Point] {
        let P0 = Point(px: x, py: y);
        let P1 = Point(px: c.x, py: c.y);
        let d = P0.distance(P1);
        let a = (r*r - c.r*c.r + d*d)/(2*d);
        let h = sqrt(r*r - a*a);
        let P2 = P1.sub(P0).scale(a/d).add(P0);
        let x3 = P2.x + h*(P1.y - P0.y)/d;
        let y3 = P2.y - h*(P1.x - P0.x)/d;
        let x4 = P2.x - h*(P1.y - P0.y)/d;
        let y4 = P2.y + h*(P1.x - P0.x)/d;
        return [Point(px: x3, py: y3), Point(px: x4, py: y4)]
    }
    
}


