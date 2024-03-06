//
//  UIBlockingProgressHUD.swift
//  ImageFeed
//
//  Created by Андрей Тапалов on 24.02.2024.
//

import UIKit
import ProgressHUD

final class UIBlockingProgressHUD {
    private static var window: UIWindow? {
        return UIApplication.shared.windows.first
    }

    static func show(){
        window?.isUserInteractionEnabled = false
        setupProgressHUD()
    }
    
    static func dismiss() {
        window?.isUserInteractionEnabled = true
        ProgressHUD.dismiss()
    }
    
    static func setupProgressHUD(){
        ProgressHUD.animationType = .activityIndicator
        ProgressHUD.mediaSize = 30
        ProgressHUD.marginSize = 30
        ProgressHUD.animate()
    }
}
