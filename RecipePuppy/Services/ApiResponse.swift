//
//  ApiResponse.swift
//  RecipePuppy
//
//  Created by Jorge Amores Ortiz on 28/09/2019.
//  Copyright © 2019 Jorge Amores Ortiz. All rights reserved.
//

import Foundation
import SwiftyJSON

public enum RequestResult<T>{
    case done(T)
    case failed(message: String)
}

public enum RequestProgressResult<T>{
    case done(T)
    case failed(message: String)
    case onProgress(progress: Double)
}

class APIError {
    var message: String = ""
    typealias BuilderClosure = (APIError) -> ()
    init(buildError: BuilderClosure) {
        buildError(self)
    }
}

struct ApiErrorResponse {
    static func processAPIFailed(data: Any) -> APIError {
        let dataJSON = JSON(data)
        let errorMessage = dataJSON["error"]["message"].stringValue
        let error = dataJSON["error"].stringValue
        let message = (errorMessage.isEmpty) ? error : errorMessage
        let result = APIError { api in
            api.message = (message.isEmpty) ? "Cannot process your request. Please try again later." : message
        }
        
        return result
    }
    
}
