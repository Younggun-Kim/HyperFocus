//
//  NetworkHeader.swift
//  HyperFocus
//
//  Created by 김영건 on 1/4/26.
//

import Foundation


struct NetworkHeader {
    
    static let basic: [String: String] =  [
        "Content-Type": "application/json",
        "Accept": "application/json"
    ]
    
    static let authorization: [String: String] = {
        var result = basic
        result["Authorization"] = ""
        return result
    }()
}
