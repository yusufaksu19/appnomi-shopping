//
//  Detail.swift
//  Appnomi-Shopping
//
//  Created by Yusuf Aksu on 9.09.2022.
//

import Foundation

class Detail: Codable {
    var images:[Image]
    var title:String?
    var price:Double?
    var campaignPrice:Double?
    var description:String?
    var currency:String?
        
    init(images:[Image], title:String, price:Double, campaignPrice:Double,description:String, currency:String){
        self.images = images
        self.title = title
        self.price = price
        self.campaignPrice = campaignPrice
        self.description = description
        self.currency = currency
    }

}

