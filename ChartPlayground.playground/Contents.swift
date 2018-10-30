import UIKit
import MLLineChart
import PlaygroundSupport

extension UIColor {
    convenience init(hex: String) {
        let hexN = hex.replacingOccurrences(of: "#", with: "", options: .literal, range: nil)
        let scanner = Scanner(string: hexN)
        scanner.scanLocation = 0
        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)
        let red = (rgbValue & 0xff0000) >> 16
        let green = (rgbValue & 0xff00) >> 8
        let blue = rgbValue & 0xff
        self.init(
            red: CGFloat(red) / 0xff,
            green: CGFloat(green) / 0xff,
            blue: CGFloat(blue) / 0xff, alpha: 1
        )
    }
}


class ViewController : UIViewController {
    var dataEntries: [MLPointEntry] = []
    func makeData() {
        dataEntries.append(MLPointEntry(value: 0, label: "1", color: UIColor.clear, bubbleConfig: nil))
        dataEntries.append(MLPointEntry(value: 0, label: "2", color: UIColor.clear, bubbleConfig: nil))
        dataEntries.append(MLPointEntry(value: 0, label: "3", color: UIColor.clear, bubbleConfig: nil))
        dataEntries.append(MLPointEntry(value: 0, label: "4", color: UIColor.clear, bubbleConfig: nil))
        dataEntries.append(MLPointEntry(value: 0, label: "5", color: UIColor.clear, bubbleConfig: nil))
        dataEntries.append(MLPointEntry(value: 0, label: "6", color: UIColor.clear, bubbleConfig: nil))
        dataEntries.append(MLPointEntry(value: 6, label: "7", color: UIColor.init(hex: "99cc00"), bubbleConfig: nil))
        dataEntries.append(MLPointEntry(value: 0, label: "8", color: UIColor.clear, bubbleConfig: nil))
        dataEntries.append(MLPointEntry(value: 0, label: "9", color: UIColor.clear, bubbleConfig: nil))
        dataEntries.append(MLPointEntry(value: 0, label: "10", color: UIColor.clear, bubbleConfig: nil))
        dataEntries.append(MLPointEntry(value: 0, label: "11", color: UIColor.clear, bubbleConfig: nil))
        dataEntries.append(MLPointEntry(value: 4, label: "12", color: UIColor.init(hex: "FFCC00"), bubbleConfig: nil))
        dataEntries.append(MLPointEntry(value: 0, label: "13", color: UIColor.clear, bubbleConfig: nil))
        dataEntries.append(MLPointEntry(value: 0, label: "14", color: UIColor.clear, bubbleConfig: nil))
        dataEntries.append(MLPointEntry(value: 0, label: "15", color: UIColor.clear, bubbleConfig: nil))
        dataEntries.append(MLPointEntry(value: 1, label: "16", color: UIColor.init(hex: "FF0000"), bubbleConfig: nil))
        dataEntries.append(MLPointEntry(value: 0, label: "17", color: UIColor.clear, bubbleConfig: nil))
        dataEntries.append(MLPointEntry(value: 0, label: "18", color: UIColor.clear, bubbleConfig: nil))
        dataEntries.append(MLPointEntry(value: 0, label: "19", color: UIColor.clear, bubbleConfig: nil))
        dataEntries.append(MLPointEntry(value: 0, label: "20", color: UIColor.clear, bubbleConfig: nil))
        dataEntries.append(MLPointEntry(value: 0, label: "21", color: UIColor.init(hex: "EB7F33"), bubbleConfig: nil))
        dataEntries.append(MLPointEntry(value: 0, label: "22", color: UIColor.init(hex: "F3A634"), bubbleConfig: nil))
        dataEntries.append(MLPointEntry(value: 0, label: "23", color: UIColor.init(hex: "F29D53"), bubbleConfig: nil))
        dataEntries.append(MLPointEntry(value: 0, label: "24", color: UIColor.init(hex: "F3A634"), bubbleConfig: nil))
        dataEntries.append(MLPointEntry(value: 0, label: "25", color: UIColor.init(hex: "EB7F33"), bubbleConfig: nil))
        dataEntries.append(MLPointEntry(value: 0, label: "26", color: UIColor.init(hex: "EB7F33"), bubbleConfig: nil))
        dataEntries.append(MLPointEntry(value: 0, label: "27", color: UIColor.init(hex: "EB7F33"), bubbleConfig: nil))
        dataEntries.append(MLPointEntry(value: 0, label: "28", color: UIColor.init(hex: "000000"), bubbleConfig: nil))
        dataEntries.append(MLPointEntry(value: 0, label: "29", color: UIColor.init(hex: "000000"), bubbleConfig: nil))
        dataEntries.append(MLPointEntry(value: 0, label: "30", color: UIColor.init(hex: "000000"), bubbleConfig: nil))
        dataEntries.append(MLPointEntry(value: 0, label: "31", color: UIColor.init(hex: "EB7F33"), bubbleConfig: nil))
    }

    override func loadView() {
        makeData()
        var lineLinearChart: MLLineChart!

        lineLinearChart = MLLineChart(frame: CGRect(x: 0, y: 0, width: 320, height: 440))
        lineLinearChart.translatesAutoresizingMaskIntoConstraints = false
        lineLinearChart.dataEntries = dataEntries
        lineLinearChart.lineGap = 9
        lineLinearChart.minPoint = 1
        lineLinearChart.maxPoint = 7
        lineLinearChart.showAxisLine = true
        lineLinearChart.showHorizontalLines = true
        lineLinearChart.showDots = false
        lineLinearChart.lineColor = .lightGray
        lineLinearChart.horizontalLinesColor = .gray
        lineLinearChart.labelColor = .gray
        lineLinearChart.showBubbleInfo = false
        lineLinearChart.hasColoredLines = true
        lineLinearChart.showLabels = true
        lineLinearChart.ignoreZeros = true
        lineLinearChart.labelBottomConfig = MLLabelConfig(color: .gray,
                                                          backgroundColor: .clear,
                                                          rounded: false,
                                                          font: UIFont.systemFont(ofSize: 11),
                                                          width: 16, height: 16, fontSize: 11)


        let view = UIView()
        view.backgroundColor = .white

        view.addSubview(lineLinearChart)

        self.view = view

    }
}




PlaygroundPage.current.liveView = ViewController()
