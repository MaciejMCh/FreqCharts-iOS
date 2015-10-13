//
//  KPBubbleCollectionViewFlowLayout.swift
//  FreqCharts
//
//  Created by Maciej Chmielewski on 12.10.2015.
//  Copyright © 2015 maciejCh. All rights reserved.
//

import UIKit

class FCBubbleCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    private var attributesCache = [UICollectionViewLayoutAttributes]()
    
    private var calculatedCircles:[Circle] = [Circle]()
    private var notCalculatedCircles:[Circle] = [Circle]()
    private var foam: Foam = Foam()
    
    var viewModels: [FCBubbleViewModel] = [FCBubbleViewModel]()
    
    override func prepareLayout() {
        self.notCalculatedCircles = [Circle]()
        for viewModel in self.viewModels {
            self.notCalculatedCircles.append(Circle(cr: CGFloat(viewModel.radius)))
        }
        self.calculateCache()
    }
    
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var layoutAttributes = [UICollectionViewLayoutAttributes]()
        for attributes in attributesCache {
            if CGRectIntersectsRect(attributes.frame, rect) {
                if (attributes.indexPath.row > self.viewModels.count) {
                    continue
                }
                layoutAttributes.append(attributes)
            }
        }
        return layoutAttributes
    }
    
    override func collectionViewContentSize() -> CGSize {
        return self.foam.size
    }
    
    func calculateCache() {
        self.calculatedCircles = [Circle]()
        for circle in self.notCalculatedCircles {
            self.calculateCirclePosition(circle)
        }
        
        self.foam = Foam(circles: self.calculatedCircles)
        
        self.attributesCache = [UICollectionViewLayoutAttributes]()
        for circle in self.calculatedCircles {
            let layoutAttributes = UICollectionViewLayoutAttributes(forCellWithIndexPath: NSIndexPath(forItem: self.calculatedCircles.indexOf(circle)!, inSection: 0))
            layoutAttributes.frame = circle.frame()
            self.attributesCache.append(layoutAttributes)
        }
    }
    
    func calculateCirclePosition(circle: Circle) {
        let spacing: CGFloat = 10
        
        // First circle in the middle
        if (self.calculatedCircles.count == 0) {
            let screenCenterPoint = CGPointZero
            circle.x = screenCenterPoint.x
            circle.y = screenCenterPoint.y
            self.calculatedCircles.append(circle)
            return
        }
        
        // Second circle above first
        if (self.calculatedCircles.count == 1) {
            circle.x = self.calculatedCircles[0].x
            circle.y = self.calculatedCircles[0].y - self.calculatedCircles[0].r - circle.r - spacing
            
            circle.connect(self.calculatedCircles[0])
            self.calculatedCircles.append(circle)
            return
        }
        
        // Next are calculated
        var possibilities: [Circle] = [Circle]()
        
        // Iterate through circle pairs
        for firstCircle in self.calculatedCircles {
            for secondCircle in self.calculatedCircles {
                // Dont check same circles
                if (firstCircle == secondCircle) {
                    continue
                }
                
                // Dont check if not connected circles
                if (!firstCircle.isConnected(secondCircle)) {
                    continue
                }
                
                // Calculate intersections
                let extendedFirstCircle = Circle(cx: firstCircle.x, cy: firstCircle.y, cr: firstCircle.r + spacing + circle.r)
                let extendedSecondCircle = Circle(cx: secondCircle.x, cy: secondCircle.y, cr: secondCircle.r + spacing + circle.r)
                
                var intersections = extendedFirstCircle.intersections(extendedSecondCircle)
                
                // Chose one possible circle
                let firstPosibility = Circle(cx: intersections[0].x, cy: intersections[0].y, cr: circle.r)
                firstPosibility.connect(firstCircle)
                let secondPossibility = Circle(cx: intersections[1].x, cy: intersections[1].y, cr: circle.r)
                secondPossibility.connect(firstCircle)
                
                possibilities.append(firstPosibility)
                possibilities.append(secondPossibility)
            }
        }
        
        let validPossibilities = possibilities.filter{self.isCircleValid($0)}
        
        let screenCenterPoint = Point(px: 0, py: 0)
        let sortedPossibilities = validPossibilities.sort { (first, second) -> Bool in
            return Point(px: screenCenterPoint.x, py: screenCenterPoint.y).distance(Point(px: first.x, py: first.y)) < Point(px: screenCenterPoint.x, py: screenCenterPoint.y).distance(Point(px: second.x, py: second.y))
        }
        
        let chosencircle = sortedPossibilities[0]
        
        circle.x = chosencircle.x
        circle.y = chosencircle.y
        circle.connections = chosencircle.connections
        self.calculatedCircles.append(circle)
        
        
    }
    
    func isCircleValid(circle: Circle) -> Bool {
        for iteratingCircle in self.calculatedCircles {
            if (iteratingCircle.intersects(circle)) {
                return false
            }
        }
        return true
    }
    
}

