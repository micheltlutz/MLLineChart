//
//  MLLayersShadow.swift
//  MLLineChart-iOS
//
//  Created by Michel Anderson Lutz Teixeira on 20/11/18.
//  Copyright © 2018 micheltlutz. All rights reserved.
//

import UIKit

struct MLLayersShadow {
    private static let shadowRadius: CGFloat = 2
    private static let shadowOpacity: Float = 0.5
    private static let color = UIColor(red: 38/255, green: 46/255, blue: 48/255, alpha: 0.5)
    
    static func applyShadow<T: CALayer>(layer: T) {
        layer.shadowColor = MLLayersShadow.color.cgColor
        layer.shadowRadius = MLLayersShadow.shadowRadius
        layer.shadowOpacity = MLLayersShadow.shadowOpacity
    
    }
}
