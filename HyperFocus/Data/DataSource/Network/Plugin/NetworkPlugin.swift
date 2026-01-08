//
//  NetworkPlugin.swift
//  HyperFocus
//
//  Created by 김영건 on 12/30/25.
//

import Foundation
import Moya

/// 네트워크 로깅 플러그인
public final class NetworkLoggingPlugin: PluginType {
    private let verbose: Bool
    
    public init(verbose: Bool = true) {
        self.verbose = verbose
    }
    
    public func willSend(_ request: RequestType, target: TargetType) {
        guard verbose else { return }
        
        if let httpRequest = request.request {
            print("🌐 [REQUEST] \(httpRequest.httpMethod ?? "?") \(httpRequest.url?.absoluteString ?? "?")")
            
            if let headers = httpRequest.allHTTPHeaderFields, !headers.isEmpty {
                print("📋 [HEADERS] \(headers)")
            }
            
            if let body = httpRequest.httpBody,
               let bodyString = String(data: body, encoding: .utf8) {
                print("📦 [BODY] \(bodyString)")
            }
        }
    }
    
    public func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
        guard verbose else { return }
        
        switch result {
        case .success(let response):
            let statusCode = response.statusCode
            let statusEmoji = (200...299).contains(statusCode) ? "✅" : "❌"
            print("\(statusEmoji) [RESPONSE] \(statusCode) \(target.path)")
            
            if let dataString = String(data: response.data, encoding: .utf8) {
                print("📥 [DATA] \(dataString)")
            }
        case .failure(let error):
            print("❌ [ERROR] \(target.path) - \(error.localizedDescription)")
        }
    }
}
