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
/**
 * LinearScale
 */
//open class MLLinearScale {
//    
//    var domain: [CGFloat]
//    var range: [CGFloat]
//    
//    public init(domain: [CGFloat] = [0, 1], range: [CGFloat] = [0, 1]) {
//        self.domain = domain
//        self.range = range
//    }
//    
//    open func scale() -> (_ x: CGFloat) -> CGFloat {
//        return bilinear(domain, range: range, uninterpolate: uninterpolate, interpolate: interpolate)
//    }
//    
//    open func invert() -> (_ x: CGFloat) -> CGFloat {
//        return bilinear(range, range: domain, uninterpolate: uninterpolate, interpolate: interpolate)
//    }
//    
//    open func ticks(_ m: Int) -> (CGFloat, CGFloat, CGFloat) {
//        return scale_linearTicks(domain, m: m)
//    }
//    
//    fileprivate func scale_linearTicks(_ domain: [CGFloat], m: Int) -> (CGFloat, CGFloat, CGFloat) {
//        return scale_linearTickRange(domain, m: m)
//    }
//    
//    fileprivate func scale_linearTickRange(_ domain: [CGFloat], m: Int) -> (CGFloat, CGFloat, CGFloat) {
//        var extent = scaleExtent(domain)
//        let span = extent[1] - extent[0]
//        var step = CGFloat(pow(10, floor(log(Double(span) / Double(m)) / M_LN10)))
//        let err = CGFloat(m) / span * step
//        
//        // Filter ticks to get closer to the desired count.
//        if (err <= 0.15) {
//            step *= 10
//        } else if (err <= 0.35) {
//            step *= 5
//        } else if (err <= 0.75) {
//            step *= 2
//        }
//        
//        // Round start and stop values to step interval.
//        let start = ceil(extent[0] / step) * step
//        let stop = floor(extent[1] / step) * step + step * 0.5 // inclusive
//        
//        return (start, stop, step)
//    }
//    
//    fileprivate func scaleExtent(_ domain: [CGFloat]) -> [CGFloat] {
//        let start = domain[0]
//        let stop = domain[domain.count - 1]
//        return start < stop ? [start, stop] : [stop, start]
//    }
//    
//    fileprivate func interpolate(_ a: CGFloat, b: CGFloat) -> (_ c: CGFloat) -> CGFloat {
//        var diff = b - a
//        func f(_ c: CGFloat) -> CGFloat {
//            return (a + diff) * c
//        }
//        return f
//    }
//    
//    fileprivate func uninterpolate(_ a: CGFloat, b: CGFloat) -> (_ c: CGFloat) -> CGFloat {
//        var diff = b - a
//        var re = diff != 0 ? 1 / diff : 0
//        func f(_ c: CGFloat) -> CGFloat {
//            return (c - a) * re
//        }
//        return f
//    }
//    
//    fileprivate func bilinear(_ domain: [CGFloat], range: [CGFloat], uninterpolate: (_ a: CGFloat, _ b: CGFloat) -> (_ c: CGFloat) -> CGFloat, interpolate: (_ a: CGFloat, _ b: CGFloat) -> (_ c: CGFloat) -> CGFloat) -> (_ c: CGFloat) -> CGFloat {
//        var u: (_ c: CGFloat) -> CGFloat = uninterpolate(domain[0], domain[1])
//        var i: (_ c: CGFloat) -> CGFloat = interpolate(range[0], range[1])
//        func f(_ d: CGFloat) -> CGFloat {
//            return i(u(d))
//        }
//        return f
//    }
//    
//}
