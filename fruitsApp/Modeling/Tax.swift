//
//  Tax.swift
//  ezhelhaa
//
//  Created by Bassam Ramadan on 4/5/20.
//  Copyright © 2020 Bassam Ramadan. All rights reserved.
//

import Foundation

struct tax: Codable {
    internal init(code: Int?, message: String?, data: taxValue) {
        self.code = code
        self.message = message
        self.data = data
    }
    
    let code: Int?
    let message: String?
    let data: taxValue
    
}
struct taxValue: Codable {
    let tax: String?
    init(tax: String?) {
        self.tax = tax
    }
}
