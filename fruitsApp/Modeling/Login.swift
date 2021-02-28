//
//  Login.swift
//  ezhelhaa
//
//  Created by Bassam Ramadan on 3/31/20.
//  Copyright © 2020 Bassam Ramadan. All rights reserved.
//

import Foundation

struct Login: Codable {
    let code: Int?
    let message: String?
    let data: LoginData?
    
    init(code: Int, message: String, data: LoginData?) {
        self.code = code
        self.message = message
        self.data = data
    }
}
class LoginData: Codable {
    internal init(id: Int?, username: String?, city_id: String?, access_token: String?, image_path: String?) {
        self.id = id
        self.username = username
        self.city_id = city_id
        self.access_token = access_token
        self.image_path = image_path
    }
    
    let id: Int?
    let username,city_id,access_token,image_path: String?
    
}
