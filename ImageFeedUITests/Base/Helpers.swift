//
//  Helpers.swift
//  ImageFeedUITests
//
//  Created by Андрей Тапалов on 28.03.2024.
//

import Foundation
import XCTest

extension XCUIElement {
    func tapElement(){
        _ = self.waitForExistence(timeout: Constants.delay)
        self.tap()
    }
    
    func fillTextField(text: String){
        _ = self.waitForExistence(timeout: Constants.delay)
        self.typeText(text)
    }
    
    func checkElementExist(){
        _ = self.waitForExistence(timeout: Constants.delay)
        XCTAssertTrue(self.exists)
    }
}
