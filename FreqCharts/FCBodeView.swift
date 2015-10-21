//
//  FCBodeView.swift
//  FreqCharts
//
//  Created by Maciej Chmielewski on 21.10.2015.
//  Copyright © 2015 maciejCh. All rights reserved.
//

import UIKit

class FCPhaseView: UIView {
    
    private var points = [CGPoint]()
    private var axisPoint: CGPoint!
    private var visibleSize = CGSizeMake(200, 200)
    
    func passPoints(points: [CGPoint]) {
        self.points = points
        self.validate()
        self.normalizeToSize(self.visibleSize)
        self.trim()
        self.normalizeToSize(self.visibleSize)
    }
    
    func trim() {
        typealias DynamicPoint = (point: CGPoint, diff: CGFloat)
        
        var dynamicPoints = [DynamicPoint]()
        for point in self.points {
            if points.first == point {
                continue
            }
            
            let prevIndex = points.indexOf(point)! - 1
            let prevPoint = points[prevIndex]
            dynamicPoints.append(DynamicPoint(point, point.y - prevPoint.y))
        }
        dynamicPoints.insert(DynamicPoint(points.first!, dynamicPoints.first!.diff), atIndex: 0)
        
        NSLog(String(dynamicPoints.count))
        
        dynamicPoints = dynamicPoints.filter({ (me) -> Bool in
            return abs(me.diff) > pow(10, -4)
        })
        
        NSLog(String(dynamicPoints.count))
        
        self.points = dynamicPoints.map({ (me) -> CGPoint in
            return me.point
        })
    }
    
    func validate() {
        self.points = self.points.filter({ (point) -> Bool in
            return point.x.isFinite && point.y.isFinite
        })
    }
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        if (self.points.count == 0) {
            return
        }
        
        let axisContext = UIGraphicsGetCurrentContext();
        
        let xCenter = (rect.width / 2) - (self.visibleSize.width / 2)
        let yCenter = (rect.height / 2) - (self.visibleSize.height / 2)
        let axisOffset = CGFloat(20)
        
        CGContextSetStrokeColorWithColor(axisContext, UIColor.blackColor().CGColor);
        CGContextSetLineWidth(axisContext, 1.0)
        CGContextMoveToPoint(axisContext, (rect.width / 2) - (self.visibleSize.width / 2) - axisOffset, self.axisPoint.y + yCenter)
        CGContextAddLineToPoint(axisContext, (rect.width / 2) + (self.visibleSize.width / 2) + axisOffset, self.axisPoint.y + yCenter)
        CGContextMoveToPoint(axisContext, self.axisPoint.x + xCenter, (rect.height / 2) - (self.visibleSize.height / 2) - axisOffset)
        CGContextAddLineToPoint(axisContext, self.axisPoint.x + xCenter, (rect.height / 2) + (self.visibleSize.height / 2) + axisOffset)
        CGContextStrokePath(axisContext)
        
        UIGraphicsPushContext(axisContext!)
        
        let curveContext = UIGraphicsGetCurrentContext()
        CGContextSetStrokeColorWithColor(curveContext, UIColor.redColor().CGColor);
        CGContextSetLineWidth(curveContext, 2.0)
        CGContextMoveToPoint(curveContext, points.first!.x + xCenter, points.first!.y + yCenter)
        for point in self.points {
            CGContextAddLineToPoint(curveContext, point.x + xCenter, point.y + yCenter);
        }
        CGContextStrokePath(curveContext)
        
        UIGraphicsPushContext(curveContext!)
        
        let axisArrowContext = UIGraphicsGetCurrentContext()
        
        CGContextSetRGBStrokeColor(axisArrowContext, 0.0, 0.0, 0.0, 1.0);
        CGContextSetRGBFillColor(axisArrowContext, 0.0, 0.0, 0.0, 1.0);
        CGContextSetLineJoin(axisArrowContext, CGLineJoin.Round);
        CGContextSetLineWidth(axisArrowContext, 1.0);
        
