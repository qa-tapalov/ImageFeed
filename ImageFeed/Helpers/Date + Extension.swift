//
//  Date + Extension.swift
//  ImageFeed
//
//  Created by Андрей Тапалов on 17.01.2024.
//

import Foundation

private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .long
    formatter.timeStyle = .none
    return formatter
}()

extension Date {
    var dateFormat: String { dateFormatter.string(from: self) }
}
