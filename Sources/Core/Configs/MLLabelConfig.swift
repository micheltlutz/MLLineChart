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

public struct MLLabelConfig {
    public var color: UIColor?
    public var backgroundColor: UIColor?
    public var rounded: Bool?
    public var font: UIFont?
    public var width: CGFloat?
    public var height: CGFloat?
    public var fontSize: CGFloat?
    public var alignment: MLAlignment? = .center
    public var jumpChunk: [String]? = nil

    public init(color: UIColor? = .white,
                backgroundColor: UIColor? = .gray,
                rounded: Bool? = true,
                font: UIFont? = UIFont.systemFont(ofSize: 11),
                width: CGFloat? = 60.0,
                height: CGFloat? = 16.00,
                fontSize: CGFloat? = 11,
                alignment: MLAlignment? = .center,
                jumpChunk: [String]? = nil) {
        self.color = color
        self.backgroundColor = backgroundColor
        self.rounded = rounded
        self.font = font
        self.width = width
        self.height = height
        self.fontSize = fontSize
        self.alignment = alignment
        self.jumpChunk = jumpChunk
    }
}




