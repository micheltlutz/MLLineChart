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

struct MLLayersShadow {
    private static let shadowRadius: CGFloat = 3.0
    private static let shadowOpacity: Float = 0.16
    private static let color = UIColor(red: 38/255, green: 46/255, blue: 48/255, alpha: 0.5)

    static func applyShadow<T: CALayer>(layer: T) {
        layer.shadowColor = MLLayersShadow.color.cgColor
        layer.shadowRadius = MLLayersShadow.shadowRadius
        layer.shadowOpacity = MLLayersShadow.shadowOpacity
        layer.shadowOffset = CGSize(width: 0, height: 6.0)
    }
}
