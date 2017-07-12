// swift-tools-version:3.1

import PackageDescription

let package = Package(
    name: "Codpi",

    targets: [
      Target(name: "Codpi", dependencies: ["odpi"])
    ],

    dependencies: [
      .Package(url: "https://github.com/IBM-Swift/Configuration", majorVersion: 1)
    ]
)
