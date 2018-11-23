//
//  MLAxisLine.swift
//  MLLineChart-iOS
//
//  Created by Michel Anderson Lutz Teixeira on 01/10/18.
//  Copyright © 2018 micheltlutz. All rights reserved.
//

import UIKit

class MLAxisLine: UIView {
    init(frame: CGRect, thickness: CGFloat, color: UIColor, backgroundColor: UIColor?) {
        super.init(frame: frame)
        self.addBorder(side: .bottom, thickness: thickness, color: color)
        self.addBorder(side: .left, thickness: thickness, color: color)
        if let bgColor = backgroundColor {
            self.backgroundColor = bgColor
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
