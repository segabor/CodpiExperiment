// swift-tools-version:4.2

import PackageDescription

let package = Package(
    name: "CodpiExperiment",

    dependencies: [
        .package(url: "https://github.com/Kitura/Configuration", from: "3.0.0")
    ],

    targets: [
        .systemLibrary(name: "Codpi", providers: [
            .brew(["odpi"])
        ]),
        .target(name: "CodpiExperiment", dependencies: ["Configuration", "Codpi"])
    ]
)
