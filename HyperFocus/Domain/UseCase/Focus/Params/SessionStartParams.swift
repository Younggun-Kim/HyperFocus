//
//  SessionStartParams.swift
//  HyperFocus
//
//  Created by 김영건 on 1/4/26.
//

import Foundation


public struct SessionStartParams: Sendable {
    var name: String?
    var duration: DurationType
    var inputMethod: InputMethodType?
    
    // TODO: - 어떤 값이 들어가야 하는가
    var ambientSound: String?
}
