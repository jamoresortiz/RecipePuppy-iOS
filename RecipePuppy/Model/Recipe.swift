//
//  Recipe.swift
//  RecipePuppy
//
//  Created by Jorge Amores Ortiz on 28/09/2019.
//  Copyright © 2019 Jorge Amores Ortiz. All rights reserved.
//

import Foundation
import SwiftyJSON

class Recipe {
    var title: String = ""
    var href: String = ""
    var ingredients: String = ""
    var thumbnail: String = ""
    
    init(withJSON data: JSON) {
        self.title = data["title"].stringValue
        self.href = data["href"].stringValue
        self.ingredients = data["ingredients"].stringValue
        self.thumbnail = data["thumbnail"].stringValue
    }
}
