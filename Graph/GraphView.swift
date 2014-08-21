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
    private var context : CGContextRef?
    
    private let padding     : CGFloat = 30
    private var graphWidth  : CGFloat = 0
    private var graphHeight : CGFloat = 0
    private var axisWidth   : CGFloat = 0
    private var axisHeight  : CGFloat = 0
    private var everest     : CGFloat = 0
    
    // Graph Styles
    var showLines   = true
    var showPoints  = true
    var linesColor  = UIColor(white: 0.9, alpha: 1)
    var axisColor   = UIColor.grayColor()
    var graphColor  = UIColor.blackColor()
    var labelFont   = UIFont.systemFontOfSize(12)
    var labelColor  = UIColor.blackColor()
    
    
    required init(coder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    init(frame: CGRect, data: NSArray) {

        super.init(frame: frame)
        backgroundColor = UIColor.whiteColor()
        self.data = data.mutableCopy() as NSMutableArray
        
    }
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        context = UIGraphicsGetCurrentContext()
        
        // Graph size
        graphWidth = (rect.size.width - padding) - 10
        graphHeight = rect.size.height - 40
        axisWidth = rect.size.width - 10
        axisHeight = (rect.size.height - padding) - 10
        
        // Lets work out the highest value, this will be 
        // used to work out the position of each value
        // on the Y axis, it essentialy reperesents 100%
        // of Y
        for point in data {
            let n : Int = point.objectForKey("value").integerValue
            if CGFloat(n) > everest {
                everest = CGFloat(Int(ceilf(Float(n) / 25) * 25))
            }
        }
        
        // Draw graph AXIS
        let axisPath = CGPathCreateMutable()
        CGPathMoveToPoint(axisPath, nil, padding, 10)
        CGPathAddLineToPoint(axisPath, nil, padding, rect.size.height - 31)
        CGPathAddLineToPoint(axisPath, nil, axisWidth, rect.size.height - 31)
        CGContextAddPath(context, axisPath)
        
        CGContextSetStrokeColorWithColor(context, axisColor.CGColor)
        CGContextStrokePath(context)
        
        // Draw y axis labels and lines
        var yLabelInterval : Int = Int(everest / 5)
        for i in 0...5 {
            
            let label = axisLabel(NSString(format: "%d", i * yLabelInterval))
            label.frame = CGRectMake(0, floor((rect.size.height - padding) - CGFloat(i) * (axisHeight / 5) - 10), 20, 20)
            addSubview(label)
            
            if(showLines && i != 0) {
                let line = CGPathCreateMutable()
                CGPathMoveToPoint(line, nil, padding + 1, floor(rect.size.height - padding) - (CGFloat(i) * (axisHeight / 5)))
                CGPathAddLineToPoint(line, nil, axisWidth, floor(rect.size.height - padding) - (CGFloat(i) * (axisHeight / 5)))
                CGContextAddPath(context, line)
                CGContextSetStrokeColorWithColor(context, linesColor.CGColor)
                CGContextStrokePath(context)
            }
        }
        
        // Lets move to the first point
        let pointPath = CGPathCreateMutable()
        let initialY : CGFloat = ceil((CGFloat(data[0].objectForKey("value").integerValue as Int) * (axisHeight / everest))) - 10
        let initialX : CGFloat = padding + (showPoints ? 10 : 0)
        CGPathMoveToPoint(pointPath, nil, initialX, graphHeight - initialY)
        
        // Loop over the remaining values
        for point in data {
            plotPoint(point as NSDictionary, path: pointPath)
        }
        
        // Set stroke colours and stroke the values path
        CGContextAddPath(context, pointPath)
        CGContextSetLineWidth(context, 2)
        CGContextSetStrokeColorWithColor(context, graphColor.CGColor)
        CGContextStrokePath(context)
    }
    
    
    // Plot a point on the graph
    func plotPoint(point : NSDictionary, path: CGMutablePathRef) {
        
        // work out the distance to draw the remaining points at
        let interval = Int(graphWidth) / (data.count - 1);
        
        // Calculate X and Y positions
        var yposition : CGFloat = ceil((CGFloat(point.objectForKey("value").integerValue as Int) * (axisHeight / everest))) - 10
        var xposition : CGFloat = CGFloat(interval * (data.indexOfObject(point))) + padding
        
        // If its the first point we want to nuge it in slightly
        if(data.indexOfObject(point) == 0 && showPoints) {
            xposition += 10
        }
        
        // Draw line to this value
        CGPathAddLineToPoint(path, nil, xposition, graphHeight - yposition);
        
        let xLabel = axisLabel(point.objectForKey("label") as NSString)
        xLabel.frame = CGRectMake(xposition - 17, graphHeight + 20, 36, 20)
        xLabel.textAlignment = NSTextAlignment.Center
        addSubview(xLabel)
        
        if(showPoints) {
            // Add a marker for this value
            let pointMarker = valueMarker()
            pointMarker.frame = CGRectMake(xposition - 8, ceil(graphHeight - yposition) - 8, 16, 16)
            layer.addSublayer(pointMarker)
        }
    }
    
    
    // Returns an axis label
    func axisLabel(title: NSString) -> UILabel {
        let label = UILabel(frame: CGRectZero)
        label.text = title
        label.font = labelFont
        label.textColor = labelColor
        label.backgroundColor = backgroundColor
        label.textAlignment = NSTextAlignment.Right
        
        return label
    }
    
    
    // Returns a point for plotting
    func valueMarker() -> CALayer {
        let pointMarker = CALayer()
        pointMarker.backgroundColor = backgroundColor?.CGColor
        pointMarker.cornerRadius = 8
        pointMarker.masksToBounds = true
        
        let markerInner = CALayer()
        markerInner.frame = CGRectMake(3, 3, 10, 10)
        markerInner.cornerRadius = 5
        markerInner.masksToBounds = true
        markerInner.backgroundColor = graphColor.CGColor
        
        pointMarker.addSublayer(markerInner)
        
        return pointMarker
    }
    
}