class Point {
    var x, y: CGFloat!
    
    init(px: CGFloat, py: CGFloat) {
        x = px;
        y = py;
    }
    
    func sub(p2: Point) -> Point {
        return Point(px: x - p2.x, py: y - p2.y);
    }
    
    func add(p2: Point) -> Point {
        return Point(px: x + p2.x, py: y + p2.y);
    }
    
    func distance(p2: Point) -> CGFloat {
        return sqrt((x - p2.x)*(x - p2.x) + (y - p2.y)*(y - p2.y));
    }
    
    func normal() -> Point {
        let length = sqrt(x*x + y*y);
        return Point(px: x/length, py: y/length);
    }
    
    func scale(s: CGFloat) -> Point {
    return Point(px: x*s, py: y*s);
    }   
}

class Circle: NSObject {
    var x, y, r, left: CGFloat;
    
    init(cr: CGFloat) {
        x = 0
        y = 0
        r = cr
        left = -cr
    }
    
    init(cx: CGFloat,cy: CGFloat, cr: CGFloat) {
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
    
    func intersects(c: Circle) -> Bool {
        let C0 = Point(px: x, py: y)
        let C1 = Point(px: c.x, py: c.y)
        return C0.distance(C1) <= r + c.r
    }
    
    func frame() -> CGRect {
        return CGRectMake(x-r, y-r, r*2, r*2)
    }
    
    var connections: [Circle] = [Circle]()
    
    func connect(circle: Circle) {
        if (self.connections.contains(circle)) {
            return
        }
        self.connections.append(circle)
    }
    
    func isConnected(circle: Circle) -> Bool {
        return self.connections.contains(circle)
    }
    
    func desc() -> String {
        return String(r) + " " + String(x) + " " + String(y)
    }
}

class Foam {
    var circles: [Circle]
    var size: CGSize
    
    init() {
        self.circles = [Circle]()
        self.size = CGSizeZero
    }
    
    init(circles: [Circle]) {
        self.circles = circles
        
        let minXCircle = self.circles.sort { (first, second) -> Bool in return first.x - first.r < second.x - second.r }[0]
        let minX = minXCircle.x - minXCircle.r
        let maxXCircle = self.circles.sort { (first, second) -> Bool in return first.x + first.r > second.x + second.r }[0]
        let maxX = maxXCircle.x + maxXCircle.r
        
        let minYCircle = self.circles.sort { (first, second) -> Bool in return first.y - first.r < second.y - second.r }[0]
        let minY = minYCircle.y - minYCircle.r
        let maxYCircle = self.circles.sort { (first, second) -> Bool in return first.y + first.r > second.y + second.r }[0]
        let maxY = maxXCircle.y + maxXCircle.r
        
        self.size = CGSizeMake(maxX - minX, maxY - minY)
        
        for circle in self.circles {
            circle.x -= minX
            circle.y -= minY
        }
        
    }
}


