//
//  ServiceError.swift
//  recipesbook
//
//  Created by Pere Almendro on 10/12/2019.
//  Copyright © 2019 Pere Almendro. All rights reserved.
//

import Foundation

enum ErrorType: Int {
    case noResults
    case invalidRequest
    case operationFailed
}

struct ServiceError: Error {
    var type: ErrorType
    var localizedDescription: String
}