        let pathRef = CGPathCreateMutable();
        let arrowSize = CGFloat(10)
        
        CGPathMoveToPoint(pathRef, nil, self.axisPoint.x + xCenter, (rect.height / 2) - (self.visibleSize.height / 2) - axisOffset)
        CGPathAddLineToPoint(pathRef, nil, self.axisPoint.x + xCenter - (arrowSize / 3), (rect.height / 2) - (self.visibleSize.height / 2) - axisOffset + arrowSize)
        CGPathAddLineToPoint(pathRef, nil, self.axisPoint.x + xCenter + (arrowSize / 3), (rect.height / 2) - (self.visibleSize.height / 2) - axisOffset + arrowSize)
        CGPathCloseSubpath(pathRef);
        CGPathMoveToPoint(pathRef, nil, (rect.width / 2) + (self.visibleSize.width / 2) + axisOffset, self.axisPoint.y + yCenter)
        CGPathAddLineToPoint(pathRef, nil, (rect.width / 2) + (self.visibleSize.width / 2) + axisOffset - arrowSize, self.axisPoint.y + yCenter + (arrowSize / 3))
        CGPathAddLineToPoint(pathRef, nil, (rect.width / 2) + (self.visibleSize.width / 2) + axisOffset - arrowSize, self.axisPoint.y + yCenter - (arrowSize / 3))
        CGPathCloseSubpath(pathRef);
        CGContextAddPath(axisArrowContext, pathRef);
        CGContextFillPath(axisArrowContext);
        
        UIGraphicsPushContext(axisArrowContext!)
        
    }
    
    func normalizeToSize(size: CGSize) {
        if (self.points.count == 0) {
            return
        }
        
        var xSortedPoints = self.points.sort{ (first, second) -> Bool in
            return first.x < second.x
        }
        var ySortedPoints = self.points.sort{ (first, second) -> Bool in
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
        self.axisPoint.x = 0
        self.axisPoint.y = self.visibleSize.height / 2
        self.points = self.points.map { (me) -> CGPoint in
            return CGPointMake(me.x / scaleX, me.y / scaleY)
        }
        
        
    }
    
}


class FCBodeView: UIView {
    
    private var points = [CGPoint]()
    private var axisPoint: CGPoint!
    private var visibleSize = CGSizeMake(200, 200)
    
    func passPoints(points: [CGPoint]) {
        self.points = points
        self.validate()
        self.normalizeToSize(self.visibleSize)
        self.trim()
        self.normalizeToSize(self.visibleSize)
    }
    
    func trim() {
        typealias DynamicPoint = (point: CGPoint, diff: CGFloat)
        
        var dynamicPoints = [DynamicPoint]()
        for point in self.points {
            if points.first == point {
                continue
            }
            
            let prevIndex = points.indexOf(point)! - 1
            let prevPoint = points[prevIndex]
            dynamicPoints.append(DynamicPoint(point, point.y - prevPoint.y))
        }
        dynamicPoints.insert(DynamicPoint(points.first!, dynamicPoints.first!.diff), atIndex: 0)
        
        NSLog(String(dynamicPoints.count))
        
        dynamicPoints = dynamicPoints.filter({ (me) -> Bool in
            return abs(me.diff) > pow(10, -4)
        })
        
        NSLog(String(dynamicPoints.count))
        
        self.points = dynamicPoints.map({ (me) -> CGPoint in
            return me.point
        })
    }
    
    func validate() {
        self.points = self.points.filter({ (point) -> Bool in
            return point.x.isFinite && point.y.isFinite
        })
    }
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        if (self.points.count == 0) {
            return
        }
        
        let axisContext = UIGraphicsGetCurrentContext();
        
        let xCenter = (rect.width / 2) - (self.visibleSize.width / 2)
        let yCenter = (rect.height / 2) - (self.visibleSize.height / 2)
        let axisOffset = CGFloat(20)
        
