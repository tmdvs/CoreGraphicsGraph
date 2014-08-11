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
        
        // Lets work out the highest value, this will be 
        // used to work out the position of each value
        // on the Y axis, it essentialy reperesents 100%
        // of Y
        var everest : CGFloat = 0.0
        for point in data {
            let n : Int = point.integerValue
            if CGFloat(n) > everest {
                everest = CGFloat(Int(ceilf(Float(n) / 25) * 25))
            }
        }
        
        // Draw y axis labels and lines
        var yLabelInterval : Int = Int(everest / 5)
        for i in 0...5 {
            
            let label = UILabel(frame: CGRectMake(0, floor(rect.size.height - (CGFloat(i) * rect.size.height / 5) - 10), 20, 20))
            label.text = NSString(format: "%d", i * yLabelInterval)
            label.font = UIFont.systemFontOfSize(12)
            label.textAlignment = NSTextAlignment.Right
            self.addSubview(label)
            
            if(self.showLines && i != 0) {
                let line = CGPathCreateMutable()
                CGPathMoveToPoint(line, nil, 30, floor(rect.size.height - (CGFloat(i) * rect.size.height / 5)) + 1)
                CGPathAddLineToPoint(line, nil, rect.size.width, floor(rect.size.height - (CGFloat(i) * rect.size.height / 5)) + 1)
                CGContextAddPath(context, line)
                CGContextSetStrokeColorWithColor(context, UIColor(white: 0.9, alpha: 1).CGColor)
                CGContextStrokePath(context)
            }
            
        }
        
        let graphWidth = rect.size.width - 30.0
        
        // Draw graph AXIS
        let axisPath = CGPathCreateMutable()
        CGPathMoveToPoint(axisPath, nil, 30, 0)
        CGPathAddLineToPoint(axisPath, nil, 30, rect.size.height - 1)
        CGPathAddLineToPoint(axisPath, nil, rect.size.width, rect.size.height - 1)
        CGContextAddPath(context, axisPath)
        
        CGContextSetStrokeColorWithColor(context, UIColor.grayColor().CGColor)
        CGContextStrokePath(context)
        
        // Lets move to the first point
        let pointPath = CGPathCreateMutable()
        let positionPercentage : CGFloat = CGFloat(Int(data[0] as Int)) / everest;
        let position : CGFloat = rect.size.height * CGFloat(positionPercentage);
        
        CGPathMoveToPoint(pointPath, nil, 40, rect.size.height - position)
        
        // Draw a market at this first point
        let pointMarker = valueMarker()
        pointMarker.frame = CGRectMake(32, (rect.size.height - position) - 8, 16, 16)
        self.layer.addSublayer(pointMarker)
        
        // Remove first value from data set as its position zero
        data.removeObjectAtIndex(0)
        
        // work out the distance to draw the remaining points at
        let interval = Int(graphWidth) / data.count;
        
        // Loop over the remaining values
        for point in data {
            
            // Calculate X and Y positions
            let ypositionPercentage : CGFloat = CGFloat(point.integerValue as Int) / everest;
            let yposition : CGFloat = rect.size.height * ypositionPercentage;
            let xposition : CGFloat = CGFloat(interval * (data.indexOfObject(point) + 1)) + 30.0
            
            // Draw line to this value
            CGPathAddLineToPoint(pointPath, nil, xposition, rect.size.height - yposition);
            
            // Add a marker for this value
            let pointMarker = valueMarker()
            pointMarker.frame = CGRectMake(xposition - 8, (rect.size.height - yposition) - 8, 16, 16)
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
