//
//  BaseClass.swift
//  ImageFeedUITests
//
//  Created by Андрей Тапалов on 27.03.2024.
//
@testable import ImageFeed
import XCTest

class BaseClass: XCTestCase {
    let app = XCUIApplication()
    
    override func setUp() {
        app.launchArguments = ["testMode"]
        app.launch()
    }
    
    override func tearDown() {
        app.terminate()
    }
}

enum Constants {
    static let userEmail = ""
    static let password = ""
    static let delay: Double = 5.0
}
