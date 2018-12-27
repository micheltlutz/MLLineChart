//
//  MLBubbleView.swift
//  MLLineChart-iOS
//
//  Created by Michel Anderson Lutz Teixeira on 22/11/18.
//  Copyright © 2018 micheltlutz. All rights reserved.
//

import UIKit

class MLBubbleView: UIView {
    private var bubbleConfig: MLBubbleConfig!
    private var dataPoint: CGPoint = CGPoint()
    private let magicConstant: CGFloat = 0.552284749831
    private var segmentAreaX: CGFloat = 0
    private var segmentAreaY: CGFloat = 0
    
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
        let yPos = dataPoint.y - (self.bubbleConfig.radius*2.7)
        
//        print("self.bubbleConfig.radius: \(self.bubbleConfig.radius)")
        print("self.bubbleConfig.radiusx3: \(self.bubbleConfig.radius*2.7)")
        segmentAreaX = CGFloat((bubbleConfig.radius / 2) - 5)
        segmentAreaY = CGFloat(bubbleConfig.radius)
        super.init(frame: CGRect(x: xPos - segmentAreaX, y: yPos,
                                width: (bubbleConfig.radius * 2) + bubbleConfig.radius / 2,
                                 height: (bubbleConfig.radius * 2) + bubbleConfig.radius))
        self.make()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func make() {
        let xPosP = segmentAreaX
        let yPosP = segmentAreaY
        let color = bubbleConfig.color!
        
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
        layer.addSublayer(segment1Layer)
        
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
        layer.addSublayer(segment2Layer)
        
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
        layer.addSublayer(segment3Layer)
        
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
        layer.addSublayer(segment4Layer)
        
        
        drawTextBubbleValue(xPos: xPosP, yPos: yPosP)
        drawTextBubbleLabel(xPos: xPosP, yPos: yPosP)
    }
}


extension MLBubbleView {
    /*
     Draw Text Value inseide Bubble
     */
    fileprivate func drawTextBubbleValue(xPos: CGFloat, yPos: CGFloat) {
//        let label = UILabel(frame: CGRect(x: xPos, y: yPos - (bubbleConfig.radius + 4),
//                                          width: bubbleConfig.radius*2,
//                                          height: bubbleConfig.radius*2))
//        label.textAlignment = .center
//        label.text = bubbleConfig.value.value
//        label.textColor = bubbleConfig.value.color!
//        label.layer.shouldRasterize = true
//        label.layer.contentsScale = UIScreen.main.scale
//        label.layer.rasterizationScale = UIScreen.main.scale
//        let value = bubbleConfig.value
//        if let font = value.font {
//            label.font = font
//        }
//        addSubview(label)
        
        let textLayer = CATextLayer()
        textLayer.frame = CGRect(x: xPos, y: yPos-(bubbleConfig.radius)+4,
                                 width: bubbleConfig.radius*2,
                                 height: bubbleConfig.radius*2)
        textLayer.foregroundColor = bubbleConfig.value.color!.cgColor
        textLayer.backgroundColor = UIColor.clear.cgColor
        textLayer.alignmentMode = CATextLayerAlignmentMode.center
        var value = bubbleConfig.value
        let font = value.createFont()
        textLayer.font = font.ctfont
        textLayer.fontSize = font.size
        textLayer.string = bubbleConfig.value.value
        textLayer.shouldRasterize = true
        textLayer.contentsScale = UIScreen.main.scale
        textLayer.rasterizationScale = UIScreen.main.scale
        layer.addSublayer(textLayer)
        textLayer.display()
    }
    
    /*
     Draw Text Label inseide Bubble
     */
    fileprivate func drawTextBubbleLabel(xPos: CGFloat, yPos: CGFloat) {
//        let distance = (bubbleConfig.radius / 2)
//        let label = UILabel(frame: CGRect(x: xPos, y: (yPos - distance) + bubbleConfig.labelDistance,
//                                          width: bubbleConfig.radius * 2,
//                                          height: bubbleConfig.radius * 2))
//        label.textAlignment = .center
//        label.text = bubbleConfig.label.value
//        label.layer.shouldRasterize = true
//        label.layer.contentsScale = UIScreen.main.scale
//        label.layer.rasterizationScale = UIScreen.main.scale
//
//        label.textColor = bubbleConfig.label.color!
//        if let font = bubbleConfig.label.font {
//            label.font = font
//        }
//        addSubview(label)
        
        
        let textLayer = CATextLayer()
        textLayer.frame = CGRect(x: xPos, y: yPos-(bubbleConfig.radius / 2) + bubbleConfig.labelDistance,
                                 width: bubbleConfig.radius * 2,
                                 height: bubbleConfig.radius * 2)
        textLayer.foregroundColor = bubbleConfig.label.color!.cgColor
        textLayer.backgroundColor = UIColor.clear.cgColor
        textLayer.alignmentMode = CATextLayerAlignmentMode.center
        var label = bubbleConfig.label
        let font = label.createFont()
        textLayer.font = font.ctfont
        textLayer.fontSize = font.size
        textLayer.string = label.value
        textLayer.shouldRasterize = true
        textLayer.contentsScale = UIScreen.main.scale
        textLayer.rasterizationScale = UIScreen.main.scale
        layer.addSublayer(textLayer)
        textLayer.display()
    }
}
