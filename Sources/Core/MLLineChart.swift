////MIT License
////
////Copyright (c) 2019 Michel Anderson Lüz Teixeira
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

import Foundation
import UIKit

///Tuple for min and max points value
public typealias MLLimitPoints = (min: CGFloat, max: CGFloat)
///Preseved space at top and bottom of the chart
public typealias MLMarginSpaces = (top: CGFloat, bottom: CGFloat)

open class MLLineChart: UIView {
    static let name = "MLLineChart"
    /// Define height margin between chart and view labels
    public var marginLabels: CGFloat = 16
    /// Preseved space at top and bottom of the chart
    public var marginSpaces: MLMarginSpaces = (top: 0.0, bottom: 0.0)
    /// The top most horizontal line in the chart will be 10% higher than the highest value in the chart
    static let topHorizontalLine: CGFloat = 110.0 / 100.0
    /// Define limit points value
    public var limitPoints: MLLimitPoints?
    /// Line chart Width default = 2
    public var lineWidth: CGFloat = 2
    /// Define a MLLineChart Delegate
    open var delegate: MLDelegate?
    /// Define Data Line color
    public var lineColor: UIColor = .gray
    /// Define if shadow is active
    public var showShadows: Bool = true
    /// Indicates if show Labels
    public var showLabels: Bool = true
    /// Indicates if Axis line is visible
    public var showAxisLine: Bool = false
    /// Indicates gradient colors
    public var gradienLinesColors: [CGColor] = []
    /// Labels Bottom config
    public var configLabelsBottom = MLLabelConfig()
    /// Data Controller
    public var dataController: MLDataController!
    /// Contains the colors for points without zero
    private var dataColorsNonZeros: [UIColor] = []
    /// Contains dot configurations
    public var dotConfig: MLDotConfig?
    /// Contains an array of MLDotLayer
    private var dotLayers: [MLDotLayer] = []
    /// Contains an array of Indexes datapoits
    private var bubblesVisible: [Int] = []

    // MARK: Data propreties

    /// Define a data to draw or redraw Chart
    public var dataEntries: [MLPointEntry]? {
        didSet {
            self.setNeedsLayout()
        }
    }
    /**
     An array of CGPoint on dataLayer coordinate system that the main line will go through.
     These points will be calculated from dataEntries array
     */
    public var dataPoints: [CGPoint]?
    /// Optional cncAxisLine if showAxisLine = true, mlAxisLine is created
    private var cncAxisLine: MLAxisLine?
    /// Indicates if MLAxisLine is colored background
    public var dataAreaBackgroundColor: UIColor = .clear
    /// Indicates if MLAxisLine is colored background
    public var axisBackgroundColor: UIColor = .clear

    // MARK: Layers

    /// Contains the main line which represents the data
    public let dataLayer = CALayer()
    internal let axisLayer = CALayer()
    internal let bubbleLayer = CALayer()
    internal var bubblePoints: [CGPoint] = []
    public let matrixLayer = CALayer()

    /// Sizes
    public private(set) var width: CGFloat!
    public private(set) var height: CGFloat!

    override public init(frame: CGRect) {
        super.init(frame: frame)
        setupChart()
    }

    convenience init() {
        self.init(frame: CGRect.zero)
        translatesAutoresizingMaskIntoConstraints = false
        setupChart()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupChart()
    }

    private func getColorLineNonZeros(by index: Int) -> CGColor {
        return dataColorsNonZeros[index].cgColor
    }

    // MARK: Data Points

    /**
     This method is override by MLDiary
     */
    open func makeDataPoints(dataEntries: [MLPointEntry]) {
        dataController = MLDataController(entries: dataEntries,
                                           height: dataLayer.frame.height,
                                           width: dataLayer.frame.width)
        dataPoints = dataController.makePoints()
    }

    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        clearBubbles()
    }
}

// MARK: Draws/Setups
extension MLLineChart {
    private func setupChart() {
        setupMainLayer()
    }

    private func setupMainLayer() {
        layer.addSublayer(dataLayer)
        layer.addSublayer(bubbleLayer)
    }

    private func draw() {
        height = frame.size.height - marginSpaces.top - marginSpaces.bottom
        width = frame.size.width
        if let dataEntries = dataEntries {
            dataLayer.frame = CGRect(x: 0, y: 0,
                                     width: width,
                                     height: height - marginLabels)
            bubbleLayer.frame = CGRect(x: 0, y: 0,
                                       width: width,
                                       height: height - marginLabels)
            matrixLayer.frame = CGRect(x: 0, y: 0,
                                       width: width,
                                       height: height - marginLabels)
            drawMatrixLayers()
            dataLayer.backgroundColor = dataAreaBackgroundColor.cgColor
            makeDataPoints(dataEntries: dataEntries)
            drawCurvedChart()
            if showLabels { drawLabels(dataEntries: dataEntries) }
            if showAxisLine { drawAxisLine(dataLayerHeight: dataLayer.frame.height) }
            if let dotConfig = dotConfig { drawDots(with: dotConfig) }
            addMLTapGestureRecognizer { (action) in
                if let touch = action?.location(in: self) {
                    self.handleTouchEvents(touchPoint: touch)
                }
            }
        }
    }

    func drawMatrixLayers() {
        let widthShape: CGFloat = 8
        let heightShape: CGFloat = 24
        var spaceLine: CGFloat = 0
        for line in 0..<7 {
            if line != 0 && line != 6 { spaceLine = 8 }
            for column in 0..<31{
                let rectLayer = CAShapeLayer()
                let path = UIBezierPath(rect: CGRect(x: CGFloat(column) * widthShape,
                                                     y: (CGFloat(line) * (heightShape + spaceLine)),
                                                     width: widthShape, height: heightShape))
                rectLayer.path = path.cgPath
                rectLayer.strokeColor = UIColor.gray.cgColor
                rectLayer.fillColor = UIColor.clear.cgColor
                rectLayer.lineWidth = lineWidth / 2
                matrixLayer.addSublayer(rectLayer)
            }
        }
        matrixLayer.isHidden = true
        layer.addSublayer(matrixLayer)
    }

