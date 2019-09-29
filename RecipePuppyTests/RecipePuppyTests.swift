//
//  RecipePuppyTests.swift
//  RecipePuppyTests
//
//  Created by Jorge Amores Ortiz on 27/09/2019.
//  Copyright © 2019 Jorge Amores Ortiz. All rights reserved.
//

import XCTest
import Alamofire
import SwiftyJSON
@testable import RecipePuppy

class RecipePuppyTests: XCTestCase {
    
    var vc: ListRecipeVC!
    var baseUrl: String = "http://www.recipepuppy.com/api/"

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        let storyBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
        vc = storyBoard.instantiateInitialViewController()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testGetAllRecipes() {
        Alamofire.request("\(baseUrl)").responseJSON { (response) in
            if response.result.value != nil {
                XCTAssert(true)
            } else{
                XCTAssert(false)
            }
        }
    }
    
    func testGetRecipesByData() {
        Alamofire.request("\(baseUrl)",
            parameters: ["i":"", "q":"", "p":1],
            encoding: URLEncoding.default)
            .responseJSON { (response) in
                if response.result.value != nil {
                XCTAssert(true)
            } else{
                XCTAssert(false)
            }
        }
    }

}
