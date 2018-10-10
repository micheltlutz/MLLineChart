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

/// Delegate method
public protocol MLLineChartDelegate {
    func didSelectDataPoint(_ xValue: CGFloat, yValues: [CGFloat])
}

open class MLLineChart: UIView {
    
    static var name: String {
        get { return "MLLineChart" }
    }

    /// gap between each point
    let lineGap: CGFloat = 60.0

    /// preseved space at top of the chart
    let topSpace: CGFloat = 60.0

    /// preserved space at bottom of the chart to show labels along the Y axis
    let bottomSpace: CGFloat = 60.0

    /// The top most horizontal line in the chart will be 10% higher than the highest value in the chart
    let topHorizontalLine: CGFloat = 110.0 / 100.0

    ///Create a MLLabelConfig
    public var labelBottomConfig = MLLabelConfig()

    ///Define if chart is Curved default = false
    public var isCurved: Bool = false

    ///minPoint a min point on chart CGFloat
    public var minPoint: CGFloat?

    ///maxPoint a max point on chart CGFloat
    public var maxPoint: CGFloat?

    /// Active or desactive animation on dots
    public var animateDots: Bool = false

    /// Active or desactive dots default = false
    public var showDots: Bool = false

    /// Define dot color
    public var dotColor: UIColor?

    /// Dot inner Radius default = 12
    public var innerRadius: CGFloat = 12

    ///Dot outer Radius default = 1
    public var outerRadius: CGFloat = 1

    //Line chart Width default = 2
    public var lineWidth: CGFloat = 2

    ///Indicates if lines is colored
    public var hasColoredLines: Bool = false

    /// Define Bubble Label Distance default = 18
    public var bubbleLabelDistance: CGFloat = 18

    ///Define Gradient colors
    public var gradientColors: [CGColor] = [#colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.7).cgColor, UIColor.clear.cgColor] {
        didSet {
            gradientLayer.colors = gradientColors
        }
    }

    ///Define a MLLineChart Delegate
    open var delegate: MLLineChartDelegate?

    ///Define Data Line color
    public var lineColor: UIColor = .gray

    ///Define array of line colors
    public var linesColors: [UIColor]?

    ///Define default label color
    public var labelColor: UIColor = .gray

    ///Define default label font size
    public var labelSize: CGFloat = 11

    ///Define if shadow is active
    public var showShadows: Bool = true

    ///Define a data to draw Chart
    public var dataEntries: [MLPointEntry]? {
        didSet {
            self.setNeedsLayout()
        }
    }

    ///Indicates if lines is colored
    public var horizontalLinesColor: UIColor = .lightGray

    ///Indicates if show Horizontal Lines
    public var showHorizontalLines: Bool = true

    ///Indicates if show Labels
    public var showLabels: Bool = true

    ///Define a BubbleRadius
    public var showBubbleInfo: Bool = false

    /// Define Scroll Animation Time default = 1.0
    public var scrollAnimeteTime: Double = 1.0

    /// Dedine UIViewAnimationOptions Default .curveEaseIn
    public var animationStyle: UIView.AnimationOptions = .curveEaseIn

    ///Define a Bubble Configuration
    public var bubbleConfig: MLBubbleConfig?
    
    ///Indicates if Axis line is visible
    public var showAxisLine: Bool = false

    /// Contains the main line which represents the data
    private let dataLayer: CALayer = CALayer()

    /// To show the gradient below the main line
    private let gradientLayer: CAGradientLayer = CAGradientLayer()

    /// Contains dataLayer and gradientLayer
    private let mainLayer: CALayer = CALayer()

    /// Contains mainLayer and label for each data entry
    private let scrollView: UIScrollView = UIScrollView()

    /// Contains horizontal lines
    private let gridLayer: CALayer = CALayer()

    /// Contains horizontal lines
    private let frameLChart: CALayer = CALayer()

    /// Contains an array of MLDotCALayer
    private var dotLayers: [MLDotCALayer] = []

    /// Contains an array of Indexes datapoits
    private var bubblesVisible: [Int] = []

