//
//  Category.swift
//  Appnomi-Shopping
//
//  Created by Yusuf Aksu on 9.09.2022.
//

import Foundation

class Category: Codable {
    var categoryId:String?
    var name:String?
        
    init(categoryId:String, name:String){
        self.categoryId = categoryId
        self.name = name
    }

}
