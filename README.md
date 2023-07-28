CoreGraphicsGraph
=================
![Example](http://cl.ly/image/3M3y0A3w2C1F/d)
Draw a line graph with CGPath and Swift. This is really just the result of playing with Swift, and so I can't garuntee the code is production ready, or even very good.

```swift
// GraphView.swift example usage

let myData = [
    ["Mon" : 15],
    ["Tues" : 30],
    ["Weds" : 7],
    ["Thurs" : 60],
    ["Fri" : 30],
    ["Sat" : 15],
    ["Sun" : 45]
]

let graph = GraphView(frame: CGRect(x: 50, y: 50, width: 420, height: 200), data: myData)
self.view.addSubview(graph)
```

## Graph customisation options
There isn't really that many. The `GraphView` has a `style` property, the value of which is a `GraphStyle` struct which can be overriden.

```swift
struct GraphStyle {
 
    struct labels {
        var font = UIFont.systemFont(ofSize: 10)
        var color = UIColor.black
    }
    
    struct colors {
        var xAxis = UIColor.black
        var yAxis = UIColor.black
        var lines = UIColor.lightGray
        var graph = UIColor.black
    }
    
    var colors = colors()
    var labels = labels()
    
    var showLines = true
    var showPoints = true
    
    var xMargin : CGFloat = 20
}
```
