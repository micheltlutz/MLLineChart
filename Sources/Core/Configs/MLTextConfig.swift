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

/**
 Struct Configure a Text for bubble infos
 */
public struct MLTextConfig {
    public let value: String
    public var color: UIColor?
    public var font: UIFont?
    public init(value: String, color: UIColor? = .gray, font: UIFont? = UIFont.systemFont(ofSize: 14)) {
        self.value = value
        self.color = color
        self.font = font
    }

    mutating func createFont() -> (ctfont: CFTypeRef, size: CGFloat){
        if let unwrappedFont = font {
            return (ctfont: CTFontCreateWithName(unwrappedFont.fontName as CFString, 0, nil), size: unwrappedFont.pointSize)
        } else {
            self.font = UIFont.systemFont(ofSize: 14)
            return (ctfont: CTFontCreateWithName(self.font!.fontName as CFString, 0, nil), size: self.font!.pointSize)
        }
    }
}
