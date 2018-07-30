////MIT License
////
////Copyright (c) 2018 Michel Anderson Lüz Teixeira
////
////Permission is hereby granted, free of charge, to any person obtaining a copy
////of this software and associated documentation files (the "Software"), to deal
////in the Software without restriction, including without limitation the rights
////to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
////copies of the Software, and to permit persons to whom the Software is
////furnished to do so, subject to the following conditions:
////
////The above copyright notice and this permission notice shall be included in all
////copies or substantial portions of the Software.
////
////THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
////IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
////FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
////AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
////LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
////OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
////SOFTWARE.

import UIKit
import QuartzCore

// delegate method
public protocol MLLineChartDelegate {
    func didSelectDataPoint(_ x: CGFloat, yValues: [CGFloat])
}
public struct MLConfigAxis {
    var from: Int
    var to: Int
    var by: Int? = 1
    var visible: Bool? = true
    
    public init(from: Int, to: Int, by: Int? = 1, visible: Bool? = true){
        self.from = from
        self.to = to
        self.by = by
        self.visible = visible
    }
    func range() -> [Int] {
        return Array(from...to)
    }
}
public struct MLConfigAxisXY {
    var xAxisConfig: MLConfigAxis
    var yAxisConfig: MLConfigAxis
    
    public init(xAxisConfig: MLConfigAxis, yAxisConfig: MLConfigAxis) {
        self.xAxisConfig = xAxisConfig
        self.yAxisConfig = yAxisConfig
    }
}
//
public struct MLConfigLabelsXY {
    var xLabels: MLLineChart.Labels
    var yLabels: MLLineChart.Labels
    public init(xLabels: MLLineChart.Labels, yLabels: MLLineChart.Labels) {
        self.xLabels = xLabels
        self.yLabels = yLabels
    }
}

/**
 * MLLineChart
 */
open class MLLineChart: UIView {
    static let name = "MLLineChart"
    public struct Labels {
        public var visible: Bool = true
        public var values: [String] = []
        public var font: UIFont = UIFont.preferredFont(forTextStyle: UIFontTextStyle.caption2)
        public var textColor: UIColor = .black
        public var textAlignment: NSTextAlignment = .center
        
        public init(visible: Bool = true, values: [String] = [], font: UIFont = UIFont.preferredFont(forTextStyle: UIFontTextStyle.caption2), textColor: UIColor = .black, textAlignment: NSTextAlignment = .center) {
            self.visible = visible
            self.values = values
            self.font = font
            self.textColor = textColor
            self.textAlignment = textAlignment
        }
    }
    
    public struct Grid {
        public var visible: Bool = true
        public var count: CGFloat = 10
        // #eeeeee
        public var color: UIColor = UIColor(red: 238/255.0, green: 238/255.0, blue: 238/255.0, alpha: 1)
        
        public init(visible: Bool = true, count: CGFloat = 10, color: UIColor = UIColor(red: 238/255.0, green: 238/255.0, blue: 238/255.0, alpha: 1)){
            self.visible = visible
            self.count = count
            self.color = color
        }
    }
    
    public struct Axis {
        public var visible: Bool = true
        // #607d8b
        public var color: UIColor = UIColor(red: 96/255.0, green: 125/255.0, blue: 139/255.0, alpha: 1)
        public var inset: CGFloat = 15
        
        public init(visible: Bool = true, color: UIColor = UIColor(red: 96/255.0, green: 125/255.0, blue: 139/255.0, alpha: 1), inset: CGFloat = 15) {
            self.visible = visible
            self.color = color
            self.inset = inset
        }
    }
    
    public struct Coordinate {
        // public
        public var labels: Labels = Labels()
        public var grid: Grid = Grid()
        public var axis: Axis = Axis()
        
        // private
        fileprivate var linear: MLLinearScale!
        fileprivate var scale: ((CGFloat) -> CGFloat)!
        fileprivate var invert: ((CGFloat) -> CGFloat)!
        fileprivate var ticks: (CGFloat, CGFloat, CGFloat)!
    }
    
    public struct Animation {
        public var enabled: Bool = true
        public var duration: CFTimeInterval = 1
    }
    
    public struct Dots {
        public var visible: Bool = true
        public var color: UIColor = UIColor.white
        public var innerRadius: CGFloat = 8
        public var outerRadius: CGFloat = 12
        public var innerRadiusHighlighted: CGFloat = 8
        public var outerRadiusHighlighted: CGFloat = 12
    }
    
