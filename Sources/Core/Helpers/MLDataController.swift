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

public struct MLDataController {
    public var entries: [MLPointEntry]!
    public var height: CGFloat!
    public var width: CGFloat!
    public var points: [CGPoint] = []
    public init(entries: [MLPointEntry],
         height: CGFloat,
         width: CGFloat) {
        self.entries = entries
        self.height = height
        self.width = width
    }

    public func makePoints() -> [CGPoint] {
        return convertDataEntriesToPoints()
    }

    public func convertDataEntriesToPoints() -> [CGPoint] {
        var points = [CGPoint]()
        let heightConst: CGFloat = height / 10
        for i in 0..<entries.count {
            let x = (width / CGFloat(entries.count - 1)) * CGFloat(i)
            let y = height - (entries[i].value * heightConst)

            let point = CGPoint(x: x, y: y)
            points.append(point)
        }
        return points
    }

    private func getMaxVal() -> MLPointEntry {
        let maxEntryValue = entries.max { $0.value < $1.value }
        return maxEntryValue!
    }
}
