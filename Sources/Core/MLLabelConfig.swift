//
//  MLLabelConfig.swift
//  MLLineChart-iOS
//
//  Created by Michel Anderson Lutz Teixeira on 14/09/2018.
//  Copyright © 2018 micheltlutz. All rights reserved.
//

import UIKit

public struct MLLabelConfig {
    public var color: UIColor?
    public var backgroundColor: UIColor?
    public var rounded: Bool?
    public var font: UIFont?
    public var width: CGFloat?
    public var height: CGFloat?
    public var fontSize: CGFloat?

    public init(color: UIColor? = .white, backgroundColor: UIColor? = .gray,
                rounded: Bool? = true, font: UIFont? = UIFont.systemFont(ofSize: 14),
                width: CGFloat? = 60.0, height: CGFloat? = 16.00, fontSize: CGFloat? = 11) {
        self.color = color
        self.backgroundColor = backgroundColor
        self.rounded = rounded
        self.font = font
        self.width = width
        self.height = height
        self.fontSize = fontSize
    }
}



