//
//  CleanCookieStorage.swift
//  ImageFeed
//
//  Created by Альберт Хайдаров on 20.12.2023.
//

import Foundation
import WebKit

final class CleanCookieStorage {
    static func clean() {
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            records.forEach { record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
            }
        }
    }
}
