# Change Log
-----

## [1.2.0 - Swift 4.2](https://github.com/micheltlutz/MLLineChart/releases/tag/v1.2.0) (2018-12-27)

* Suport gradient curved charts

### Usage: 

```swift 

let lineChart = MLLineChart(frame: CGRect(x: 0, y: 0, width: 260, height: 230))
lineChart.translatesAutoresizingMaskIntoConstraints = false
lineChart.hasColoredLines = true
lineChart.isGradientLineColors = true
lineChart.disableScroll = true
lineChart.isCurved = true
lineChart.axisBackgroundColor = CinguloColors.bgdiaryChart.color
lineChart.gradienLinesColors = [UIColor.green.cgColor, UIColor.orange.cgColor,UIColor.red.cgColor]
```

---

## [1.1.0 - Swift 4.2](https://github.com/micheltlutz/MLLineChart/releases/tag/v1.1.0) (2018-11-01)

#### Add
* Support a Swift 4.2
* Remove Dispatch from UIView.animate
* lineGap now is open var and can change value to decrease or increase the space between points on the x-axis (only for line chart)
* some adjustments to chart calc


---

## [1.0 - Swift 4.1](https://github.com/micheltlutz/MLLineChart/releases/tag/v1.0) (2018-10-09)

#### Add
* initial project.


---

