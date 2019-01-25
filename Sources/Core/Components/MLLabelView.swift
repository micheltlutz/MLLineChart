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

class MLLabelView: UIView {
    var dataEntries: [MLPointEntry] = []
    var width: CGFloat!
    var height: CGFloat!
    var positionY: CGFloat!
    var labelConfig: MLLabelConfig!
    init(dataEntries: [MLPointEntry],
         width: CGFloat,
         height: CGFloat,
         positionY: CGFloat, labelConfig: MLLabelConfig) {

        self.dataEntries = dataEntries
        self.width = width
        self.height = height
        self.positionY = positionY
        self.labelConfig = labelConfig
        super.init(frame: CGRect(x: 0, y: positionY, width: width, height: height))
        self.makeLabels()
    }

    func makeLabels() {
        for (index, entry) in dataEntries.enumerated() {
            addSubview(getLabel(text: entry.label, index: index))
        }
    }

    private func getLabel(text: String, index: Int) -> UILabel {
        let xPos = ((width / CGFloat(dataEntries.count - 1)) * CGFloat(index)) - (labelConfig.width! / 2)
        let label = UILabel(frame: CGRect(x: xPos,
                                          y: 0, width: labelConfig.width!,
                                          height: labelConfig.height!))
        label.text = text
        if let alignment = labelConfig.alignment {
            label.textAlignment = alignment.TextAlignment
        }
        if let font = labelConfig.font { label.font = font }

        if let jumpChunk = labelConfig.jumpChunk {
            if jumpChunk.contains(text) {
                if let color = labelConfig.color { label.textColor = color }
                if let backgroundColor = labelConfig.backgroundColor {
                    label.backgroundColor = backgroundColor
                }
            } else {
                label.backgroundColor = .clear
                label.textColor = .clear
            }
        } else {
            if let color = labelConfig.color { label.textColor = color }
            if let backgroundColor = labelConfig.backgroundColor {
                label.backgroundColor = backgroundColor
            }
        }

        if let isRounded = labelConfig.rounded {
            if isRounded {
                label.layer.cornerRadius = labelConfig.height! / 2
                label.clipsToBounds = true
            }
        }
        return label
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
