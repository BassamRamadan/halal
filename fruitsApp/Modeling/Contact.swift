//
//  Contact.swift
//  ezhelhaa
//
//  Created by Bassam Ramadan on 3/28/20.
//  Copyright © 2020 Bassam Ramadan. All rights reserved.
//

import Foundation
struct AppContacts: Codable {
    let code: Int?
    let message: String?
    let data: ContactsData?
    
    init(code: Int, message: String, data: ContactsData?) {
        self.code = code
        self.message = message
        self.data = data
    }
}
class ContactsData: Codable {
    internal init(lat: String?, lon: String?, phone: String?, whatsapp: String?, address: String?) {
        self.lat = lat
        self.lon = lon
        self.phone = phone
        self.whatsapp = whatsapp
        self.address = address
    }
    
    let lat,lon,phone,whatsapp,address: String?
}
