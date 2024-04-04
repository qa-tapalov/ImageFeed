//
//  ImageFeedUITests.swift
//  ImageFeedUITests
//
//  Created by Андрей Тапалов on 27.03.2024.
//
@testable import ImageFeed
import XCTest

class ImageFeedUITests: BaseClass {
    
    let uiElements = UiElements()
    
    func test_Auth(){
        uiElements.buttonSignIn.tapElement()
        uiElements.emailTextField.tapElement()
        uiElements.emailTextField.fillTextField(text: Constants.userEmail)
        uiElements.buttonDoneOnToolbar.tapElement()
        uiElements.secureTextField.tapElement()
        uiElements.secureTextField.fillTextField(text: Constants.password)
        uiElements.buttonLogin.tapElement()
        uiElements.firstImage.checkElementExist()
    }
    
    func test_Feed(){
        uiElements.firstImage.checkElementExist()
        app.swipeUp()
        app.swipeDown()
        sleep(2)
        uiElements.buttonNoActiveLike.tap()
        uiElements.buttonActiveLike.tap()
        sleep(2)
        uiElements.firstImage.tap()
        sleep(5)
        uiElements.fullImage.pinch(withScale: 3, velocity: 1)
        uiElements.fullImage.pinch(withScale: 0.5, velocity: -1)
        uiElements.buttonNavBack.tap()
        uiElements.firstImage.checkElementExist()
    }
    
    func test_Profile(){
        uiElements.tabProfile.tapElement()
        uiElements.userAvatar.checkElementExist()
        uiElements.userName.checkElementExist()
        uiElements.userLogin.checkElementExist()
        uiElements.buttonLogout.tap()
        uiElements.buttonAlertYes.tapElement()
        uiElements.buttonSignIn.checkElementExist()
    }
    
}
