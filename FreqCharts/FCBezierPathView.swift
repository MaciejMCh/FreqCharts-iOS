//
//  FCBezierPathView.swift
//  FreqCharts
//
//  Created by Maciej Chmielewski on 19.10.2015.
//  Copyright © 2015 maciejCh. All rights reserved.
//

import UIKit

class FCBezierPathView: UIView {
    
    private var points = [CGPoint]()
    private var axisRect: CGRect!
    
    func passPoints(points: [CGPoint]) {
        self.points = points
        self.normalizeToSize(CGSizeMake(100, 100))
    }
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        if (self.points.count == 0) {
            return
        }
        
        let context = UIGraphicsGetCurrentContext();
        
        CGContextSetStrokeColorWithColor(context, UIColor.blackColor().CGColor);
        CGContextSetLineWidth(context, 2.0)
        CGContextMoveToPoint(context, CGRectGetMinX(self.axisRect), CGRectGetMidY(self.axisRect))
        CGContextAddLineToPoint(context, CGRectGetMaxX(self.axisRect), CGRectGetMidY(self.axisRect))
        CGContextMoveToPoint(context, CGRectGetMidX(self.axisRect), CGRectGetMinY(self.axisRect))
        CGContextAddLineToPoint(context, CGRectGetMidX(self.axisRect), CGRectGetMaxY(self.axisRect))
        
        CGContextSetStrokeColorWithColor(context, UIColor.redColor().CGColor);
        CGContextSetLineWidth(context, 2.0)
        CGContextMoveToPoint(context, points.first!.x, points.first!.y)
        for point in self.points {
            CGContextAddLineToPoint(context, point.x, point.y);
        }
        
        CGContextStrokePath(context);
    }
    
    func normalizeToSize(size: CGSize) {
        if (self.points.count == 0) {
            return
        }
        
        let xSortedPoints = self.points.sort{ (first, second) -> Bool in
            return first.x < second.x
        }
        let ySortedPoints = self.points.sort{ (first, second) -> Bool in
            return first.y < second.y
        }
        
        let minX = xSortedPoints.first!.x
        let maxX = xSortedPoints.last!.x
        let minY = ySortedPoints.first!.y
        let maxY = ySortedPoints.last!.y
        
        let scaleX = max(((maxX - minX) / size.width), 0.00000000000001)
        let scaleY = max(((maxY - minY) / size.height), 0.00000000000001)
        
        self.points = self.points.map { (me) -> CGPoint in
            return CGPointMake(me.x - minX, me.y - minY)
        }
        self.points = self.points.map { (me) -> CGPoint in
            return CGPointMake(me.x / scaleX, me.y / scaleY)
        }
        
        self.axisRect = CGRectMake(0, 0, size.width, size.height)
    }

}