    /**
     Draw a curved line connecting all points in dataPoints
     */
    private func drawCurvedChart() {
        guard let dataPoints = dataPoints, dataPoints.count > 0 else { return }
        if let path = MLCurveAlgorithm.shared.createCurvedPath(dataPoints) {
            let lineLayer = CAShapeLayer()
            lineLayer.path = path.cgPath
            lineLayer.strokeColor = lineColor.cgColor
            lineLayer.fillColor = UIColor.clear.cgColor
            lineLayer.lineWidth = lineWidth

            if gradienLinesColors.count > 0 {
                let gradient = createGradientToStroke()
                gradient.mask = lineLayer
                MLLayersShadow.applyShadow(layer: lineLayer)
                dataLayer.addSublayer(gradient)
            } else {
                MLLayersShadow.applyShadow(layer: lineLayer)
                dataLayer.addSublayer(lineLayer)
            }
        }
    }

    private func drawLabels(dataEntries: [MLPointEntry]) {
        let labelsView = MLLabelView(dataEntries: dataEntries,
                                      width: width,
                                      height: marginLabels,
                                      positionY: (frame.size.height - marginLabels) + 4,
                                      labelConfig: configLabelsBottom)
        self.addSubview(labelsView)
    }

    private func drawAxisLine(dataLayerHeight: CGFloat) {
        let axisFrame = CGRect(x: -lineWidth,
                               y: lineWidth,
                               width: width + lineWidth,
                               height: (height - marginLabels) + lineWidth)

        cncAxisLine = MLAxisLine(frame: axisFrame,
                                  thickness: lineWidth,
                                  color: lineColor,
                                  backgroundColor: axisBackgroundColor)
        self.addSubview(cncAxisLine!)
        self.sendSubviewToBack(cncAxisLine!)
    }

    private func drawDots(with dotConfig: MLDotConfig) {
        if let dataPoints = dataPoints {
            for dataPoint in dataPoints {
                let xValue = dataPoint.x - dotConfig.outerRadius / 2
                let yValue = dataPoint.y - dotConfig.outerRadius / 2
                let dotLayer = MLDotLayer()
                dotLayer.dotInnerColor = dotConfig.color
                dotLayer.innerRadius = dotConfig.innerRadius
                dotLayer.cornerRadius = dotConfig.outerRadius / 2
                dotLayer.frame = CGRect(x: xValue, y: yValue,
                                        width: dotConfig.outerRadius,
                                        height: dotConfig.outerRadius)
                dotLayers.append(dotLayer)
                if showShadows { MLLayersShadow.applyShadow(layer: dotLayer) }
                if gradienLinesColors.count > 0 {
                    let gradient = createGradientToStroke()
                    gradient.mask = dotLayer
                    MLLayersShadow.applyShadow(layer: dotLayer)
                    dataLayer.addSublayer(gradient)
                } else {
                    MLLayersShadow.applyShadow(layer: dotLayer)
                    dataLayer.addSublayer(dotLayer)
                }
                if dotConfig.animate {
                    MLAnimateLayer.animateDots(dotLayer: dotLayer)
                }
            }
        }
    }

    // MARK: Gradients

    private func createGradientToStroke() -> CAGradientLayer {
        let gradient = CAGradientLayer()
        gradient.frame = dataLayer.frame
        gradient.colors = gradienLinesColors
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 0, y: 1)
        return gradient
    }

    override open func layoutSubviews() {
        clean()
        draw()
    }

    private func clean() {
        dotLayers = []
        dataPoints = []
        bubblesVisible = []
        for view in subviews {
            view.removeFromSuperview()
        }

        layer.sublayers?.forEach({
            if $0 is CATextLayer {
                $0.removeFromSuperlayer()
            }
        })

        dataLayer.sublayers?.forEach({$0.removeFromSuperlayer()})
        bubbleLayer.sublayers?.forEach({$0.removeFromSuperlayer()})
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

            let view = MLBubbleView(bubbleConfig: bubbleConfig, dataPoint: dataPoints[index])
            view.addMLTapGestureRecognizer { (action) in
                let bubbleIndex = self.bubblesVisible.index(of: index)
                view.removeFromSuperview()
                self.bubblesVisible.remove(at: bubbleIndex!)
            }

            if showShadows {
                view.layer.shouldRasterize = true
                MLLayersShadow.applyShadow(layer: view.layer)
            }

            bubblePoints.append(view.layer.position)
            bubbleLayer.addSublayer(view.layer)
        }
    }

    func clearBubbles() {
        guard let layers = bubbleLayer.sublayers else { return }
        bubblesVisible = []
        for layer in layers {
            layer.removeFromSuperlayer()
        }
    }
}

// MARK: Dots handleTouchEvents

extension MLLineChart {
    /**
     * Handle touch events.
     */
    @objc fileprivate func handleTouchEvents(touchPoint: CGPoint) {
        clearBubbles()
        let xValue = touchPoint.x
        let yValue = touchPoint.y
        if dotLayers.count > 0 {
            for (index, dotLayer) in dotLayers.enumerated() {
                var flagBreakX = false
                var flagBreakY = false

                let dotLayerXErrPlus = dotLayer.position.x + 16
                let dotLayerXErrMin = dotLayer.position.x - 16
                let dotLayerYErrPlus = dotLayer.position.y + 16
                let dotLayerYErrMin = dotLayer.position.y - 16

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
