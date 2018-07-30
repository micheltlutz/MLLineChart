# MLLineChart

<p align="center">
 <img width="300" height="300"src="http://micheltlutz.me/imagens/projetos/MLLineChart/logoML_BETA.png">
</p>


[![Swift 4.1](https://img.shields.io/badge/swift-4.1-brightgreen.svg)](https://swift.org)

[![License](https://img.shields.io/badge/license-MIT-brightgreen.svg)](https://raw.githubusercontent.com/micheltlutz/MLLineChart/master/LICENSE)

[![Swift Package Manager](https://img.shields.io/badge/Swift%20Package%20Manager-compatible-brightgreen.svg)](https://github.com/apple/swift-package-manager)

[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

[![CocoaPods compatible](https://img.shields.io/cocoapods/v/MLLineChart.svg)](https://cocoapods.org/pods/MLLineChart)
![CocoaPods](https://img.shields.io/cocoapods/v/MLLineChart.svg)


[![SwiftFrameworkTemplate](https://img.shields.io/badge/SwiftFramework-Template-red.svg)](http://github.com/RahulKatariya/SwiftFrameworkTemplate)

A Simple Line Chart Lib

- [Requirements](#requirements)
- [Installation](#installation)
- [Usage](#usage)
- [License](#license)

## Requirements

- iOS 8.0+ / tvOS 9.0+ 
- Xcode 9.0+

## Installation

### CocoaPods

Add the following line to your Podfile:

    pod "MLLineChart"


``` $ pod install ```

### Dependency Managers
<details>
  <summary><strong>CocoaPods</strong></summary>

[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects. You can install it with the following command:

```bash
$ gem install cocoapods
```

To integrate MLLineChart into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'
use_frameworks!

pod 'MLLineChart', '~> 0.0.1'
```

Then, run the following command:

```bash
$ pod install
```

</details>

<details>
  <summary><strong>Carthage</strong></summary>

[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager that automates the process of adding frameworks to your Cocoa application.

You can install Carthage with [Homebrew](http://brew.sh/) using the following command:

```bash
$ brew update
$ brew install carthage
```

To integrate MLLineChart into your Xcode project using Carthage, specify it in your `Cartfile`:

```ogdl
github "micheltlutz/MLLineChart" ~> 0.0.1
```

</details>

<details>
  <summary><strong>Swift Package Manager</strong></summary>

To use MLLineChart as a [Swift Package Manager](https://swift.org/package-manager/) package just add the following in your Package.swift file.

``` swift
// swift-tools-version:4.1

import PackageDescription

let package = Package(
    name: "HelloMLLineChart",
    dependencies: [
        .package(url: "https://github.com/micheltlutz/MLLineChart.git", .upToNextMajor(from: "0.0.1"))
    ],
    targets: [
        .target(name: "HelloMLLineChart", dependencies: ["MLLineChart"])
    ]
)
```
</details>

### Manually

If you prefer not to use either of the aforementioned dependency managers, you can integrate MLLineChart into your project manually.

<details>
  <summary><strong>Git Submodules</strong></summary><p>

- Open up Terminal, `cd` into your top-level project directory, and run the following command "if" your project is not initialized as a git repository:

```bash
$ git init
```

- Add MLLineChart as a git [submodule](http://git-scm.com/docs/git-submodule) by running the following command:

```bash
$ git submodule add https://github.com/micheltlutz/MLLineChart.git
$ git submodule update --init --recursive
```

- Open the new `MLLineChart` folder, and drag the `MLLineChart.xcodeproj` into the Project Navigator of your application's Xcode project.

    > It should appear nested underneath your application's blue project icon. Whether it is above or below all the other Xcode groups does not matter.

- Select the `MLLineChart.xcodeproj` in the Project Navigator and verify the deployment target matches that of your application target.
- Next, select your application project in the Project Navigator (blue project icon) to navigate to the target configuration window and select the application target under the "Targets" heading in the sidebar.
- In the tab bar at the top of that window, open the "General" panel.
- Click on the `+` button under the "Embedded Binaries" section.
- You will see two different `MLLineChart.xcodeproj` folders each with two different versions of the `MLLineChart.framework` nested inside a `Products` folder.

    > It does not matter which `Products` folder you choose from.

- Select the `MLLineChart.framework`.

- And that's it!

> The `MLLineChart.framework` is automagically added as a target dependency, linked framework and embedded framework in a copy files build phase which is all you need to build on the simulator and a device.

</p></details>

<details>
  <summary><strong>Embedded Binaries</strong></summary><p>

- Download the latest release from https://github.com/micheltlutz/MLLineChart/releases
- Next, select your application project in the Project Navigator (blue project icon) to navigate to the target configuration window and select the application target under the "Targets" heading in the sidebar.
- In the tab bar at the top of that window, open the "General" panel.
- Click on the `+` button under the "Embedded Binaries" section.
- Add the downloaded `MLLineChart.framework`.
- And that's it!

</p></details>

## Usage

```swift
import MLLineChart

class ViewController: UIViewController {
    private var lineChart: MLLineChart!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupChart()
        
        view.addSubview(lineChart)
        lineChart.translatesAutoresizingMaskIntoConstraints = false
        lineChart.widthAnchor.constraint(equalToConstant: 300).isActive = true
        lineChart.heightAnchor.constraint(equalToConstant: 260).isActive = true
        lineChart.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        lineChart.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    private func setupChart() {
        lineChart = MLLineChart()
        lineChart.animation.enabled = true
        lineChart.area = false
        lineChart.dots.visible = false
        lineChart.x.grid.count = 31
        lineChart.y.grid.count = 7
        
        let configAxis = MLConfigAxisXY(
            xAxisConfig: MLConfigAxis(from: 1, to: 31, by: 5, visible: false),
            yAxisConfig: MLConfigAxis(from: 7, to: 1, by: 1, visible: false)
        )

        var xlabels = MLLineChart.Labels()
        xlabels.values = ["1", "5", "10", "15", "20", "25", "30"]
        xlabels.visible = true
        xlabels.textAlignment = .right
        
        var ylabels = MLLineChart.Labels()
        ylabels.values = ["1", "2", "3", "4", "5", "6", "7"]
        ylabels.visible = true
        ylabels.textAlignment = .center
        
        let labelsConfig = MLConfigLabelsXY(xLabels: xlabels, yLabels: ylabels)
        
        lineChart.configAxis = configAxis
        lineChart.configLabels = labelsConfig
        lineChart.y.grid.visible = false
        lineChart.x.grid.visible = false
//        let colorsLines: [UIColor] = [.blue, .blue, .green, .green, .green, .brown, .green, .green, UIColor.cyan]
//        lineChart.lineColors = colorsLines
        let dataItens: [CGFloat] = convertValToChart([1, 1, 2, 2, 2, 6, 2, 2, 3])
        lineChart.addLine(dataItens)
    }
    
    func convertValToChart(_ data: [Int]) -> [CGFloat]{
        var dataChart: [CGFloat] = []
        for item in data {
            switch item {
            case 7:
                dataChart.append(0)
            case 6:
                dataChart.append(1)
            case 5:
                dataChart.append(2)
            case 4:
                dataChart.append(3)
            case 3:
                dataChart.append(4)
            case 2:
                dataChart.append(5)
            case 1:
                dataChart.append(6)
            default:
                dataChart.append(6)
            }
        }
        return dataChart
    }
}

```

<p align="center">
 <img width="300" height="600"src="http://micheltlutz.me/imagens/projetos/MLLineChart/IMG_4293.PNG">
 <img width="300" height="600"src="http://micheltlutz.me/imagens/projetos/MLLineChart/IMG_4294.PNG">
</p>


## Contributing

Issues and pull requests are welcome!

## Author

Michel Anderson Lutz Teixeira [@michel_lutz](https://twitter.com/michel_lutz)

[My Site](http://micheltlutz.me)

## License

MLLineChart is released under the MIT license. See [LICENSE](https://github.com/micheltlutz/MLLineChart/blob/master/LICENSE) for details.
