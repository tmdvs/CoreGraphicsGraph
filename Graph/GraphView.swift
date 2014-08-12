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

    private var data = NSMutableArray()
    
    private let padding : CGFloat = 30.0
    
    var showLines = true
    
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
        
        let context = UIGraphicsGetCurrentContext()
        let graphWidth = (rect.size.width - padding) - 10
        let graphHeight = rect.size.height - 40
        let axisWidth = rect.size.width - 10
        let axisHeight = (rect.size.height - padding) - 10
        
        // Lets work out the highest value, this will be 
        // used to work out the position of each value
        // on the Y axis, it essentialy reperesents 100%
        // of Y
        var everest : CGFloat = 0.0
        for point in data {
            let n : Int = point.objectForKey("value").integerValue
            if CGFloat(n) > everest {
                everest = CGFloat(Int(ceilf(Float(n) / 25) * 25))
            }
        }
        
        // Draw y axis labels and lines
        var yLabelInterval : Int = Int(everest / 5)
        for i in 0...5 {
            
            let label = UILabel(frame: CGRectMake(0, floor((rect.size.height - padding) - CGFloat(i) * (axisHeight / 5) - 10), 20, 20))
            label.text = NSString(format: "%d", i * yLabelInterval)
            label.font = UIFont.systemFontOfSize(12)
            label.backgroundColor = UIColor.whiteColor()
            label.textAlignment = NSTextAlignment.Right
            self.addSubview(label)
            
            if(self.showLines && i != 0) {
                let line = CGPathCreateMutable()
                CGPathMoveToPoint(line, nil, padding, floor(rect.size.height - padding) - (CGFloat(i) * (axisHeight / 5)) - 1)
                CGPathAddLineToPoint(line, nil, axisWidth, floor(rect.size.height - padding) - (CGFloat(i) * (axisHeight / 5)) - 1)
                CGContextAddPath(context, line)
                CGContextSetStrokeColorWithColor(context, UIColor(white: 0.9, alpha: 1).CGColor)
                CGContextStrokePath(context)
            }
        }
        
        // Draw graph AXIS
        let axisPath = CGPathCreateMutable()
        CGPathMoveToPoint(axisPath, nil, padding, 10)
        CGPathAddLineToPoint(axisPath, nil, padding, rect.size.height - 31)
        CGPathAddLineToPoint(axisPath, nil, axisWidth, rect.size.height - 31)
        CGContextAddPath(context, axisPath)
        
        CGContextSetStrokeColorWithColor(context, UIColor.grayColor().CGColor)
        CGContextStrokePath(context)
        
        // Lets move to the first point
        let pointPath = CGPathCreateMutable()
        let position : CGFloat = ceil((CGFloat(Int(data[0].objectForKey("value") as Int)) * (axisHeight / everest))) - 10
        
        CGPathMoveToPoint(pointPath, nil, 40, (axisHeight - position))
        
        // Draw a market at this first point
        let pointMarker = valueMarker()
        pointMarker.frame = CGRectMake(32, (graphHeight - position) - 8, 16, 16)
        self.layer.addSublayer(pointMarker)

        let label = UILabel(frame: CGRectMake(23, rect.size.height - 20, 36, 20))
        label.text = data[0].objectForKey("label") as NSString
        label.font = UIFont.systemFontOfSize(12)
        label.textAlignment = NSTextAlignment.Center
        label.backgroundColor = UIColor.whiteColor()
        self.addSubview(label)
        
        // Remove first value from data set as its position zero
        data.removeObjectAtIndex(0)
        
        // work out the distance to draw the remaining points at
        let interval = Int(graphWidth) / data.count;
        
        // Loop over the remaining values
        for point in data {
            
            // Calculate X and Y positions
            let yposition : CGFloat = ceil((CGFloat(point.objectForKey("value").integerValue as Int) * (axisHeight / everest))) - 10
            let xposition : CGFloat = CGFloat(interval * (data.indexOfObject(point) + 1)) + padding
            
            // Draw line to this value
            CGPathAddLineToPoint(pointPath, nil, xposition, graphHeight - yposition);

            let label = UILabel(frame: CGRectMake(xposition - 17, rect.size.height - 20, 36, 20))
            label.text = point.objectForKey("label") as NSString
            label.font = UIFont.systemFontOfSize(12)
            label.textAlignment = NSTextAlignment.Center
            label.backgroundColor = UIColor.whiteColor()
            self.addSubview(label)
            
            // Add a marker for this value
            let pointMarker = valueMarker()
            pointMarker.frame = CGRectMake(xposition - 8, ceil(graphHeight - yposition) - 8, 16, 16)
            self.layer.addSublayer(pointMarker)
            
        }
        
        // Set stroke colours and stroke the values path
        CGContextAddPath(context, pointPath)
        CGContextSetLineWidth(context, 2)
        CGContextSetStrokeColorWithColor(context, UIColor.blackColor().CGColor)
        CGContextStrokePath(context)
    }
    
    func valueMarker() -> CALayer {
        let pointMarker = CALayer()
        pointMarker.backgroundColor = UIColor.blackColor().CGColor
        pointMarker.cornerRadius = 8
        pointMarker.borderColor = UIColor.whiteColor().CGColor
        pointMarker.borderWidth = 3
        pointMarker.masksToBounds = true
        
        return pointMarker
    }
    
}