        CGContextSetStrokeColorWithColor(axisContext, UIColor.blackColor().CGColor);
        CGContextSetLineWidth(axisContext, 1.0)
        CGContextMoveToPoint(axisContext, (rect.width / 2) - (self.visibleSize.width / 2) - axisOffset, self.axisPoint.y + yCenter)
        CGContextAddLineToPoint(axisContext, (rect.width / 2) + (self.visibleSize.width / 2) + axisOffset, self.axisPoint.y + yCenter)
        CGContextMoveToPoint(axisContext, self.axisPoint.x + xCenter, (rect.height / 2) - (self.visibleSize.height / 2) - axisOffset)
        CGContextAddLineToPoint(axisContext, self.axisPoint.x + xCenter, (rect.height / 2) + (self.visibleSize.height / 2) + axisOffset)
        CGContextStrokePath(axisContext)
        
        UIGraphicsPushContext(axisContext!)
        
        let curveContext = UIGraphicsGetCurrentContext()
        CGContextSetStrokeColorWithColor(curveContext, UIColor.redColor().CGColor);
        CGContextSetLineWidth(curveContext, 2.0)
        CGContextMoveToPoint(curveContext, points.first!.x + xCenter, points.first!.y + yCenter)
        for point in self.points {
            CGContextAddLineToPoint(curveContext, point.x + xCenter, point.y + yCenter);
        }
        CGContextStrokePath(curveContext)
        
        UIGraphicsPushContext(curveContext!)
        
        let axisArrowContext = UIGraphicsGetCurrentContext()
        
        CGContextSetRGBStrokeColor(axisArrowContext, 0.0, 0.0, 0.0, 1.0);
        CGContextSetRGBFillColor(axisArrowContext, 0.0, 0.0, 0.0, 1.0);
        CGContextSetLineJoin(axisArrowContext, CGLineJoin.Round);
        CGContextSetLineWidth(axisArrowContext, 1.0);
        
        let pathRef = CGPathCreateMutable();
        let arrowSize = CGFloat(10)
        
        CGPathMoveToPoint(pathRef, nil, self.axisPoint.x + xCenter, (rect.height / 2) - (self.visibleSize.height / 2) - axisOffset)
        CGPathAddLineToPoint(pathRef, nil, self.axisPoint.x + xCenter - (arrowSize / 3), (rect.height / 2) - (self.visibleSize.height / 2) - axisOffset + arrowSize)
        CGPathAddLineToPoint(pathRef, nil, self.axisPoint.x + xCenter + (arrowSize / 3), (rect.height / 2) - (self.visibleSize.height / 2) - axisOffset + arrowSize)
        CGPathCloseSubpath(pathRef);
        CGPathMoveToPoint(pathRef, nil, (rect.width / 2) + (self.visibleSize.width / 2) + axisOffset, self.axisPoint.y + yCenter)
        CGPathAddLineToPoint(pathRef, nil, (rect.width / 2) + (self.visibleSize.width / 2) + axisOffset - arrowSize, self.axisPoint.y + yCenter + (arrowSize / 3))
        CGPathAddLineToPoint(pathRef, nil, (rect.width / 2) + (self.visibleSize.width / 2) + axisOffset - arrowSize, self.axisPoint.y + yCenter - (arrowSize / 3))
        CGPathCloseSubpath(pathRef);
        CGContextAddPath(axisArrowContext, pathRef);
        CGContextFillPath(axisArrowContext);
        
        UIGraphicsPushContext(axisArrowContext!)
        
    }
    
    func normalizeToSize(size: CGSize) {
        if (self.points.count == 0) {
            return
        }
        
        var xSortedPoints = self.points.sort{ (first, second) -> Bool in
            return first.x < second.x
        }
        var ySortedPoints = self.points.sort{ (first, second) -> Bool in
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
        self.axisPoint.x = 0
        self.axisPoint.y = self.visibleSize.height / 2
        self.points = self.points.map { (me) -> CGPoint in
            return CGPointMake(me.x / scaleX, me.y / scaleY)
        }
        
        
    }
    
}