    /// An array of CGPoint on dataLayer coordinate system that the main line will go through. These points will be calculated from dataEntries array
    private var dataPoints: [CGPoint]?
    
    ///Optional MLAxisLine if showAxisLine = true, mlAxisLine is created
    private var mlAxisLine: MLAxisLine?

    override public init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    convenience init() {
        self.init(frame: CGRect.zero)
        translatesAutoresizingMaskIntoConstraints = false
        setupView()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }

    private func setupView() {
        mainLayer.addSublayer(dataLayer)
        scrollView.layer.addSublayer(mainLayer)
        scrollView.layer.addSublayer(gradientLayer)
        self.layer.addSublayer(gridLayer)
        self.addSubview(scrollView)
        addMLTapGestureRecognizer { (action) in
            if let touch = action?.location(in: self.scrollView) {
                self.handleTouchEvents(touchPoint: touch)
            }
        }
    }

    override open func layoutSubviews() {
        let height = self.frame.size.height - topSpace
        scrollView.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
        if let dataEntries = dataEntries {
            scrollView.contentSize = CGSize(width: CGFloat(dataEntries.count + 1) * lineGap, height: height)
            scrollView.contentInset = UIEdgeInsets(top: topSpace, left: 0, bottom: 0, right: 0)
            let mainLayerHeight = height
            mainLayer.frame = CGRect(x: 0, y: 0, width: CGFloat(dataEntries.count) * lineGap, height: mainLayerHeight)
            let dataLayerHeight = mainLayer.frame.height - topSpace - bottomSpace
            dataLayer.frame = CGRect(x: 0, y: topSpace, width: mainLayer.frame.width, height: dataLayerHeight)
            gradientLayer.frame = dataLayer.frame
            if let _ = minPoint, let _ = maxPoint {
                dataPoints = convertDataEntriesToPoints(entries: dataEntries)
            } else {
                dataPoints = convertDataEntriesToDinamicPoints(entries: dataEntries)
            }
            gridLayer.frame = CGRect(x: 0, y: topSpace + bottomSpace,
                                     width: self.frame.width, height: dataLayerHeight)
            clean()
            if showHorizontalLines { drawHorizontalLines() }
            if isCurved {
                drawCurvedChart()
            } else {
                if hasColoredLines {
                    drawChartColoredLines()
                } else {
                    drawChart()
                }
            }
            maskGradientLayer()
            if showAxisLine { createAxisLine(dataLayerHeight: dataLayerHeight) }
            if showLabels { drawLables() }
            if showDots { drawDots() }
        }
    }
    
    private func createAxisLine(dataLayerHeight: CGFloat) {
        mlAxisLine = MLAxisLine(frame: CGRect(x: 0, y: topSpace + bottomSpace,
                                              width: self.frame.width,
                                              height: dataLayerHeight),
                                thickness: lineWidth,
                                color: lineColor)
        self.addSubview(mlAxisLine!)
        self.sendSubviewToBack(mlAxisLine!)
    }

    /*
     Scroll chart to the end contentOffset.x
     */
    public func scrollToTheEnd() {
        DispatchQueue.main.async {
            UIView.animate(withDuration: self.scrollAnimeteTime, delay: 0, options: self.animationStyle, animations: {
                self.scrollView.contentOffset.x = self.scrollView.contentSize.width - self.scrollView.bounds.size.width
            }, completion: nil)
        }
    }

    /**
     Convert an array of MLPointEntry to an array of CGPoint on dataLayer coordinate system
     */
    private func convertDataEntriesToDinamicPoints(entries: [MLPointEntry]) -> [CGPoint] {
        if let max = entries.max()?.value,
            let min = entries.min()?.value {

            var result: [CGPoint] = []
            let minMaxRange: CGFloat = CGFloat(max - min) * topHorizontalLine

            for i in 0..<entries.count {
                let height = dataLayer.frame.height * (1 - ((CGFloat(entries[i].value) - CGFloat(min)) / minMaxRange))
                let point = CGPoint(x: CGFloat(i)*lineGap + 40, y: height)
                result.append(point)
            }
            return result
        }
        return []
    }

