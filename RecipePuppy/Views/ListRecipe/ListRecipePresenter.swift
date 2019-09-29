//
//  ViewControllerPresenter.swift
//  RecipePuppy
//
//  Created by Jorge Amores Ortiz on 28/09/2019.
//  Copyright © 2019 Jorge Amores Ortiz. All rights reserved.
//

import Foundation

protocol ListRecipeView {
    func displayLoading(message: String, nextPage: Bool)
    func dismissLoading()
    func showFailed(message: String)
    func showListRecipe(listRecipe : [Recipe], nextPage: Bool)
}

class ListRecipePresenter {
    private let service: RecipeService!
    private var viewListRecipe: ListRecipeView?
    
    init() {
        self.service = RecipeService()
    }
    
    func attachView(view : ListRecipeView?){
        viewListRecipe = view
    }
    
    func detachView() {
        viewListRecipe = nil
    }
    
    func returnStringIngredients(arrIngredients: [String]) -> String {
        var ingredients: String = ""
        
        if arrIngredients.count > 0 {
            for i in arrIngredients {
                ingredients += i + ","
            }
            
            ingredients.removeLast()
        }
        return ingredients
    }
    
    func getAllRecipes() {
        self.viewListRecipe?.displayLoading(message: "Please wait...", nextPage: false)
        service.getRecipes { (response) in
            self.viewListRecipe?.dismissLoading()
            
            switch response {
            case.done(value: let result):
                self.viewListRecipe?.showListRecipe(listRecipe: result, nextPage: false)
                break
                
            case .failed(let message):
                self.viewListRecipe?.showFailed(message: message)
                break
            }
        }
    }
    
    func getRecipesByData(ingredients: String, query: String, page: Int) {
        if page > 1 {
            self.viewListRecipe?.displayLoading(message: "Please wait...", nextPage: true)
        } else {
            self.viewListRecipe?.displayLoading(message: "Please wait...", nextPage: false)
        }
        service.getRecipes(ingredients: ingredients, query: query, page: page) { (response) in
            self.viewListRecipe?.dismissLoading()
            
            switch response {
            case.done(value: let result):
                if page > 1 {
                    self.viewListRecipe?.showListRecipe(listRecipe: result, nextPage: true)
                }
                else {
                    self.viewListRecipe?.showListRecipe(listRecipe: result, nextPage: false)
                }
                break
                
            case .failed(let message):
                self.viewListRecipe?.showFailed(message: message)
                break
            }
        }
    }
}