    // default configuration
    open var area: Bool = true
    open var animation: Animation = Animation()
    open var dots: Dots = Dots()
    open var lineWidth: CGFloat = 2
    
    open var x: Coordinate = Coordinate()
    open var y: Coordinate = Coordinate()
    
    
    // values calculated on init
    fileprivate var drawingHeight: CGFloat = 0 {
        didSet {
            let max = getMaximumValue()
            let min = getMinimumValue()
            y.linear = MLLinearScale(domain: [min, max], range: [0, drawingHeight])
            y.scale = y.linear.scale()
            y.ticks = y.linear.ticks(Int(y.grid.count))
        }
    }
    fileprivate var drawingWidth: CGFloat = 0 {
        didSet {
            //let data = dataStore[0]
            let data = self.x.grid
            x.linear = MLLinearScale(domain: [0.0, CGFloat(data.count - 1)], range: [0, drawingWidth])
            x.scale = x.linear.scale()
            x.invert = x.linear.invert()
            x.ticks = x.linear.ticks(Int(x.grid.count))
        }
    }
    
    open var delegate: MLLineChartDelegate?
    
    // data stores
    fileprivate var dataStore: [[CGFloat]] = []
    fileprivate var labelStore: [String] = [] {
        didSet {
            for view: UIView in self.subviews {
                view.removeFromSuperview()
            }
            drawXLabels()
        }
    }
    fileprivate var dotsDataStore: [[DotCALayer]] = []
    fileprivate var lineLayerStore: [CAShapeLayer] = []
    fileprivate var removeAll: Bool = false
    
    open var configLabels: MLConfigLabelsXY!
    open var configAxis: MLConfigAxisXY!
    
    open var colors: [UIColor] = [
        UIColor(red: 0.121569, green: 0.466667, blue: 0.705882, alpha: 1),
        UIColor(red: 1, green: 0.498039, blue: 0.054902, alpha: 1),
        UIColor(red: 0.172549, green: 0.627451, blue: 0.172549, alpha: 1),
        UIColor(red: 0.839216, green: 0.152941, blue: 0.156863, alpha: 1),
        UIColor(red: 0.580392, green: 0.403922, blue: 0.741176, alpha: 1),
        UIColor(red: 0.54902, green: 0.337255, blue: 0.294118, alpha: 1),
        UIColor(red: 0.890196, green: 0.466667, blue: 0.760784, alpha: 1),
        UIColor(red: 0.498039, green: 0.498039, blue: 0.498039, alpha: 1),
        UIColor(red: 0.737255, green: 0.741176, blue: 0.133333, alpha: 1),
        UIColor(red: 0.0901961, green: 0.745098, blue: 0.811765, alpha: 1)
    ]
    