    /**
     Convert an array of MLPointEntry to an array of CGPoint on dataLayer coordinate system
     */
    private func convertDataEntriesToPoints(entries: [MLPointEntry]) -> [CGPoint] {
        if let max = maxPoint,
            let min = minPoint {

            var result: [CGPoint] = []
            let minMaxRange: CGFloat = CGFloat(max - min) * topHorizontalLine

            for i in 0..<entries.count {
                let height = dataLayer.frame.height * (1 - ((CGFloat(entries[i].value) - CGFloat(min)) / minMaxRange))
                let point = CGPoint(x: CGFloat(i)*lineGap + 40, y: height)
                result.append(point)
            }
            return result
        }
        return []
    }

    /**
     Draw a zigzag line connecting all points in dataPoints
     */
    private func drawChart() {
        if let dataPoints = dataPoints,
            dataPoints.count > 0,
            let path = createPath() {
            let lineLayer = CAShapeLayer()
            lineLayer.path = path.cgPath
            lineLayer.strokeColor = lineColor.cgColor
            lineLayer.fillColor = UIColor.clear.cgColor
            dataLayer.addSublayer(lineLayer)
        }
    }

    /**
     Create a zigzag bezier path that connects all points in dataPoints
     */
    private func createPath() -> UIBezierPath? {
        guard let dataPoints = dataPoints, dataPoints.count > 0 else {
            return nil
        }
        let path = UIBezierPath()
        path.move(to: dataPoints[0])

        for i in 1..<dataPoints.count {
            path.addLine(to: dataPoints[i])
        }
        return path
    }

    /**
     Draw a curved line connecting all points in dataPoints
     */
    private func drawCurvedChart() {
        guard let dataPoints = dataPoints, dataPoints.count > 0 else {
            return
        }
        if let path = MLCurveAlgorithm.shared.createCurvedPath(dataPoints) {
            let lineLayer = CAShapeLayer()
            lineLayer.path = path.cgPath
            lineLayer.strokeColor = lineColor.cgColor
            lineLayer.fillColor = UIColor.clear.cgColor
            lineLayer.lineWidth = lineWidth
            applyShadow(layer: lineLayer)
            dataLayer.addSublayer(lineLayer)
        }
    }

    /**
     Create a gradient layer below the line that connecting all dataPoints
     */
    private func maskGradientLayer() {
        if let dataPoints = dataPoints,
            dataPoints.count > 0 {

            let path = UIBezierPath()
            path.move(to: CGPoint(x: dataPoints[0].x, y: dataLayer.frame.height))
            path.addLine(to: dataPoints[0])
            if isCurved,
                let curvedPath = MLCurveAlgorithm.shared.createCurvedPath(dataPoints) {
                path.append(curvedPath)
            } else if let straightPath = createPath() {
                path.append(straightPath)
            }
            path.addLine(to: CGPoint(x: dataPoints[dataPoints.count-1].x, y: dataLayer.frame.height))
            path.addLine(to: CGPoint(x: dataPoints[0].x, y: dataLayer.frame.height))

            let maskLayer = CAShapeLayer()
            maskLayer.path = path.cgPath
            maskLayer.fillColor = lineColor.cgColor
            maskLayer.strokeColor = UIColor.clear.cgColor
            maskLayer.lineWidth = 0.0

            gradientLayer.mask = maskLayer
        }
    }
    // MARK: Labels
    /**
     Create titles at the bottom for all entries showed in the chart
     */
    private func drawLables() {
        if let dataEntries = dataEntries,
            dataEntries.count > 0 {
            for (i, dataEntry) in dataEntries.enumerated() {

            //}
            //for i in 0..<dataEntries.count {
                let textLayer = CATextLayer()
                let width = labelBottomConfig.width!
                let height = labelBottomConfig.height!
                textLayer.backgroundColor = labelBottomConfig.backgroundColor!.cgColor
                textLayer.foregroundColor = labelBottomConfig.color!.cgColor
                if labelBottomConfig.rounded! {
                    textLayer.cornerRadius = height / 2
                }
                textLayer.frame = CGRect(x: lineGap*CGFloat(i+1) - lineGap/2,
                                         y: mainLayer.frame.size.height - bottomSpace/2 - 8,
                                         width: width, height: height)

                textLayer.alignmentMode = CATextLayerAlignmentMode.center
                textLayer.contentsScale = UIScreen.main.scale
                textLayer.font = CTFontCreateWithName(UIFont.systemFont(ofSize: 0).fontName as CFString, 0, nil)
                textLayer.fontSize = labelBottomConfig.fontSize!
                //textLayer.string = dataEntries[i].label
                textLayer.string = dataEntry.label
                mainLayer.addSublayer(textLayer)
            }
        }
    }

