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

extension MLLineChart {
    /**
     * Helpers class
     */
    open class Helpers {
        //Convert hex color to UIColor
        open class func UIColorFromHex(_ hex: Int) -> UIColor {
            let red = CGFloat((hex & 0xFF0000) >> 16) / 255.0
            let green = CGFloat((hex & 0xFF00) >> 8) / 255.0
            let blue = CGFloat((hex & 0xFF)) / 255.0
            return UIColor(red: red, green: green, blue: blue, alpha: 1)
        }

        /// Lighten color.
        open class func lightenUIColor(_ color: UIColor) -> UIColor {
            var h: CGFloat = 0
            var s: CGFloat = 0
            var b: CGFloat = 0
            var a: CGFloat = 0
            color.getHue(&h, saturation: &s, brightness: &b, alpha: &a)
            return UIColor(hue: h, saturation: s, brightness: b * 1.5, alpha: a)
        }

        /// Random Colors to use on Chart with colored lines
        public static let randomColors: [UIColor] = [
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

        public static func randomizedColor() -> UIColor {
            return Helpers.randomColors[Int(arc4random_uniform(UInt32(Helpers.randomColors.count)))]
        }
    }
}
