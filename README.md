CoreGraphicsGraph
=================
![Example](http://up.tmdvs.me/image/3M3y0A3w2C1F/d)
Draw a line graph with CGPath

```swift
let myData = [
    ["label" : "Mon",   "value" : NSNumber(int:15)] as NSDictionary,
    ["label" : "Tues",  "value" : NSNumber(int:30)] as NSDictionary,
    ["label" : "Weds",  "value" : NSNumber(int:7)] as NSDictionary,
    ["label" : "Thurs", "value" : NSNumber(int:60)] as NSDictionary,
    ["label" : "Fri",   "value" : NSNumber(int:30)] as NSDictionary,
    ["label" : "Sat",   "value" : NSNumber(int:15)] as NSDictionary,
    ["label" : "Sun",   "value" : NSNumber(int:45)] as NSDictionary,
] as NSArray

let graph = GraphView(frame: CGRectMake(50, 50, 420, 200), data: myData)
self.view.addSubview(graph)
```

## Graph customisation options
There isn't really that many…

  - **showLines**   - whether or not to display lines from Y axis values
  - **linesColor**  - The colour of Y axis lines if visible
  - **axisColor**   - The colour of the X and Y axis
  - **graphColor**  - The colour of the actual line graph and points
  - **labelFont**   - Axis label font
  - **labelColor**  - The colour of the axis labels


## To do
  1. ~~Add x axis label support~~
  2. ~~Build y axis labels from values~~
  3. ~~Customisation options~~