    /**
     Create horizontal lines (grid lines) and show the value of each line
     */
    private func drawHorizontalLines() {
        guard let dataEntries = dataEntries else {
            return
        }
        //var gridValues: [CGFloat] = [CGFloat](repeating: 1, count: dataEntries.count)
        var gridValues: [CGFloat]? = nil
        if dataEntries.count < 4 && dataEntries.count > 0 {
            gridValues = [0, 1]
        } else if dataEntries.count >= 4 {
            gridValues = [0, 0.25, 0.5, 0.75, 1]
        }
        if let gridValues = gridValues {
            for value in gridValues {
                let height = value * gridLayer.frame.size.height

                let path = UIBezierPath()
                path.move(to: CGPoint(x: 0, y: height))
                path.addLine(to: CGPoint(x: gridLayer.frame.size.width, y: height))

                let lineLayer = CAShapeLayer()
                lineLayer.path = path.cgPath
                lineLayer.fillColor = UIColor.clear.cgColor
                lineLayer.strokeColor = horizontalLinesColor.cgColor
                lineLayer.lineWidth = 0.5
                if (value > 0.0 && value < 1.0) {
                    lineLayer.lineDashPattern = [4, 4]
                }

                gridLayer.addSublayer(lineLayer)

                var minMaxGap:CGFloat = 0
                var lineValue:Int = 0
                if let max = dataEntries.max()?.value,
                    let min = dataEntries.min()?.value {
                    minMaxGap = CGFloat(max - min) * topHorizontalLine
                    lineValue = Int((1-value) * minMaxGap) + Int(min)
                }

                let textLayer = CATextLayer()
                textLayer.frame = CGRect(x: 4, y: height, width: 50, height: 16)
                textLayer.foregroundColor = labelColor.cgColor
                textLayer.backgroundColor = UIColor.clear.cgColor
                textLayer.contentsScale = UIScreen.main.scale
                textLayer.font = CTFontCreateWithName(UIFont.systemFont(ofSize: 0).fontName as CFString, 0, nil)
                textLayer.fontSize = labelSize + 1
                textLayer.string = "\(lineValue)"
                gridLayer.addSublayer(textLayer)
            }
        }
    }

    private func clean() {
        mainLayer.sublayers?.forEach({
            if $0 is CATextLayer {
                $0.removeFromSuperlayer()
            }
        })
        dataLayer.sublayers?.forEach({$0.removeFromSuperlayer()})
        gridLayer.sublayers?.forEach({$0.removeFromSuperlayer()})
    }
    /**
     Draw a zigzag colored lines connecting all points in dataPoints
     */
    private func drawChartColoredLines() {
        if let dataPoints = dataPoints,
            dataPoints.count > 0 {
            var lastPoint = CGPoint(x: 0, y: 0)
            var strokeColorLine = UIColor.white.cgColor
            for i in 1..<dataPoints.count {
//                if i == 0 {
//                    lastPoint = dataPoints[0]
//                } else {
                    lastPoint = dataPoints[i - 1]
//                }
                if let path = createLinePath(initialPoint:lastPoint, moveToPoint: dataPoints[i]){
                    let lineLayer = CAShapeLayer()
                    lineLayer.lineWidth = lineWidth
                    lineLayer.path = path.cgPath
                    if hasColoredLines { strokeColorLine = getColorLine(by: i) }
                    lineLayer.strokeColor = strokeColorLine
                    lineLayer.fillColor = UIColor.clear.cgColor
                    dataLayer.addSublayer(lineLayer)
                }
            }
        }
    }

