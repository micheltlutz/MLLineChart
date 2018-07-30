// swift-tools-version:4.1
//
//  MLLineChart.swift
//  MLLineChart
//
//  Created by Michel Anderson Lutz Teixeira on 23/10/15.
//  Copyright © 2017 micheltlutz. All rights reserved.
//

import PackageDescription

let package = Package(
    name: "MLLineChart",
    products: [
        .library(
            name: "MLLineChart",
            targets: ["MLLineChart"]),
        ],
    dependencies: [],
    targets: [
        .target(
            name: "MLLineChart",
            dependencies: ["UIKit", "QuartzCore"],
            path: "Sources"),
        .testTarget(
            name: "MLLineChartTests",
            dependencies: ["MLLineChart"],
            path: "Tests")
    ]
)
