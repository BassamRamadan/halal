//
//  Content.swift
//  ezhelhaa
//
//  Created by Bassam Ramadan on 3/27/20.
//  Copyright © 2020 Bassam Ramadan. All rights reserved.
//

import Foundation
struct contents: Codable {
    let code: Int?
    let message: String?
    let data: Content?
    
    init(code: Int, message: String, data: Content?) {
        self.code = code
        self.message = message
        self.data = data
    }
}
struct Content: Codable {
    init(about: ContentDetails?, workTimes: ContentDetails?, ourway: ContentDetails?) {
        self.about = about
        self.workTimes = workTimes
        self.ourway = ourway
    }
    let about,workTimes,ourway: ContentDetails?
    enum CodingKeys: String,CodingKey{
        case workTimes = "work_times"
        case about,ourway
    }
}
struct ContentDetails: Codable{
     init(content: String?) {
        self.content = content
    }
    let content: String?
}
