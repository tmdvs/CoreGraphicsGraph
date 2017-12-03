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
There isn't really that many…

  - **showLines**   - whether or not to display lines from Y axis values
  - **showPoints**  - whether or not to display points on the line graph
  - **linesColor**  - The colour of Y axis lines if visible
  - **xAxisColor**   - The colour of the X axis
  - **yAxisColor**   - The colour of the X axis
  - **graphColor**  - The colour of the actual line graph and points
  - **labelFont**   - Axis label font
  - **labelColor**  - The colour of the axis labels
  - **originLabelText**  - Text placed origin point
  - **originLabelText**  - The colour of originLabelText
  - **xMargin**  - padding left of initial point and right of last point
