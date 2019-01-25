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

struct MLCurvedSegment {
    var controlPoint1: CGPoint
    var controlPoint2: CGPoint
}

class MLCurveAlgorithm {
    static let shared = MLCurveAlgorithm()
    private var firstControlPoints: [CGPoint?] = []
    private var secondControlPoints: [CGPoint?] = []

    /**
     Create a curved bezier path that connects all points in the dataset
     */
    func createCurvedPath(_ dataPoints: [CGPoint]) -> UIBezierPath? {

        let controlPoints = controlPointsFromPoints(dataPoints: dataPoints)
        let path = UIBezierPath()

        for i in 0..<dataPoints.count {
            let point = dataPoints[i];

            if i==0 {
                path.move(to: point)
            } else {
                let segment = controlPoints[i-1]
                path.addCurve(to: point, controlPoint1: segment.controlPoint1, controlPoint2: segment.controlPoint2)
            }
        }

        return path
    }
}
extension MLCurveAlgorithm {
    private func controlPointsFromPoints(dataPoints: [CGPoint]) -> [MLCurvedSegment] {
        var result: [MLCurvedSegment] = []

        let delta: CGFloat = 0.1 // The value that intencity for curve.

        // Calculate temporary control points, these control points make Bezier segments look straight and not curving at all
        for i in 1..<dataPoints.count {
            let A = dataPoints[i-1]
            let B = dataPoints[i]
            let controlPoint1 = CGPoint(x: A.x + delta*(B.x-A.x), y: A.y + delta*(B.y - A.y))
            let controlPoint2 = CGPoint(x: B.x - delta*(B.x-A.x), y: B.y - delta*(B.y - A.y))
            let curvedSegment = MLCurvedSegment(controlPoint1: controlPoint1, controlPoint2: controlPoint2)
            result.append(curvedSegment)
        }
        var limit = 1
        if dataPoints.count > 1 {
            limit = dataPoints.count-1
        }
        // Calculate good control points
        for i in 1..<limit {
            /// A temporary control point
            let M = result[i-1].controlPoint2

            /// A temporary control point
            let N = result[i].controlPoint1

            /// central point
            let A = dataPoints[i]

            /// Reflection of M over the point A
            let MM = CGPoint(x: 2 * A.x - M.x, y: 2 * A.y - M.y)

            /// Reflection of N over the point A
            let NN = CGPoint(x: 2 * A.x - N.x, y: 2 * A.y - N.y)

            result[i].controlPoint1 = CGPoint(x: (MM.x + N.x)/2, y: (MM.y + N.y)/2)
            result[i-1].controlPoint2 = CGPoint(x: (NN.x + M.x)/2, y: (NN.y + M.y)/2)
        }

        return result
    }
}
