import UIKit
import MLLineChart
import PlaygroundSupport

class ViewController : UIViewController {
    var dataEntries: [MLPointEntry] = []
    func makeData() {
        dataEntries = generateRandomEntries()
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
//        lineLinearChart.ignoreZeros = true
        lineLinearChart.isCurved = true
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
    
    func generateRandomEntries() -> [MLPointEntry] {
        var result: [MLPointEntry] = []
        for i in 0...30 {
            let value = Int(arc4random_uniform(UInt32(7)))
            //let value = Int(arc4random() % 500)
            
            let formatter = DateFormatter()
            formatter.dateFormat = "MMMM\nYY"
            var date = Date()
            date.addTimeInterval(TimeInterval(24*60*60*i))
            
            let color = MLLineChart.Helpers.randomizedColor()
            
            //            let valueConfig = MLTextConfig(value: String(value),
            //                                           color: color,
            //                                           font: UIFont.systemFont(ofSize: 17))
            //
            //            let labelConfig = MLTextConfig(value: "\(value) e",
            //                color: color,
            //                font: UIFont.systemFont(ofSize: 14))
            
            let entry = MLPointEntry(value: CGFloat(value),
                                     label: String(i),
                                     //                                     label: formatter.string(from: date),
                color: color, bubbleConfig: nil, dotColor: color)
            result.append(entry)
        }
        return result
    }
}


PlaygroundPage.current.liveView = ViewController()