    /**
     Get color line by datePoint index if linesColors no range from index return a last color from array
     */
    private func getColorLine(by index: Int) -> CGColor {
        if let unwrappedDataEntries = dataEntries {
            if let color = unwrappedDataEntries[index].color {
                return color.cgColor
            } else {
                return Helpers.randomColors[Int(arc4random_uniform(UInt32(Helpers.randomColors.count)))].cgColor
            }
        } else {
            return Helpers.randomColors[Int(arc4random_uniform(UInt32(Helpers.randomColors.count)))].cgColor
        }
    }

    /**
     Create a single bezier path that connects all points in dataPoints
     */
    private func createLinePath(initialPoint: CGPoint, moveToPoint: CGPoint) -> UIBezierPath? {
        let path = UIBezierPath()
        path.move(to: initialPoint)
        path.addLine(to: moveToPoint)
        return path
    }
}
// MARK: Dots
extension MLLineChart {
    /**
     Create Dots on line points
     */
    fileprivate func drawDots() {
        if let dataPoints = dataPoints {
            for dataPoint in dataPoints {
                let xValue = dataPoint.x - outerRadius / 2
                let yValue = (dataPoint.y + lineGap) - (outerRadius * 2)
                let dotLayer = MLDotCALayer()
                if let unwrappedDotColor = dotColor {
                    dotLayer.dotInnerColor = unwrappedDotColor
                }
                dotLayer.innerRadius = innerRadius
                dotLayer.cornerRadius = outerRadius / 2
                dotLayer.frame = CGRect(x: xValue, y: yValue, width: outerRadius, height: outerRadius)
                dotLayers.append(dotLayer)
                mainLayer.addSublayer(dotLayer)
                if animateDots {
                    let anim = CABasicAnimation(keyPath: "opacity")
                    anim.duration = 1.0
                    anim.fromValue = 0
                    anim.toValue = 1
                    dotLayer.add(anim, forKey: "opacity")
                }
            }
        }
    }
}
// MARK: Bubble
extension MLLineChart {
    fileprivate func checkBubbleIndex(index: Int) {
        if !bubblesVisible.contains(index) {
            bubblesVisible.append(index)
            drawTopBubble(index: index)
        }
    }
    /*
     Draw Top Bubble inside chart over Dot
     */
    fileprivate func drawTopBubble(index: Int) {
        var bubbleConfig: MLBubbleConfig!
        if let globalBubbleConfig = bubbleConfig { bubbleConfig = globalBubbleConfig }
        if let dataPoints = dataPoints {
            let dataEntry = dataEntries![index]
            if let entryBubbleConfig = dataEntry.bubbleConfig {
                bubbleConfig = entryBubbleConfig
            }
            /// This magicValue helps to create 2 control points that can be used to draw a quater of a
            ///  circle using Bezier curve function
            let magicValue: CGFloat = 0.552284749831 * bubbleConfig.radius

            let xPos = dataPoints[index].x - bubbleConfig.radius
            let yPos = dataPoints[index].y - 8
            let color = bubbleConfig.color!


            let diffTouchAreaX = CGFloat((bubbleConfig.radius / 2) - 5)
            let diffTouchAreaY = CGFloat(bubbleConfig.radius)

            let view = UIView(frame: CGRect(x: xPos - diffTouchAreaX, y: yPos - diffTouchAreaY,
                                            width: (bubbleConfig.radius * 2) + bubbleConfig.radius / 2,
                                            height: (bubbleConfig.radius * 2) + bubbleConfig.radius))
            view.addMLTapGestureRecognizer { (action) in
                let bubbleIndex = self.bubblesVisible.index(of: index)
                self.bubblesVisible.remove(at: bubbleIndex!)
                view.removeFromSuperview()
            }

            let xPosP = CGFloat(diffTouchAreaX)
            let yPosP = CGFloat(diffTouchAreaY)

            let segment1Path = UIBezierPath()
            segment1Path.move(to: CGPoint(x: xPosP, y: yPosP))
            segment1Path.addCurve(to: CGPoint(x: xPosP+bubbleConfig.radius, y: yPosP-bubbleConfig.radius),
                                  controlPoint1: CGPoint(x: xPosP, y: yPosP-magicValue),
                                  controlPoint2: CGPoint(x: xPosP+bubbleConfig.radius-magicValue, y: yPosP-bubbleConfig.radius))

            segment1Path.addLine(to: CGPoint(x: xPosP+bubbleConfig.radius, y: yPosP))
            let segment1Layer = CAShapeLayer()
            segment1Layer.path = segment1Path.cgPath
            segment1Layer.fillColor = color.cgColor
            segment1Layer.strokeColor = color.cgColor
            segment1Layer.lineWidth = 0.0
            view.layer.addSublayer(segment1Layer)

            let segment2Path = UIBezierPath()
            segment2Path.move(to: CGPoint(x: xPosP+bubbleConfig.radius, y: yPosP-bubbleConfig.radius))
            segment2Path.addCurve(to: CGPoint(x: xPosP+bubbleConfig.radius*2, y: yPosP),
                                  controlPoint1: CGPoint(x: xPosP+bubbleConfig.radius+magicValue, y: yPosP-bubbleConfig.radius),
                                  controlPoint2: CGPoint(x: xPosP+bubbleConfig.radius*2, y: yPosP-magicValue))

            segment2Path.addLine(to: CGPoint(x: xPosP+bubbleConfig.radius, y: yPosP))
            let segment2Layer = CAShapeLayer()
            segment2Layer.path = segment2Path.cgPath
            segment2Layer.fillColor = color.cgColor
            segment2Layer.strokeColor = color.cgColor
            segment2Layer.lineWidth = 0.0
            view.layer.addSublayer(segment2Layer)

            let segment3Path = UIBezierPath()
            segment3Path.move(to: CGPoint(x: xPosP, y: yPosP))
            segment3Path.addCurve(to: CGPoint(x: xPosP+bubbleConfig.radius, y: yPosP+bubbleConfig.radius*1.5),
                                  controlPoint1: CGPoint(x: xPosP, y: yPosP+magicValue),
                                  controlPoint2: CGPoint(x: xPosP+bubbleConfig.radius-magicValue, y: yPosP+bubbleConfig.radius))
            segment3Path.addLine(to: CGPoint(x: xPosP+bubbleConfig.radius, y: yPosP))

            let segment3Layer = CAShapeLayer()
            segment3Layer.path = segment3Path.cgPath
            segment3Layer.fillColor = color.cgColor
            segment3Layer.strokeColor = color.cgColor
            segment3Layer.lineWidth = 0.0
            view.layer.addSublayer(segment3Layer)

            let segment4Path = UIBezierPath()
            segment4Path.move(to: CGPoint(x: xPosP+bubbleConfig.radius*2, y: yPosP))
            segment4Path.addCurve(to: CGPoint(x: xPosP+bubbleConfig.radius, y: yPosP+bubbleConfig.radius*1.5),
                                  controlPoint1: CGPoint(x: xPosP+bubbleConfig.radius*2, y: yPosP+magicValue),
                                  controlPoint2: CGPoint(x: xPosP+bubbleConfig.radius+magicValue, y: yPosP+bubbleConfig.radius))
            segment4Path.addLine(to: CGPoint(x: xPosP+bubbleConfig.radius, y: yPosP))

            let segment4Layer = CAShapeLayer()
            segment4Layer.path = segment4Path.cgPath
            segment4Layer.fillColor = color.cgColor
            segment4Layer.strokeColor = color.cgColor
            segment4Layer.lineWidth = 0.0
            view.layer.addSublayer(segment4Layer)

            if showShadows {
                view.layer.shouldRasterize = true
                applyShadow(layer: view.layer)
            }

            drawTextBubbleValue(view: view,xPos: xPosP, yPos: yPosP, bubbleConfig: bubbleConfig)
            drawTextBubbleLabel(view: view, xPos: xPosP, yPos: yPosP, bubbleConfig: bubbleConfig)
            scrollView.addSubview(view)
        }
    }