    open var lineColors: [UIColor] = []
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
    }
    
    convenience init() {
        self.init(frame: CGRect.zero)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override open func draw(_ rect: CGRect) {
        
        if removeAll {
            let context = UIGraphicsGetCurrentContext()
            context?.clear(rect)
            return
        }
        
        self.drawingHeight = self.bounds.height - (2 * y.axis.inset)
        self.drawingWidth = self.bounds.width - (2 * x.axis.inset)
        
        // remove all labels
        for view: UIView in self.subviews {
            view.removeFromSuperview()
        }
        
        // remove all lines on device rotation
        for lineLayer in lineLayerStore {
            lineLayer.removeFromSuperlayer()
        }
        lineLayerStore.removeAll()
        
        // remove all dots on device rotation
        for dotsData in dotsDataStore {
            for dot in dotsData {
                dot.removeFromSuperlayer()
            }
        }
        dotsDataStore.removeAll()
        
        // draw grid
        
        if configAxis.xAxisConfig.visible! && configAxis.yAxisConfig.visible! { drawGrid() }
        
        //if x.grid.visible && y.grid.visible { drawGrid() }
        
        // draw axes
        if x.axis.visible && y.axis.visible { drawAxes() }
        
        // draw labels
        
        if configLabels.xLabels.visible { drawXLabels() }
        //&& configLabels.yLabels.visible! { }
        
        
        if configLabels.yLabels.values.count > 0 {
            if configLabels.yLabels.visible { drawYLabelsFromData() }
        } else {
            if configLabels.yLabels.visible { drawYLabels() }
        }
        
        
        
        //if x.labels.visible { drawXLabels() }
        //if y.labels.visible { drawYLabels() }
        
        // draw lines
        for (lineIndex, _) in dataStore.enumerated() {
            
            drawLine(lineIndex)
            
            // draw dots
            if dots.visible { drawDataDots(lineIndex) }
            
            // draw area under line chart
            if area { drawAreaBeneathLineChart(lineIndex) }
            
        }
    }
    
    /**
     * Get y value for given x value. Or return zero or maximum value.
     */
    fileprivate func getYValuesForXValue(_ x: Int) -> [CGFloat] {
        var result: [CGFloat] = []
        for lineData in dataStore {
            if x < 0 {
                result.append(lineData[0])
            } else if x > lineData.count - 1 {
                result.append(lineData[lineData.count - 1])
            } else {
                result.append(lineData[x])
            }
        }
        return result
    }
    
    
    
    /**
     * Handle touch events.
     */
    fileprivate func handleTouchEvents(_ touches: NSSet!, event: UIEvent) {
        if (self.dataStore.isEmpty) {
            return
        }
        let point: AnyObject! = touches.anyObject() as AnyObject?
        let xValue = point.location(in: self).x
        let inverted = self.x.invert(xValue - x.axis.inset)
        let rounded = Int(round(Double(inverted)))
        let yValues: [CGFloat] = getYValuesForXValue(rounded)
        highlightDataPoints(rounded)
        delegate?.didSelectDataPoint(CGFloat(rounded), yValues: yValues)
    }
    
    
    
    /**
     * Listen on touch end event.
     */
    override open func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        handleTouchEvents(touches as NSSet?, event: event!)
    }
    
    
    
    /**
     * Listen on touch move event
     */
    override open func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        handleTouchEvents(touches as NSSet?, event: event!)
    }
    
    
    
    /**
     * Highlight data points at index.
     */
    fileprivate func highlightDataPoints(_ index: Int) {
        for (lineIndex, dotsData) in dotsDataStore.enumerated() {
            // make all dots white again
            for dot in dotsData {
                dot.backgroundColor = dots.color.cgColor
            }
            // highlight current data point
            var dot: DotCALayer
            if index < 0 {
                dot = dotsData[0]
            } else if index > dotsData.count - 1 {
                dot = dotsData[dotsData.count - 1]
            } else {
                dot = dotsData[index]
            }
            dot.backgroundColor = Helpers.lightenUIColor(colors[lineIndex]).cgColor
        }
    }
    
    
    
    /**
     * Draw small dot at every data point.
     */
    fileprivate func drawDataDots(_ lineIndex: Int) {
        var dotLayers: [DotCALayer] = []
        var data = self.dataStore[lineIndex]
        
        for index in 0..<data.count {
            let xValue = self.x.scale(CGFloat(index)) + x.axis.inset - dots.outerRadius/2
            let yValue = self.bounds.height - self.y.scale(data[index]) - y.axis.inset - dots.outerRadius/2
            
            // draw custom layer with another layer in the center
            let dotLayer = DotCALayer()
            dotLayer.dotInnerColor = colors[lineIndex]
            dotLayer.innerRadius = dots.innerRadius
            dotLayer.backgroundColor = dots.color.cgColor
            dotLayer.cornerRadius = dots.outerRadius / 2
            dotLayer.frame = CGRect(x: xValue, y: yValue, width: dots.outerRadius, height: dots.outerRadius)
            self.layer.addSublayer(dotLayer)
            dotLayers.append(dotLayer)
            
            // animate opacity
            if animation.enabled {
                let anim = CABasicAnimation(keyPath: "opacity")
                anim.duration = animation.duration
                anim.fromValue = 0
                anim.toValue = 1
                dotLayer.add(anim, forKey: "opacity")
            }
            
        }
        dotsDataStore.append(dotLayers)
    }
    
    
    
    /**
     * Draw x and y axis.
     */
    fileprivate func drawAxes() {
        let height = self.bounds.height
        let width = self.bounds.width
        let path = UIBezierPath()
        // draw x-axis
        x.axis.color.setStroke()
        let y0 = height - self.y.scale(0) - y.axis.inset
        path.move(to: CGPoint(x: x.axis.inset, y: y0))
        path.addLine(to: CGPoint(x: width - x.axis.inset, y: y0))
        path.stroke()
        // draw y-axis
        y.axis.color.setStroke()
        path.move(to: CGPoint(x: x.axis.inset, y: height - y.axis.inset))
        path.addLine(to: CGPoint(x: x.axis.inset, y: y.axis.inset))
        path.stroke()
    }
    
    
    
    /**
     * Get maximum value in all arrays in data store.
     */
    fileprivate func getMaximumValue() -> CGFloat {
        var max: CGFloat = 1
        for data in dataStore {
            let newMax = data.max()!
            if newMax > max {
                max = newMax
            }
        }
        return max
    }
    
    
    
    /**
     * Get maximum value in all arrays in data store.
     */
    fileprivate func getMinimumValue() -> CGFloat {
        var min: CGFloat = 0
        for data in dataStore {
            let newMin = data.min()!
            if newMin < min {
                min = newMin
            }
        }
        return min
    }
    
    /**
     * Draw line OLD
     */
    //    fileprivate func drawLineOLD(_ lineIndex: Int) {
    //
    //        var data = self.dataStore[lineIndex]
    //        let path = UIBezierPath()
    //
    //        var xValue = self.x.scale(0) + x.axis.inset
    //        var yValue = self.bounds.height - self.y.scale(data[0]) - y.axis.inset
    //        path.move(to: CGPoint(x: xValue, y: yValue))
    //        for index in 1..<data.count {
    //            xValue = self.x.scale(CGFloat(index)) + x.axis.inset
    //            yValue = self.bounds.height - self.y.scale(data[index]) - y.axis.inset
    //            path.addLine(to: CGPoint(x: xValue, y: yValue))
    //        }
    //
    //        let layer = CAShapeLayer()
    //        layer.frame = self.bounds
    //        layer.path = path.cgPath
    //        layer.strokeColor = colors[lineIndex].cgColor
    //        layer.fillColor = nil
    //        layer.lineWidth = lineWidth
    //        self.layer.addSublayer(layer)
    //
    //        // animate line drawing
    //        if animation.enabled {
    //            let anim = CABasicAnimation(keyPath: "strokeEnd")
    //            anim.duration = animation.duration
    //            anim.fromValue = 0
    //            anim.toValue = 1
    //            layer.add(anim, forKey: "strokeEnd")
    //        }
    //
    //        // add line layer to store
    //        lineLayerStore.append(layer)
    //    }
    /**
     * Draw line.
     */
    fileprivate func drawLine(_ lineIndex: Int) {
        var data = self.dataStore[lineIndex]
        var xValue = self.x.scale(0) + x.axis.inset
        var yValue = self.bounds.height - self.y.scale(data[0]) - y.axis.inset
        
        for index in 1..<data.count {
            let path = UIBezierPath()
            path.move(to: CGPoint(x: xValue, y: yValue))
            xValue = self.x.scale(CGFloat(index)) + x.axis.inset
            yValue = self.bounds.height - self.y.scale(data[index]) - y.axis.inset
            path.addLine(to: CGPoint(x: xValue, y: yValue))
            //
            self.layer.addSublayer(getLineLayer(index: index, path: path))
        }
    }
    //
    
    /**
     * Fill area between line chart and x-axis.
     */
    fileprivate func drawAreaBeneathLineChart(_ lineIndex: Int) {
        
        var data = self.dataStore[lineIndex]
        let path = UIBezierPath()
        
        colors[lineIndex].withAlphaComponent(0.2).setFill()
        // move to origin
        path.move(to: CGPoint(x: x.axis.inset, y: self.bounds.height - self.y.scale(0) - y.axis.inset))
        // add line to first data point
        path.addLine(to: CGPoint(x: x.axis.inset, y: self.bounds.height - self.y.scale(data[0]) - y.axis.inset))
        // draw whole line chart
        for index in 1..<data.count {
            let x1 = self.x.scale(CGFloat(index)) + x.axis.inset
            let y1 = self.bounds.height - self.y.scale(data[index]) - y.axis.inset
            path.addLine(to: CGPoint(x: x1, y: y1))
        }
        // move down to x axis
        path.addLine(to: CGPoint(x: self.x.scale(CGFloat(data.count - 1)) + x.axis.inset, y: self.bounds.height - self.y.scale(0) - y.axis.inset))
        // move to origin
        path.addLine(to: CGPoint(x: x.axis.inset, y: self.bounds.height - self.y.scale(0) - y.axis.inset))
        path.fill()
    }
    
    //MARK: - Draw Grids
    
    /**
     * Draw x grid.
     */
    fileprivate func drawXGrid() {
        x.grid.color.setStroke()
        let path = UIBezierPath()
        var x1: CGFloat
        let y1: CGFloat = self.bounds.height - y.axis.inset
        let y2: CGFloat = y.axis.inset
        let (start, stop, step) = self.x.ticks
        for i in stride(from: start, through: stop, by: step){
            x1 = self.x.scale(i) + x.axis.inset
            path.move(to: CGPoint(x: x1, y: y1))
            path.addLine(to: CGPoint(x: x1, y: y2))
        }
        path.stroke()
    }
    
    
    
    /**
     * Draw y grid.
     */
    fileprivate func drawYGrid() {
        self.y.grid.color.setStroke()
        let path = UIBezierPath()
        let x1: CGFloat = x.axis.inset
        let x2: CGFloat = self.bounds.width - x.axis.inset
        var y1: CGFloat
        //let (start, stop, step) = self.y.ticks
        let yAxisData = configLabels.yLabels.values
        let yValue = getyHeightValue(to: yAxisData.count)
        var margin = CGFloat(0.0)
        for (index, _) in yAxisData.enumerated() {
            y1 = (yValue.height * CGFloat(index)) + margin
            if y1  == 0.0 {
                margin = yValue.fontHeight / 2
                y1  += margin
            }
            path.move(to: CGPoint(x: x1, y: y1))
            path.addLine(to: CGPoint(x: x2, y: y1))
        }
        path.stroke()
    }
    
    //    fileprivate func drawYGrid() {
    //        self.y.grid.color.setStroke()
    //        let path = UIBezierPath()
    //        let x1: CGFloat = x.axis.inset
    //        let x2: CGFloat = self.bounds.width - x.axis.inset
    //        var y1: CGFloat
    //        let (start, stop, step) = self.y.ticks
    //        for i in stride(from: start, through: stop, by: step){
    //            y1 = self.bounds.height - self.y.scale(i) - y.axis.inset
    //            path.move(to: CGPoint(x: x1, y: y1))
    //            path.addLine(to: CGPoint(x: x2, y: y1))
    //        }
    //        path.stroke()
    //    }
    
    
    
    /**
     * Draw grid.
     */
    fileprivate func drawGrid() {
        drawXGrid()
        drawYGrid()
    }
    
    /**
     * Draw x labels.
     */
    fileprivate func drawXLabels() {
        let xAxisData = self.configLabels.xLabels.values
        //let xAxisData = self.labelStore
        let y = self.bounds.height - x.axis.inset
        let width = self.layer.bounds.width
        var text: String
        let fontWidth = CGFloat(11)
        var divisorCount = CGFloat(1)
        if xAxisData.count % 2 == 0{
            divisorCount = CGFloat(xAxisData.count - 1)
        } else {
            divisorCount = CGFloat(xAxisData.count - 2)
        }
        let xValue = (width - (fontWidth * CGFloat(xAxisData.count))) / divisorCount
        var margin = CGFloat(0.0)
        for (index, _) in xAxisData.enumerated() {
            var size = (xValue * CGFloat(index)) + margin
            if size == 0.0 {
                margin = fontWidth / 2
                size += margin
            }
            //print("\n\n\n size \( size ) \n\n\n")
            //print("\n\n\n x.axis.inset \( x.axis.inset ) \n\n\n")
            let label = UILabel(frame: CGRect(x: size, y: y, width: x.axis.inset, height: x.axis.inset))
            label.font = self.x.labels.font
            label.textColor = self.x.labels.textColor
            label.textAlignment = self.x.labels.textAlignment
            
            if (xAxisData.count != 0) {
                text = xAxisData[index]
            } else {
                text = String(index)
            }
            label.text = text
            self.addSubview(label)
        }
    }
    
    //MARK: - Draw Labels
    
    /**
     * Draw y labels.
     */
    fileprivate func drawYLabels() {
        var yValue: CGFloat
        let (start, stop, step) = self.y.ticks
        for i in stride(from: start, through: stop, by: step){
            yValue = self.bounds.height - self.y.scale(i) - (y.axis.inset * 1.5)
            let label = UILabel(frame: CGRect(x: 0, y: yValue, width: y.axis.inset, height: y.axis.inset))
            label.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.caption2)
            label.textAlignment = .center
            label.text = String(Int(round(i)))
            self.addSubview(label)
        }
    }
    
    fileprivate func getyHeightValue(to yAxisData: Int) -> (height: CGFloat, fontHeight: CGFloat) {
        //let (start, stop, step) = self.y.ticks
        let fontHeight = CGFloat(11)
        let height = self.layer.bounds.height
        var divisorCount = CGFloat(1)
        if yAxisData % 2 == 0{
            divisorCount = CGFloat(yAxisData - 1)
        } else {
            divisorCount = CGFloat(yAxisData - 2)
        }
        return (height: (height - (fontHeight * CGFloat(yAxisData))) / divisorCount, fontHeight: fontHeight)
    }
    
    fileprivate func drawYLabelsFromData() {
        let yAxisData = configLabels.yLabels.values
        let yValue = getyHeightValue(to: yAxisData.count)
        var margin = CGFloat(0.0)
        for (index, _) in yAxisData.enumerated() {
            var size = (yValue.height * CGFloat(index)) + margin
            
            if size == 0.0 {
                margin = yValue.fontHeight / 2
                size += margin
            }
            //yValue = self.bounds.height - self.y.scale(CGFloat(index)) - (y.axis.inset * 1.5)
            let label = UILabel(frame: CGRect(x: 0, y: size, width:y.axis.inset, height: y.axis.inset))
            label.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.caption2)
            label.textAlignment = .center
            label.text = configLabels.yLabels.values[index]
            self.addSubview(label)
        }
    }
    
    /**
     * Add line chart
     */
    open func addLine(_ data: [CGFloat]) {
        self.dataStore.append(data)
        self.setNeedsDisplay()
    }
    
    open func addLabels(_ data: [String]) {
        self.labelStore = data
        self.setNeedsDisplay()
    }
    
    //MARK: Clear
    /**
     * Make whole thing white again.
     */
    open func clearAll() {
        self.removeAll = true
        clear()
        self.setNeedsDisplay()
        self.removeAll = false
    }
    
    
    
    /**
     * Remove charts, areas and labels but keep axis and grid.
     */
    open func clear() {
        // clear data
        dataStore.removeAll()
        self.setNeedsDisplay()
    }
}



