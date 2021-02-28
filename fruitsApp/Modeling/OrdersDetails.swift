//
//  OrdersDetails.swift
//  ezhelhaa
//
//  Created by Bassam Ramadan on 4/4/20.
//  Copyright © 2020 Bassam Ramadan. All rights reserved.
//

import Foundation

struct OrdersInfo: Codable {
    internal init(code: Int?, message: String?, data: [OrdersDetails]) {
        self.code = code
        self.message = message
        self.data = data
    }
    
    let code: Int?
    let message: String?
    let data: [OrdersDetails]

}

// MARK: - Datum
struct OrdersDetails: Codable {
    internal init(id: Int?, userName: String?, userPhone: String?, address: String?, lat: String?, lon: String?, quantity: String?, mincementQuantity: String?, price: String?, mincementPrice: String?, wantsShin: String?, wantsHead: String?, wantsBowels: String?, taxValue: String?, notes: String?, sacrificeID: String?, sacrificeSizeName: String?, sacrificeSizePrice: String?, sacrificeSliceName: String?, sacrificeSlicePrice: String?, sacrificePackageName: String?, sacrificePackagePrice: String?, sacrificeCockingName: String?, sacrificeCockingPrice: String?, areaID: String?, cityID: String?, totalCost: String?, sacrifice: Sacrifice?, city: Details?) {
        self.id = id
        self.userName = userName
        self.userPhone = userPhone
        self.address = address
        self.lat = lat
        self.lon = lon
        self.quantity = quantity
        self.mincementQuantity = mincementQuantity
        self.price = price
        self.mincementPrice = mincementPrice
        self.wantsShin = wantsShin
        self.wantsHead = wantsHead
        self.wantsBowels = wantsBowels
        self.taxValue = taxValue
        self.notes = notes
        self.sacrificeID = sacrificeID
        self.sacrificeSizeName = sacrificeSizeName
        self.sacrificeSizePrice = sacrificeSizePrice
        self.sacrificeSliceName = sacrificeSliceName
        self.sacrificeSlicePrice = sacrificeSlicePrice
        self.sacrificePackageName = sacrificePackageName
        self.sacrificePackagePrice = sacrificePackagePrice
        self.sacrificeCockingName = sacrificeCockingName
        self.sacrificeCockingPrice = sacrificeCockingPrice
        self.areaID = areaID
        self.cityID = cityID
        self.totalCost = totalCost
        self.sacrifice = sacrifice
        self.city = city
    }
    
    let id: Int?
    let userName, userPhone, address, lat: String?
    let lon, quantity, mincementQuantity, price: String?
    let mincementPrice, wantsShin, wantsHead, wantsBowels: String?
    let taxValue, notes, sacrificeID, sacrificeSizeName: String?
    let sacrificeSizePrice, sacrificeSliceName, sacrificeSlicePrice, sacrificePackageName: String?
    let sacrificePackagePrice, sacrificeCockingName, sacrificeCockingPrice, areaID: String?
    let cityID, totalCost: String?
    let sacrifice: Sacrifice?
    let city: Details?
    
    enum CodingKeys: String, CodingKey {
        case id
        case userName = "user_name"
        case userPhone = "user_phone"
        case address, lat, lon, quantity
        case mincementQuantity = "mincement_quantity"
        case price
        case mincementPrice = "mincement_price"
        case wantsShin = "wants_shin"
        case wantsHead = "wants_head"
        case wantsBowels = "wants_bowels"
        case taxValue = "tax_value"
        case notes
        case sacrificeID = "sacrifice_id"
        case sacrificeSizeName = "sacrifice_size_name"
        case sacrificeSizePrice = "sacrifice_size_price"
        case sacrificeSliceName = "sacrifice_slice_name"
        case sacrificeSlicePrice = "sacrifice_slice_price"
        case sacrificePackageName = "sacrifice_package_name"
        case sacrificePackagePrice = "sacrifice_package_price"
        case sacrificeCockingName = "sacrifice_cocking_name"
        case sacrificeCockingPrice = "sacrifice_cocking_price"
        case areaID = "area_id"
        case cityID = "city_id"
        case totalCost = "total_cost"
        case sacrifice, city
    }
}
// MARK: - Sacrifice
struct Sacrifice: Codable {
    internal init(id: Int?, name: String?, imagePath: String?) {
        self.id = id
        self.name = name
        self.imagePath = imagePath
    }
    
    let id: Int?
    let name: String?
    let imagePath: String?
    
    enum CodingKeys: String, CodingKey {
        case id, name
        case imagePath = "image_path"
    }
}
