//
//  LineDotViewController.swift
//  MLLineChartDemo
//
//  Created by Michel Anderson Lutz Teixeira on 15/04/19.
//  Copyright © 2019 micheltlutz. All rights reserved.
//

import UIKit
import MLLineChart

class LineDotChartViewController: UIViewController {
    private var lineChart: MLLineChart!
    private var dataEntries: [MLPointEntry] = []
    var widthChart = CGFloat(320)
    var heightChart = CGFloat(275)
    override func viewDidLoad() {
        super.viewDidLoad()
        makeData()
        setupChart()
        setupViewConfiguration()
    }

    let data: [(label: String, value: Float)] = [(label: "1", value: 5.0),
                                                 (label: "2", value: 6.0),
                                                 (label: "3", value: 7.0)]

    private func makeData() {
        for item in data {
            let valueConfig = MLTextConfig(value: String(item.value).replacingOccurrences(of: ".", with: ","),
                                           color: .gray,
                                           font: UIFont.systemFont(ofSize: 12))

            let labelConfig = MLTextConfig(value: item.label,
                                           color: .black,
                                           font: UIFont.systemFont(ofSize: 10))

            let bubbleConfig = MLBubbleConfig(radius: 24,
                                              value: valueConfig,
                                              label: labelConfig,
                                              labelDistance: 8,
                                              color: .white)
            dataEntries.append(MLPointEntry(value: CGFloat(item.value), label: item.label, bubbleConfig: bubbleConfig, dotColor: .gray))
        }
    }

    private func setupChart() {
        lineChart = MLLineChart(frame: CGRect(x: 0, y: 0, width: widthChart, height: heightChart))
        lineChart.translatesAutoresizingMaskIntoConstraints = false
        lineChart.dataEntries = dataEntries
        lineChart.lineColor = .gray
        lineChart.lineWidth = 2
        lineChart.showShadows = true
        lineChart.showAxisLine = true
        var dotConfig = MLDotConfig()
        dotConfig.color = .blue
        lineChart.dotConfig = dotConfig
        lineChart.configLabelsBottom = MLLabelConfig(color: .white,
                                                     backgroundColor: .gray,
                                                     rounded: true,
                                                     font: UIFont.systemFont(ofSize: 11),
                                                     width: 16, height: 16, fontSize: 11)
    }
}

extension LineDotChartViewController: ViewConfiguration {
    func setupConstraints() {
        NSLayoutConstraint.activate([
            lineChart.widthAnchor.constraint(equalToConstant: widthChart),
            lineChart.heightAnchor.constraint(equalToConstant: heightChart),
            lineChart.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            lineChart.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            ])
    }

    func buildViewHierarchy() {
        view.addSubview(lineChart)
    }
}
