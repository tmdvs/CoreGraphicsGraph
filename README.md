CoreGraphicsGraph
=================

Draw a line graph with CGPath

```swift
let graph = GraphView(frame: CGRectMake(50, 50, 400, 200))
graph.data = [10, 56, 34, 44, 12, 60, 54, 23, 53] as NSMutableArray
self.view.addSubview(graph)
```

## To do
  1. Add x axis label support
  2. Build y axis labels from values
