//
//  ProfileViewTests.swift
//  ImageFeedTests
//
//  Created by Андрей Тапалов on 26.03.2024.
//
@testable import ImageFeed
import XCTest

final class ProfileViewControllerMock: ProfileViewProtocol {
    
    var model = ProfileModel(nameLabel: "", loginNameLabel: "", descriptionLabel: "")
    func updateProfileData(model: ImageFeed.ProfileModel, avatarUrl: String) {
        self.model = model
    }
}

final class ProfileViewTests: XCTestCase {
    
    override class func setUp() {
        ProfileService.shared.profileModel = .init(nameLabel: "James",
                                                   loginNameLabel: "Jameson",
                                                   descriptionLabel: "")
        ProfileImageService.shared.avatarURL = ""
        OAuth2TokenStorage.shared.token = "unit"
    }
    
    override class func tearDown() {
        ProfileService.shared.profileModel = nil
        OAuth2TokenStorage.shared.token = nil
    }
    
    func testFetchUserData(){
        let view = ProfileViewControllerMock()
        let presenter = ProfileViewPresenter(view: view)
        presenter.fetchUserData()
        XCTAssertEqual(view.model.nameLabel, "James")
    }
    
    func testLogoutRemoveAuthToken(){
        let view = ProfileViewControllerMock()
        let presenter = ProfileViewPresenter(view: view)
        presenter.logout()
        XCTAssertEqual(OAuth2TokenStorage.shared.token, nil)
    }
}
