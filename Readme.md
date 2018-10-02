# MLLineChart

<p align="center">
 <img width="300" height="300"src="http://micheltlutz.me/imagens/projetos/MLLineChart/logo.png">
</p>


[![Swift 4.1](https://img.shields.io/badge/swift-4.1-brightgreen.svg)](https://swift.org)
[![Platforms](https://img.shields.io/cocoapods/p/MLLineChart.svg)](https://cocoapods.org/pods/MLLineChart)
[![License](https://img.shields.io/badge/license-MIT-brightgreen.svg)](https://raw.githubusercontent.com/micheltlutz/MLLineChart/master/LICENSE)
[![Swift Package Manager](https://img.shields.io/badge/Swift%20Package%20Manager-compatible-brightgreen.svg)](https://github.com/apple/swift-package-manager)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![CocoaPods compatible](https://img.shields.io/cocoapods/v/MLLineChart.svg)](https://cocoapods.org/pods/MLLineChart)
[![Travis](https://img.shields.io/travis/micheltlutz/MLLineChart/master.svg)](https://travis-ci.org/micheltlutz/MLLineChart/branches)
[![SwiftFrameworkTemplate](https://img.shields.io/badge/SwiftFramework-Template-red.svg)](http://github.com/RahulKatariya/SwiftFrameworkTemplate)

A Simple Line Chart Librarie

- [Requirements](#requirements)
- [Installation](#installation)
- [Usage](#usage)
- [License](#license)

## Requirements

- iOS 10.0+ / tvOS 9.0+ 
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
platform :ios, '10.0'
use_frameworks!

pod 'MLLineChart', '~> 1.0'
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
github "micheltlutz/MLLineChart" ~> 1.0
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
        .package(url: "https://github.com/micheltlutz/MLLineChart.git", .upToNextMajor(from: "1.0"))
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
    private var lineLinearChart: MLLineChart!
    private var dataEntries: [MLPointEntry] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeData()
        setupChart()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        lineLinearChart.animate()
    }

    private func makeData() {
        dataEntries.append(MLPointEntry(value: 0, label: "1", color: UIColor.init(hex: "f0f0f0"), bubbleConfig: nil))
        dataEntries.append(MLPointEntry(value: 6, label: "2", color: UIColor.init(hex: "70A886"), bubbleConfig: nil))
        dataEntries.append(MLPointEntry(value: 6, label: "3", color: UIColor.init(hex: "70A886"), bubbleConfig: nil))
        dataEntries.append(MLPointEntry(value: 5, label: "4", color: UIColor.init(hex: "F3A634"), bubbleConfig: nil))
        dataEntries.append(MLPointEntry(value: 5, label: "5", color: UIColor.init(hex: "F3A634"), bubbleConfig: nil))
        dataEntries.append(MLPointEntry(value: 3, label: "6", color: UIColor.init(hex: "EB7F33"), bubbleConfig: nil))
        dataEntries.append(MLPointEntry(value: 5, label: "7", color: UIColor.init(hex: "F3A634"), bubbleConfig: nil))
        dataEntries.append(MLPointEntry(value: 4, label: "8", color: UIColor.init(hex: "F29D53"), bubbleConfig: nil))
        dataEntries.append(MLPointEntry(value: 5, label: "9", color: UIColor.init(hex: "F3A634"), bubbleConfig: nil))
        dataEntries.append(MLPointEntry(value: 3, label: "10", color: UIColor.init(hex: "EB7F33"), bubbleConfig: nil))
    }

    private func setupChart() {
        lineLinearChart = MLLineChart(frame: CGRect(x: 0, y: 0, width: 320, height: heightChart))
        lineLinearChart.translatesAutoresizingMaskIntoConstraints = false
        lineLinearChart.dataEntries = dataEntries
        lineLinearChart.minPoint = 0
        lineLinearChart.maxPoint = 7
        lineLinearChart.showAxisLine = true
        lineLinearChart.showHorizontalLines = true
        lineLinearChart.showDots = false
        lineLinearChart.lineColor = .lightGray
        lineLinearChart.horizontalLinesColor = .gray
        lineLinearChart.labelColor = .gray
        lineLinearChart.showBubbleInfo = false
        lineLinearChart.hasColoredLines = true
        lineLinearChart.labelBottomConfig = MLLabelConfig(color: .gray,
                                                          backgroundColor: .clear,
                                                          rounded: false,
                                                          font: UIFont.systemFont(ofSize: 11),
                                                          width: 16, height: 16, fontSize: 11)
        self.setupViewConfiguration()

    }

    public func animate() {
        lineLinearChart.scrollToTheEnd()
    }
    
    /// Cntinue your code
    
}

```

## Docs

[Documentation](https://github.com/micheltlutz/MLLineChart/docs/)

MLLineChart Docs (44% documented)


## Demo App



Clone: [MLLineChartDemo](https://github.com/micheltlutz/MLLineChartDemo)


<p align="center">
 <img width="300" height="358"src="http://micheltlutz.me/imagens/projetos/MLLineChart/IMG_4604.jpg"> 
 
 
 <img width="300" height="358"src="http://micheltlutz.me/imagens/projetos/MLLineChart/IMG_4605.jpg">
</p>


## Contributing

Issues and pull requests are welcome!

## Todo

- [ ] Curved chart with colors on segments
- [ ] Migrate to Swift 4.2
- [ ] 100% documented

## Author

Michel Anderson Lutz Teixeira [@michel_lutz](https://twitter.com/michel_lutz)

Inspired on  [nhatminh12369/LineChart](https://github.com/nhatminh12369/LineChart)

[My Site](http://micheltlutz.me)

## License

MLLineChart is released under the MIT license. See [LICENSE](https://github.com/micheltlutz/MLLineChart/blob/master/LICENSE) for details.
