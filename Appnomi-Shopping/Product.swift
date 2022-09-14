//
//  Product.swift
//  Appnomi-Shopping
//
//  Created by Yusuf Aksu on 9.09.2022.
//

import Foundation
// MARK: - Product
class Product: Codable  {
    var id:String?
    var images:[Image]?
    var title:String?
    var price:Double?
    var campaignPrice:Double?
    var currency:String?
        
    init(id:String, images: [Image], title:String, price:Double, campaignPrice:Double, currency:String){
        self.id = id
        self.images = images
        self.title = title
        self.price = price
        self.campaignPrice = campaignPrice
        self.currency = currency
    }

}

// MARK: - Image
class Image: Codable {
    let t: String?
    let n: String?

    init(t: String, n: String) {
        self.t = t
        self.n = n
    }
}

