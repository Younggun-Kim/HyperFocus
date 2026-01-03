//
//  AmplitudeService.swift
//  HyperFocus
//
//  Created by 김영건 on 1/4/26.
//

struct AmplitudeService {
    static let shared = AmplitudeService()
    
    let amplitude = Amplitude(configuration: Configuration(
        apiKey: AMPLITUDE_API_KEY,
        autocapture: .all
    ))


}
