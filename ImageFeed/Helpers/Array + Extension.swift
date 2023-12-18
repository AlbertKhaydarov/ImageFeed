//
//  Array + Extension.swift
//  ImageFeed
//
//  Created by Альберт Хайдаров on 18.12.2023.
//

import Foundation

extension Array {
    func withReplaced(itemAt index: Int, newValue: Element) -> [Element] {
        var newArray = self
        if index < newArray.count && index >= 0 {
            newArray[index] = newValue
        }
        return newArray
    }
}