    fileprivate func applyShadow(layer: CALayer) {
        let color = UIColor(red: 38/255, green: 46/255, blue: 48/255, alpha: 0.5)
        layer.shadowColor = color.cgColor
        layer.shadowRadius = 4
        layer.shadowOpacity = 1
    }

    fileprivate func applyShadow(layer: CAShapeLayer) {
        let color = UIColor(red: 38/255, green: 46/255, blue: 48/255, alpha: 0.4)
        layer.shadowColor = color.cgColor
        layer.shadowRadius = 2
        layer.shadowOpacity = 1
    }
    /*
     Draw Text Value inseide Bubble
     */
    fileprivate func drawTextBubbleValue(view: UIView, xPos: CGFloat, yPos: CGFloat, bubbleConfig: MLBubbleConfig) {
        let textLayer = CATextLayer()
        textLayer.frame = CGRect(x: xPos, y: yPos-(bubbleConfig.radius)+4,
                                 width: bubbleConfig.radius*2,
                                 height: bubbleConfig.radius*2)
        textLayer.foregroundColor = bubbleConfig.value.color!.cgColor
        textLayer.backgroundColor = UIColor.clear.cgColor
        textLayer.alignmentMode = CATextLayerAlignmentMode.center
        textLayer.contentsScale = UIScreen.main.scale
        var value = bubbleConfig.value
        let font = value.createFont()
        textLayer.font = font.ctfont
        textLayer.fontSize = font.size
        textLayer.string = bubbleConfig.value.value
        view.layer.addSublayer(textLayer)
    }

