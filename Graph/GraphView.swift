//
//  LineChart.swift
//  castella
//
//  Created by heeju on 7/12/16.
//  Copyright © 2016 mtov. All rights reserved.
//

import UIKit
import QuartzCore

class GraphView: UIView {
    
    private var data = NSMutableArray()
    private var context : CGContext?
    
    private let padding     : CGFloat = 30
    private var graphWidth  : CGFloat = 0
    private var graphHeight : CGFloat = 0
    private var axisWidth   : CGFloat = 0
    private var axisHeight  : CGFloat = 0
    private var everest     : CGFloat = 0
    
    // Graph Styles
    var showLines   = true
    var showPoints  = true
    var linesColor  = UIColor.init(red: 52/255, green: 52/255, blue: 52/255, alpha: 1)
    var graphColor  = UIColor.black
    var labelFont   = UIFont.systemFont(ofSize: 12)
    var labelColor  = UIColor.black
    var xAxisColor  = UIColor.init(red: 52/255, green: 52/255, blue: 52/255, alpha: 1)
    var yAxisColor  = UIColor.blue
    
    var xMargin         : CGFloat = 20
    var originLabelText = ""
    var originLabelColor = UIColor.white
    
    required init(coder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    init(frame: CGRect, data: NSArray) {
        
        super.init(frame: frame)
        backgroundColor = UIColor.clear
        self.data = data.mutableCopy() as! NSMutableArray
        
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        context = UIGraphicsGetCurrentContext()
        
        // Graph size
        graphWidth = (rect.size.width - padding) - 10
        graphHeight = rect.size.height - 40
        axisWidth = rect.size.width - 10
        axisHeight = (rect.size.height - padding) - 10
        
        // Lets work out the highest value and round to the nearest 25.
        // This will be used to work out the position of each value
        // on the Y axis, it essentialy reperesents 100% of Y
        for point in data {
            let n : Int = ((point as AnyObject).object(forKey: "value") as! NSNumber).intValue
            if CGFloat(n) > everest {
                everest = CGFloat(Int(ceilf(Float(n) / 25) * 25))
            }
        }
        if everest == 0 {
            everest = 25
        }
        
        // Draw graph X-AXIS
        let xAxisPath = CGMutablePath()
        xAxisPath.move(to: CGPoint(x: padding, y: rect.size.height - 31))
        xAxisPath.move(to: CGPoint(x: axisWidth, y: rect.size.height - 31))
        context!.addPath(xAxisPath)
        
        context!.setStrokeColor(xAxisColor.cgColor)
        context!.strokePath()
        
        // Draw graph Y-AXIS
        let yAxisPath = CGMutablePath()
        yAxisPath.move(to: CGPoint(x: padding, y: 10))
        yAxisPath.move(to: CGPoint(x: padding, y: rect.size.height - 31))
        context!.addPath(yAxisPath)
        
        context!.setStrokeColor(yAxisColor.cgColor)
        context!.strokePath()
        
        // Draw y axis labels and lines
        let yLabelInterval : Int = Int(everest / 5)
        for i in 0...5 {
            
            let label = axisLabel(title: NSString(format: "%d", i * yLabelInterval))
            label.frame = CGRect(x: 0, y: floor((rect.size.height - padding) - CGFloat(i) * (axisHeight / 5) - 10), width: 20, height: 20)
            addSubview(label)
            
            
            if(showLines && i != 0) {
                let line = CGMutablePath()
                line.move(to: CGPoint(x: padding + 1, y: floor(rect.size.height - padding) - (CGFloat(i) * (axisHeight / 5))))
                line.move(to: CGPoint(x: axisWidth, y: floor(rect.size.height - padding) - (CGFloat(i) * (axisHeight / 5))))
                context!.addPath(line)
                context!.setStrokeColor(linesColor.cgColor)
                context!.strokePath()
            }
        }
        
        // Lets move to the first point
        let pointPath = CGMutablePath()
        let firstPoint = (data[0] as! NSDictionary).object(forKey: "value") as! NSNumber
        let initialY : CGFloat = ceil((CGFloat(firstPoint.intValue as Int) * (axisHeight / everest))) - 10
        let initialX : CGFloat = padding + xMargin
        pointPath.move(to: CGPoint(x: initialX, y: graphHeight - initialY))
        
        // Loop over the remaining values
        for point in data {
            plotPoint(point: point as! NSDictionary, path: pointPath)
        }
        
        // Set stroke colours and stroke the values path
        context!.addPath(pointPath)
        context!.setLineWidth(2)
        context!.setStrokeColor(graphColor.cgColor)
        context!.strokePath()
        
        // Add Origin Label
        let originLabel = UILabel()
        originLabel.text = originLabelText
        originLabel.textAlignment = .center
        originLabel.font = labelFont
        originLabel.textColor = originLabelColor
        originLabel.backgroundColor = backgroundColor
        originLabel.frame = CGRect(x: -2, y: graphHeight + 20, width: 40, height: 20)
        addSubview(originLabel)
    }
    
    
    // Plot a point on the graph
    func plotPoint(point : NSDictionary, path: CGMutablePath) {
        
        // work out the distance to draw the remaining points at
        let interval = Int(graphWidth - xMargin * 2) / (data.count - 1);
        
        let pointValue = (point.object(forKey: "value") as! NSNumber).intValue
        
        // Calculate X and Y positions
        let yposition : CGFloat = ceil((CGFloat(pointValue) * (axisHeight / everest))) - 10
        let xposition : CGFloat = CGFloat(interval * (data.index(of: point))) + padding + xMargin
        
        // Draw line to this value
        path.addLine(to: CGPoint(x: xposition, y: graphHeight - yposition))
        
        let xLabel = axisLabel(title: point.object(forKey: "label") as! NSString)
        xLabel.frame = CGRect(x: xposition - 17, y: graphHeight + 20, width: 36, height: 20)
        xLabel.textAlignment = .center
        addSubview(xLabel)
        
        if(showPoints) {
            // Add a marker for this value
            let pointMarker = valueMarker()
            pointMarker.frame = CGRect(x: xposition - 8, y: CGFloat(ceil(graphHeight - yposition) - 8), width: 16, height: 16)
            layer.addSublayer(pointMarker)
        }
    }
    
    
    // Returns an axis label
    func axisLabel(title: NSString) -> UILabel {
        let label = UILabel(frame: CGRect.zero)
        label.text = title as String
        label.font = labelFont
        label.textColor = labelColor
        label.backgroundColor = backgroundColor
        label.textAlignment = NSTextAlignment.right
        
        return label
    }
    
    
    // Returns a point for plotting
    func valueMarker() -> CALayer {
        let pointMarker = CALayer()
        pointMarker.backgroundColor = backgroundColor?.cgColor
        pointMarker.cornerRadius = 8
        pointMarker.masksToBounds = true
        
        let markerInner = CALayer()
        markerInner.frame = CGRect(x: 3, y: 3, width: 10, height: 10)
        markerInner.cornerRadius = 5
        markerInner.masksToBounds = true
        markerInner.backgroundColor = graphColor.cgColor
        
        pointMarker.addSublayer(markerInner)
        
        return pointMarker
    }
    
}
