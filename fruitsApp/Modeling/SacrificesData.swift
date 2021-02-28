//
//  Sacrifices.swift
//  ezhelhaa
//
//  Created by Bassam Ramadan on 3/27/20.
//  Copyright © 2020 Bassam Ramadan. All rights reserved.
//

import Foundation
struct SacrificesData: Codable {
    let code: Int?
    let message: String?
    let data: [SacrificesDetails]
    
    init(code: Int, message: String, data: [SacrificesDetails]) {
        self.code = code
        self.message = message
        self.data = data
    }
}
struct SacrificesDetails: Codable {
    internal init(id: Int, name: String?, description: String?, imagePath: String?, price: String?, mincementPrice: String?, shin: Bool, head: Bool, bowels: Bool, cocking: [cockingDetails]?, packages: [cockingDetails]?, sizes: [cockingDetails]?,slices: [cockingDetails]?) {
        self.id = id
        self.name = name
        self.description = description
        self.imagePath = imagePath
        self.price = price
        self.mincementPrice = mincementPrice
        self.shin = shin
        self.head = head
        self.bowels = bowels
        self.cocking = cocking
        self.packages = packages
        self.sizes = sizes
        self.slices = slices
    }
    
    let id: Int
    let name,description,imagePath,price,mincementPrice: String?
    let shin,head,bowels: Bool
    let cocking: [cockingDetails]?
    let packages: [cockingDetails]?
    let sizes: [cockingDetails]?
    let slices: [cockingDetails]?
     enum CodingKeys: String,CodingKey{
        case imagePath = "image_path"
        case mincementPrice = "mincement_price"
        case name,description,price,cocking,packages,sizes,id,shin,head,bowels,slices
    }
}
struct cockingDetails: Codable {
    internal init(id: Int, name: String?, price: String?, sacrificeId: String?) {
        self.id = id
        self.name = name
        self.price = price
        self.sacrificeId = sacrificeId
    }
    
    let id: Int
    let name,price,sacrificeId: String?
     enum CodingKeys: String,CodingKey{
        case sacrificeId = "sacrifice_id"
        case name,price,id
    }
}

