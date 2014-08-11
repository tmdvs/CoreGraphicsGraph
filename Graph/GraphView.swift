//
//  GraphView.swift
//  Graph
//
//  Created by Tim Davies on 11/08/2014.
//  Copyright (c) 2014 Tim Davies. All rights reserved.
//

import UIKit
import QuartzCore

class GraphView: UIView {

    private var data : NSMutableArray = [] as NSMutableArray
    
    required init(coder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    init(frame: CGRect, data: NSArray) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.whiteColor()
        self.data = data.mutableCopy() as NSMutableArray
        
    }
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        // Lets work out the highest value, this will be 
        // used to work out the position of each value
        // on the Y axis, it essentialy reperesents 100%
        // of Y
        var everest = 0
        for point in data {
            if (point as NSNumber).integerValue > everest {
                everest = (point as NSNumber).integerValue
            }
        }
        
        // Draw graph AXIS
        let context = UIGraphicsGetCurrentContext()
        let axisPath = CGPathCreateMutable()
        CGPathMoveToPoint(axisPath, nil, 0, 0)
        CGPathAddLineToPoint(axisPath, nil, 0, rect.size.height);
        CGPathAddLineToPoint(axisPath, nil, rect.size.width, rect.size.height)
        CGContextAddPath(context, axisPath)
        
        CGContextSetStrokeColorWithColor(context, UIColor.grayColor().CGColor)
        CGContextStrokePath(context)
        
        // Lets move to the first point
        let pointPath = CGPathCreateMutable()
        let positionPercentage : Float = (Float(data[0] as Int) / Float(everest));
        let position : Int = Int(Float(rect.size.height) * positionPercentage);
        
        CGPathMoveToPoint(pointPath, nil, 10, rect.size.height - CGFloat(position))
        
        // Draw a market at this first point
        let pointMarker = CALayer()
        pointMarker.backgroundColor = UIColor.blackColor().CGColor
        pointMarker.frame = CGRectMake(5, (rect.size.height - CGFloat(position)) - 5, 10, 10)
        pointMarker.cornerRadius = 5
        self.layer.addSublayer(pointMarker)
        
        // Remove first value from data set as its position zero
        data.removeObjectAtIndex(0)
        
        // work out the distance to draw the remaining points at
        let interval = Int(rect.size.width - 20) / data.count;
        
        // Loop over the remaining values
        for point in data {
            
            // Calculate X and Y positions
            let ypositionPercentage : Float = Float(Float(point as Int) / Float(everest));
            let yposition : Int = Int(Float(rect.size.height) * ypositionPercentage);
            let xposition : CGFloat = CGFloat(interval * (data.indexOfObject(point) + 1)) + 10
            
            // Draw line to this value
            CGPathAddLineToPoint(pointPath, nil, xposition, rect.size.height - CGFloat(yposition));
            
            // Add a marker for this value
            let pointMarker = CALayer()
            pointMarker.backgroundColor = UIColor.blackColor().CGColor
            pointMarker.frame = CGRectMake(CGFloat(interval * (data.indexOfObject(point) + 1)) + 5, (rect.size.height - CGFloat(yposition)) - 5, 10, 10)
            pointMarker.cornerRadius = 5
            self.layer.addSublayer(pointMarker)
            
        }
        
        // Set stroke colours and stroke the values path
        CGContextAddPath(context, pointPath)
        CGContextSetLineWidth(context, 2)
        CGContextSetStrokeColorWithColor(context, UIColor.blackColor().CGColor)
        CGContextStrokePath(context)
        
        
    }
    
}
