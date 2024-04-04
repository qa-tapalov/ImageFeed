//
//  UiElements.swift
//  ImageFeedUITests
//
//  Created by Андрей Тапалов on 27.03.2024.
//
@testable import ImageFeed
import XCTest

final class UiElements: BaseClass {
    lazy var buttonSignIn: XCUIElement = { app.buttons.staticTexts["Войти"] }()
    lazy var emailTextField: XCUIElement = { app.webViews.textFields.firstMatch }()
    lazy var secureTextField: XCUIElement = { app.webViews.secureTextFields.firstMatch }()
    lazy var buttonDoneOnToolbar: XCUIElement = { app.toolbars.buttons["Done"] }()
    lazy var buttonLogin: XCUIElement = { app.webViews.buttons["Login"] }()
    lazy var userAvatar: XCUIElement = { app.images["userAvatar"]}()
    lazy var userName: XCUIElement = { app.staticTexts["userName"] }()
    lazy var userLogin: XCUIElement = { app.staticTexts["userLogin"]}()
    lazy var tabProfile: XCUIElement = { app.tabBars.buttons.images["tab_profile_active"] }()
    lazy var buttonLogout: XCUIElement = { app.buttons["logout button"] }()
    lazy var buttonAlertYes: XCUIElement = { app.alerts.buttons["Да"] }()
    lazy var buttonAlertNo: XCUIElement = { app.alerts.buttons["Нет"] }()
    lazy var buttonNoActiveLike: XCUIElement = { app.tables.cells.firstMatch.buttons["likeNoActive"]}()
    lazy var buttonActiveLike: XCUIElement = { app.tables.cells.firstMatch.buttons["likeActive"]}()
    lazy var firstImage: XCUIElement = { app.tables.cells.firstMatch }()
    lazy var buttonNavBack: XCUIElement = { app.buttons["navBackButtonWhite"] }()
    lazy var fullImage: XCUIElement = { app.scrollViews.images.element(boundBy: 0) }()
}