/**
 * DotCALayer
 */
class DotCALayer: CALayer {
    
    var innerRadius: CGFloat = 8
    var dotInnerColor = UIColor.black
    
    override init() {
        super.init()
    }
    
    override init(layer: Any) {
        super.init(layer: layer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSublayers() {
        super.layoutSublayers()
        let inset = self.bounds.size.width - innerRadius
        let innerDotLayer = CALayer()
        innerDotLayer.frame = self.bounds.insetBy(dx: inset/2, dy: inset/2)
        innerDotLayer.backgroundColor = dotInnerColor.cgColor
        innerDotLayer.cornerRadius = innerRadius / 2
        self.addSublayer(innerDotLayer)
    }
    
}





//MARK: - LineLayers
extension MLLineChart {
    /*
     Add by Michel
     */
    
    func getLineLayer(index: Int, path: UIBezierPath) -> CAShapeLayer {
        var colorLine: CGColor
        if lineColors.count > 0 {
            if index < lineColors.count {
                colorLine = lineColors[index].cgColor
            } else {
                colorLine = (lineColors.last?.cgColor)!
            }
        } else {
            colorLine = (colors.first?.cgColor)!
        }
        
        
        let layer = CAShapeLayer()
        layer.frame = self.bounds
        layer.path = path.cgPath
        layer.strokeColor = colorLine
        layer.fillColor = nil
        layer.lineWidth = lineWidth
        
        //animate line drawing
        if animation.enabled {
            let anim = CABasicAnimation(keyPath: "strokeEnd")
            anim.duration = animation.duration
            anim.fromValue = 0
            anim.toValue = 1
            layer.add(anim, forKey: "strokeEnd")
        }
        
        // add line layer to store
        lineLayerStore.append(layer)
        return layer
    }
}