    /*
     Draw Text Label inseide Bubble
     */
    fileprivate func drawTextBubbleLabel(view: UIView, xPos: CGFloat, yPos: CGFloat, bubbleConfig: MLBubbleConfig) {
        let textLayer = CATextLayer()
        textLayer.frame = CGRect(x: xPos, y: yPos-(bubbleConfig.radius / 2) + bubbleLabelDistance,
                                 width: bubbleConfig.radius * 2,
                                 height: bubbleConfig.radius * 2)
        textLayer.foregroundColor = bubbleConfig.label.color!.cgColor
        textLayer.backgroundColor = UIColor.clear.cgColor
        textLayer.alignmentMode = CATextLayerAlignmentMode.center
        textLayer.contentsScale = UIScreen.main.scale
        var label = bubbleConfig.label
        let font = label.createFont()
        textLayer.font = font.ctfont
        textLayer.fontSize = font.size
        textLayer.string = label.value
        view.layer.addSublayer(textLayer)
    }
}
//extension MLLineChart Handles
extension MLLineChart {
    /**
     * Handle touch events.
     */
    @objc fileprivate func handleTouchEvents(touchPoint: CGPoint) {
        let xValue = touchPoint.x
        let yValue = touchPoint.y
        if dotLayers.count > 0 {
            for (index, dotLayer) in dotLayers.enumerated() {
                var flagBreakX = false
                var flagBreakY = false

                let dotLayerXErrPlus = dotLayer.position.x + 12
                let dotLayerXErrMin = dotLayer.position.x - 12
                let dotLayerYErrPlus = dotLayer.position.y + 12
                let dotLayerYErrMin = dotLayer.position.y - 12

                if dotLayer.position.x...dotLayerXErrPlus ~= xValue || dotLayerXErrMin...dotLayer.position.x ~= xValue {
                    flagBreakX = true
                } else {
                    flagBreakX = false
                }
                if dotLayer.position.y...dotLayerYErrPlus ~= yValue || dotLayerYErrMin...dotLayer.position.y ~= yValue {
                    flagBreakY = true
                } else {
                    flagBreakY = false
                }
                if flagBreakX && flagBreakY {
                    checkBubbleIndex(index: index)
                    break
                }
            }
        }
        delegate?.didSelectDataPoint(touchPoint.x, yValues: [touchPoint.y])
    }
}
