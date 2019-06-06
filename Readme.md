# MLLineChart

<p align="center">
 <img width="300" height="300"src="http://micheltlutz.me/imagens/projetos/MLLineChart/logo.png">
</p>


[![Swift 5.0](https://img.shields.io/badge/swift-5.0-brightgreen.svg)](https://swift.org)
[![Platforms](https://img.shields.io/cocoapods/p/MLLineChart.svg)](https://cocoapods.org/pods/MLLineChart)
[![License](https://img.shields.io/badge/license-MIT-brightgreen.svg)](https://raw.githubusercontent.com/micheltlutz/MLLineChart/master/LICENSE)
[![Swift Package Manager](https://img.shields.io/badge/Swift%20Package%20Manager-compatible-brightgreen.svg)](https://github.com/apple/swift-package-manager)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![CocoaPods compatible](https://img.shields.io/cocoapods/v/MLLineChart.svg)](https://cocoapods.org/pods/MLLineChart)
[![Travis](https://img.shields.io/travis/micheltlutz/MLLineChart/master.svg)](https://travis-ci.org/micheltlutz/MLLineChart/branches)

A Simple Line Chart Library

- [Requirements](#requirements)
- [Installation](#installation)
- [Usage](#usage)
- [License](#license)

## Requirements

- iOS 10.0+ / tvOS 9.0+ 
- Xcode 10.2.1+

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

pod 'MLLineChart', '~> 2.0.4'
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
github "micheltlutz/MLLineChart" ~> 2.0.4
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
    private var dataEntries: [MLPointEntry] = []
    var widthChart = CGFloat(320)
    var heightChart = CGFloat(275)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeData()
        setupChart()
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
    /// Cntinue your code
    
}

```

## Docs

- In work
[Documentation](http://htmlpreview.github.io/?https://github.com/micheltlutz/MLLineChart/blob/develop/docs/index.html)

MLLineChart Docs (- documented)


## Demo App

Using MLLineChartDemo Target on this project


<p align="center">
 <img width="300" height="358"src="http://micheltlutz.me/imagens/projetos/MLLineChart/IMG_4604.jpg"> 
 
 
 <img width="300" height="358"src="http://micheltlutz.me/imagens/projetos/MLLineChart/IMG_4605.jpg">
</p>


## Contributing

Issues and pull requests are welcome!

## Todo

- [X] Migrate to Swift 4.2
- [ ] Support again to line without curve
- [ ] 100% documented

## Author

Michel Anderson Lutz Teixeira [@michel_lutz](https://twitter.com/michel_lutz)

Inspired on  [nhatminh12369/LineChart](https://github.com/nhatminh12369/LineChart)

[My Site](http://micheltlutz.me)

## Contributions

<a href="https://github.com/maclacerda"><img src="https://avatars.githubusercontent.com/u/4759987?v=3" title="maclacerda" width="80" height="80"></a>

## License

MLLineChart is released under the MIT license. See [LICENSE](https://github.com/micheltlutz/MLLineChart/blob/master/LICENSE) for details.
