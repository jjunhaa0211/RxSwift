//
//  BaseURL.swift
//  RxMoya
//
//  Created by 박준하 on 2022/09/20.
//

import Foundation

extension MyAPI {
    func getBaseURL() -> URL {
        return URL(string: "https://api.flickr.com/")
    }
}
