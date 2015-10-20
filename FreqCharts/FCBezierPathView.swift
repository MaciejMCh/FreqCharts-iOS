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
    private var axisPoint: CGPoint!
    private var visibleSize = CGSizeMake(100, 100)
    
    func passPoints(points: [CGPoint]) {
        self.points = points
        self.normalizeToSize(self.visibleSize)
    }
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        if (self.points.count == 0) {
            return
        }
        
        let context = UIGraphicsGetCurrentContext();
        
        let xCenter = (rect.width / 2) - (self.visibleSize.width / 2)
        let yCenter = (rect.height / 2) - (self.visibleSize.height / 2)
        let axisOffset = CGFloat(20)
        
        CGContextSetStrokeColorWithColor(context, UIColor.blackColor().CGColor);
        CGContextSetLineWidth(context, 1.0)
        CGContextMoveToPoint(context, (rect.width / 2) - (self.visibleSize.width / 2) - axisOffset, self.axisPoint.y + yCenter)
        CGContextAddLineToPoint(context, (rect.width / 2) + (self.visibleSize.width / 2) + axisOffset, self.axisPoint.y + yCenter)
        
        CGContextMoveToPoint(context, self.axisPoint.x + xCenter, (rect.height / 2) - (self.visibleSize.height / 2) - axisOffset)
        CGContextAddLineToPoint(context, self.axisPoint.x + xCenter, (rect.height / 2) + (self.visibleSize.height / 2) + axisOffset)
        
        CGContextSetStrokeColorWithColor(context, UIColor.redColor().CGColor);
        CGContextSetLineWidth(context, 2.0)
        CGContextMoveToPoint(context, points.first!.x + xCenter, points.first!.y + yCenter)
        for point in self.points {
            CGContextAddLineToPoint(context, point.x + xCenter, point.y + yCenter);
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
        
        self.axisPoint = CGPointZero
        self.axisPoint.x -= minX / scaleX
        self.axisPoint.y -= minY / scaleY
        self.points = self.points.map { (me) -> CGPoint in
            return CGPointMake(me.x / scaleX, me.y / scaleY)
        }
        
        
    }

}
