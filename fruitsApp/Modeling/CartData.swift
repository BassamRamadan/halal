//
//  CartData.swift
//  ezhelhaa
//
//  Created by Bassam Ramadan on 3/30/20.
//  Copyright © 2020 Bassam Ramadan. All rights reserved.
//

import Foundation
class FulCartData: NSObject, NSCoding{
    func encode(with aCoder: NSCoder) {
        aCoder.encode(data, forKey: "data")
    }
    required init?(coder aDecoder: NSCoder) {
        data = aDecoder.decodeObject(forKey: "data") as? [CartData]? ?? []
    }
    let data: [CartData]?
    init(data: [CartData]?) {
        self.data = data
    }
}
class CartData: NSObject, NSCoding {
    
    internal init(id: Int?, name: String?,imagePath: String?, price: Double?, mincementPrice: Double?, shin: Bool?, head: Bool?, bowels: Bool?, cocking: CartOptionDetails?, packages: CartOptionDetails?, sizes: CartOptionDetails?,slices: CartOptionDetails?,quantity:Int?,minQuantity:Int?,totalPrice:Double,notes: String?) {
        self.id = id
        self.name = name
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
        self.quantity = quantity
        self.minQuantity = minQuantity
        self.totalPrice = totalPrice
        self.notes = notes
    }
    
    let id: Int?
    let name,imagePath,notes: String?
    var totalPrice,price,mincementPrice: Double?
    var quantity,minQuantity:Int?
    let shin,head,bowels: Bool?
    let cocking: CartOptionDetails?
    let packages: CartOptionDetails?
    let sizes: CartOptionDetails?
    let slices: CartOptionDetails?
    enum CodingKeys: String,CodingKey{
        case imagePath = "image_path"
        case mincementPrice = "mincement_price"
        case name,price,cocking,packages,sizes,id,shin,head,bowels,slices,totalPrice
        case quantity,minQuantity,notes
    }
    
    // MARK: - NSCoding
    required init(coder aDecoder: NSCoder) {
        id = aDecoder.decodeObject(forKey: "id") as? Int
        name = aDecoder.decodeObject(forKey: "name") as? String
        imagePath = aDecoder.decodeObject(forKey: "imagePath") as? String
        price = aDecoder.decodeObject(forKey: "price") as? Double
        mincementPrice = aDecoder.decodeObject(forKey: "mincementPrice") as? Double
        totalPrice = aDecoder.decodeObject(forKey: "totalPrice") as? Double
        minQuantity = aDecoder.decodeObject(forKey: "minQuantity") as? Int
        quantity = aDecoder.decodeObject(forKey: "quantity") as? Int
        shin = aDecoder.decodeObject(forKey: "shin") as? Bool
        head = aDecoder.decodeObject(forKey: "head") as? Bool
        bowels = aDecoder.decodeObject(forKey: "bowels") as? Bool
        cocking = aDecoder.decodeObject(forKey: "cocking") as? CartOptionDetails
        packages = aDecoder.decodeObject(forKey: "packages") as? CartOptionDetails
        sizes = aDecoder.decodeObject(forKey: "sizes") as? CartOptionDetails
        slices = aDecoder.decodeObject(forKey: "slices") as? CartOptionDetails
        notes = aDecoder.decodeObject(forKey: "notes") as? String
    }
    
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: "id")
        aCoder.encode(name, forKey: "name")
        aCoder.encode(imagePath, forKey: "imagePath")
        aCoder.encode(mincementPrice, forKey: "mincementPrice")
        aCoder.encode(shin, forKey: "shin")
        aCoder.encode(head, forKey: "head")
        aCoder.encode(bowels, forKey: "bowels")
        aCoder.encode(cocking, forKey: "cocking")
        aCoder.encode(packages, forKey: "packages")
        aCoder.encode(sizes, forKey: "sizes")
        aCoder.encode(slices, forKey: "slices")
        aCoder.encode(price, forKey: "price")
        aCoder.encode(notes, forKey: "notes")
        aCoder.encode(quantity, forKey: "quantity")
        aCoder.encode(totalPrice, forKey: "totalPrice")
        aCoder.encode(minQuantity, forKey: "minQuantity")
    }
}
class CartOptionDetails: NSObject, NSCoding {
    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: "id")
        aCoder.encode(name, forKey: "name")
        aCoder.encode(price, forKey: "price")
        aCoder.encode(sacrificeId, forKey: "sacrificeId")
    }
    
    required init?(coder aDecoder: NSCoder) {
        id = aDecoder.decodeObject(forKey: "id") as? Int
        name = aDecoder.decodeObject(forKey: "name") as? String
        price = aDecoder.decodeObject(forKey: "price") as? String
        sacrificeId = aDecoder.decodeObject(forKey: "sacrificeId") as? String
    }
    
    internal init(id: Int?, name: String?, price: String?, sacrificeId: String?) {
        self.id = id
        self.name = name
        self.price = price
        self.sacrificeId = sacrificeId
    }
    
    let id: Int?
    let name,price,sacrificeId: String?
    enum CodingKeys: String,CodingKey{
        case sacrificeId = "sacrifice_id"
        case name,price,id
    }
}
