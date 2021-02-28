//
//  Orders.swift
//  ezhelhaa
//
//  Created by Bassam Ramadan on 4/1/20.
//  Copyright © 2020 Bassam Ramadan. All rights reserved.
//

import Foundation
struct AdminOrders: Codable {
    let code: Int?
    let message: String?
    let data: [OrdersData]
    
    init(code: Int, message: String, data: [OrdersData]) {
        self.code = code
        self.message = message
        self.data = data
    }
}
class OrdersData: Codable{
    internal init(id: Int?, createdAt: String?, deliveryDate: String?, providerNotes: String?, status: String?, purchaceId: String?, cityId: String?, userName: String?, identifier: String?) {
        self.id = id
        self.createdAt = createdAt
        self.deliveryDate = deliveryDate
        self.providerNotes = providerNotes
        self.status = status
        self.purchaceId = purchaceId
        self.cityId = cityId
        self.userName = userName
        self.identifier = identifier
    }
    
    let id: Int?
    let createdAt,deliveryDate,providerNotes,status,purchaceId,cityId,userName,identifier: String?
    enum CodingKeys: String,CodingKey{
        case deliveryDate = "delivery_date"
        case providerNotes = "provider_notes"
        case purchaceId = "purchace_id"
        case cityId = "city_id"
        case userName = "user_name"
        case identifier,status,createdAt,id
    }
}
