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

import UIKit

class MLBubbleView: UIView {
    private var bubbleConfig: MLBubbleConfig!
    private var dataPoint: CGPoint = CGPoint()
    private let magicConstant: CGFloat = 0.552284749831
    private var segmentAreaX: CGFloat = 0
    private var segmentAreaY: CGFloat = 0
    private var labelValue: UILabel!
    private var labelLabel: UILabel!
    /**
     This magicValue helps to create 2 control points that can be used to draw a quater of a
     circle using Bezier curve function
     */
    private var magicValue: CGFloat!

    init(bubbleConfig: MLBubbleConfig, dataPoint: CGPoint) {
        self.bubbleConfig = bubbleConfig
        self.dataPoint = dataPoint
        self.magicValue = magicConstant * bubbleConfig.radius
        let xPos = dataPoint.x - self.bubbleConfig.radius
        let yPos = dataPoint.y - (self.bubbleConfig.radius * 2.7)
        segmentAreaX = CGFloat((bubbleConfig.radius / 2) - 5)
        segmentAreaY = CGFloat(bubbleConfig.radius)
        super.init(frame: CGRect(x: xPos - segmentAreaX, y: yPos,
                                 width: (bubbleConfig.radius * 2) + bubbleConfig.radius / 2,
                                 height: (bubbleConfig.radius * 2) + bubbleConfig.radius))
        self.make()
    }

    private func make() {
        layer.addSublayer(segment1())
        layer.addSublayer(segment2())
        layer.addSublayer(segment3())
        layer.addSublayer(segment4())
        layer.contentsScale = UIScreen.main.scale
        layer.rasterizationScale = UIScreen.main.scale
        drawTextBubbleValue()
        drawTextBubbleLabel()
    }

    private func segment1() -> CAShapeLayer {
        let segmentPath = UIBezierPath()
        segmentPath.move(to: CGPoint(x: segmentAreaX, y: segmentAreaY))
        let cPoint1 = CGPoint(x: segmentAreaX, y: segmentAreaY - magicValue)
        let cPoint2 = CGPoint(x: segmentAreaX + bubbleConfig.radius - magicValue,
                              y: segmentAreaY - bubbleConfig.radius)

        segmentPath.addCurve(to: CGPoint(x: segmentAreaX + bubbleConfig.radius,
                                         y: segmentAreaY - bubbleConfig.radius),
                             controlPoint1: cPoint1, controlPoint2: cPoint2)

        segmentPath.addLine(to: CGPoint(x: segmentAreaX + bubbleConfig.radius, y: segmentAreaY))
        return segmentLayerBase(path: segmentPath)
    }

    private func segment2() -> CAShapeLayer {
        let segmentPath = UIBezierPath()
        segmentPath.move(to: CGPoint(x: segmentAreaX + bubbleConfig.radius,
                                     y: segmentAreaY - bubbleConfig.radius))

        let cPoint1 = CGPoint(x: segmentAreaX + bubbleConfig.radius + magicValue,
                              y: segmentAreaY - bubbleConfig.radius)
        let cPoint2 = CGPoint(x: segmentAreaX + bubbleConfig.radius * 2,
                              y: segmentAreaY - magicValue)

        segmentPath.addCurve(to: CGPoint(x: segmentAreaX + bubbleConfig.radius * 2, y: segmentAreaY),
                              controlPoint1: cPoint1, controlPoint2: cPoint2)

        segmentPath.addLine(to: CGPoint(x: segmentAreaX + bubbleConfig.radius, y: segmentAreaY))
        return segmentLayerBase(path: segmentPath)
    }

    private func segment3() -> CAShapeLayer {
        let segmentPath = UIBezierPath()
        segmentPath.move(to: CGPoint(x: segmentAreaX, y: segmentAreaY))
        let cPoint1 = CGPoint(x: segmentAreaX, y: segmentAreaY + magicValue)
        let cPoint2 = CGPoint(x: segmentAreaX + bubbleConfig.radius - magicValue,
                              y: segmentAreaY + bubbleConfig.radius)
        segmentPath.addCurve(to: CGPoint(x: segmentAreaX + bubbleConfig.radius,
                                         y: segmentAreaY + bubbleConfig.radius * 1.5),
                              controlPoint1: cPoint1,
                              controlPoint2: cPoint2)
        segmentPath.addLine(to: CGPoint(x: segmentAreaX + bubbleConfig.radius, y: segmentAreaY))
        return segmentLayerBase(path: segmentPath)
    }

    private func segment4() -> CAShapeLayer {
        let segmentPath = UIBezierPath()

        segmentPath.move(to: CGPoint(x: segmentAreaX + bubbleConfig.radius * 2,
                                     y: segmentAreaY))
        let cPoint1 = CGPoint(x: segmentAreaX + bubbleConfig.radius * 2,
                              y: segmentAreaY + magicValue)
        let cPoint2 = CGPoint(x: segmentAreaX + bubbleConfig.radius + magicValue,
                              y: segmentAreaY + bubbleConfig.radius)
        segmentPath.addCurve(to: CGPoint(x: segmentAreaX + bubbleConfig.radius,
                                         y: segmentAreaY + bubbleConfig.radius * 1.5),
                              controlPoint1: cPoint1, controlPoint2: cPoint2)
        segmentPath.addLine(to: CGPoint(x: segmentAreaX + bubbleConfig.radius, y: segmentAreaY))
        return segmentLayerBase(path: segmentPath)
    }

    private func segmentLayerBase(path: UIBezierPath) -> CAShapeLayer {
        let segmentLayer = CAShapeLayer()
        segmentLayer.path = path.cgPath
        segmentLayer.fillColor = bubbleConfig.color!.cgColor
        segmentLayer.strokeColor = bubbleConfig.color!.cgColor
        segmentLayer.lineWidth = 0.0
        return segmentLayer
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MLBubbleView {
    fileprivate func drawTextBubbleValue() {
        labelValue = UILabel(frame: CGRect(x: segmentAreaX,
                                          y: segmentAreaY - (bubbleConfig.radius + 8),
                                          width: bubbleConfig.radius * 2,
                                          height: bubbleConfig.radius * 2))
        labelValue.textAlignment = .center
        labelValue.text = bubbleConfig.value.value
        labelValue.textColor = bubbleConfig.value.color!
        labelValue.numberOfLines = 0
        labelValue.layer.shouldRasterize = true
        labelValue.layer.contentsScale = UIScreen.main.scale
        labelValue.layer.rasterizationScale = UIScreen.main.scale
        let value = bubbleConfig.value
        if let font = value.font {
            labelValue.font = font
        }
        addSubview(labelValue)
    }

    /*
     Draw Text Label inseide Bubble
     */
    fileprivate func drawTextBubbleLabel() {
        let distance = (bubbleConfig.radius / 2)
        let yPoint = (labelValue.frame.origin.y + bubbleConfig.labelDistance) + distance
        labelLabel = UILabel(frame: CGRect(x: segmentAreaX,
                                          y: yPoint,
                                          width: bubbleConfig.radius * 2,
                                          height: bubbleConfig.radius * 2))
        labelLabel.textAlignment = .center
        labelLabel.text = bubbleConfig.label.value
        labelLabel.numberOfLines = 0
        labelLabel.layer.shouldRasterize = true
        labelLabel.layer.contentsScale = UIScreen.main.scale
        labelLabel.layer.rasterizationScale = UIScreen.main.scale

        labelLabel.textColor = bubbleConfig.label.color!
        if let font = bubbleConfig.label.font {
            labelLabel.font = font
        }
        addSubview(labelLabel)
    }
}
