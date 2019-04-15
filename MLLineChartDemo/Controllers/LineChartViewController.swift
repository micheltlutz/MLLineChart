//
//  LineChartViewController.swift
//  MLLineChartDemo
//
//  Created by Michel Anderson Lutz Teixeira on 15/04/19.
//  Copyright © 2019 micheltlutz. All rights reserved.
//

import UIKit
import MLLineChart

class LineChartViewController: UIViewController {
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

    private func makeData() {
        dataEntries.append(MLPointEntry(value: 5, label: "1", color: .gray))
        dataEntries.append(MLPointEntry(value: 6, label: "2", color: .green))
        dataEntries.append(MLPointEntry(value: 4, label: "3", color: .blue))
    }

    private func setupChart() {
        lineChart = MLLineChart(frame: CGRect(x: 0, y: 0, width: widthChart, height: heightChart))
        lineChart.translatesAutoresizingMaskIntoConstraints = false
        lineChart.dataEntries = dataEntries
        lineChart.lineColor = .gray
        lineChart.lineWidth = 2
        lineChart.showShadows = true
        lineChart.showAxisLine = true
        lineChart.gradienLinesColors = [UIColor.gray.cgColor, UIColor.green.cgColor, UIColor.blue.cgColor]
        lineChart.configLabelsBottom = MLLabelConfig(color: .white,
                                                           backgroundColor: .gray,
                                                           rounded: true,
                                                           font: UIFont.systemFont(ofSize: 11),
                                                           width: 16, height: 16, fontSize: 11)
    }
}

extension LineChartViewController: ViewConfiguration {
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
