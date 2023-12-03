//
//  StorageProtocol.swift
//  ImageFeed
//
//  Created by Альберт Хайдаров on 03.12.2023.
//

import Foundation

//MARK: -  add protocol for storage (todo  a keychain)
protocol StorageProtocol {
    var token: String? { get set }
}
