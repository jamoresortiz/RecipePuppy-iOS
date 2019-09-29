//
//  File.swift
//  RecipePuppy
//
//  Created by Jorge Amores Ortiz on 28/09/2019.
//  Copyright © 2019 Jorge Amores Ortiz. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class RecipeService {
    var baseUrl: String = "http://www.recipepuppy.com/api/"
    
    func getRecipes(completion: @escaping (_ result: RequestResult<[Recipe]>)-> Void) {
        Alamofire.request("\(baseUrl)").responseJSON { (response) in
            
            if let result = response.result.value {
                let json = JSON(result)
                var listRecipe = [Recipe]()
                let recipes = json["results"].arrayValue
                for recipe in recipes{
                    let data = Recipe(withJSON: recipe)
                    listRecipe.append(data)
                }
                
                completion(RequestResult.done(listRecipe))
                
            } else{
                completion(RequestResult.failed(message: response.error?.localizedDescription ?? "error"))
            }
        }
    }
    
    func getRecipes(ingredients: String, query: String, page: Int, completion: @escaping (_ result: RequestResult<[Recipe]>)-> Void) {
        Alamofire.request("\(baseUrl)",
            parameters: ["i":ingredients, "q":query, "p":page],
            encoding: URLEncoding.default)
            .responseJSON { (response) in
                
            if let result = response.result.value {
                let json = JSON(result)
                var listRecipe = [Recipe]()
                let recipes = json["results"].arrayValue
                for recipe in recipes{
                    let data = Recipe(withJSON: recipe)
                    listRecipe.append(data)
                }
                
                completion(RequestResult.done(listRecipe))
                
            } else{
                completion(RequestResult.failed(message: response.error?.localizedDescription ?? "error"))
            }
        }
    }
}
