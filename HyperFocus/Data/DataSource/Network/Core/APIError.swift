//
//  APIError.swift
//  HyperFocus
//
//  Created by 김영건 on 12/30/25.
//

import Foundation
import Moya

/// 네트워크 API 에러 타입
public enum APIError: Error, Equatable {
    /// 네트워크 연결 실패
    case networkError(String)
    /// HTTP 상태 코드 에러
    case httpError(statusCode: Int, message: String?)
    /// 응답 파싱 실패
    case decodingError(String)
    /// 알 수 없는 에러
    case unknown(String)
    /// 요청 취소
    case cancelled
    
    /// Moya 에러를 APIError로 변환
    public static func from(_ error: MoyaError) -> APIError {
        switch error {
        case .imageMapping, .jsonMapping, .stringMapping, .objectMapping:
            return .decodingError("응답 파싱에 실패했습니다.")
        case .encodableMapping:
            return .decodingError("요청 데이터 인코딩에 실패했습니다.")
        case .requestMapping(let message):
            return .networkError("요청 생성 실패: \(message)")
        case .parameterEncoding(let error):
            return .networkError("파라미터 인코딩 실패: \(error.localizedDescription)")
        case .statusCode(let response):
            return .httpError(
                statusCode: response.statusCode,
                message: HTTPURLResponse.localizedString(forStatusCode: response.statusCode)
            )
        case .underlying(let error, let response):
            if let response = response {
                return .httpError(
                    statusCode: response.statusCode,
                    message: error.localizedDescription
                )
            }
            if (error as NSError).code == NSURLErrorCancelled {
                return .cancelled
            }
            return .networkError(error.localizedDescription)
        case .requestMapping:
            return .networkError("요청 매핑 실패")
        }
    }
    
    /// 사용자에게 표시할 메시지
    public var userMessage: String {
        switch self {
        case .networkError(let message):
            return "네트워크 오류가 발생했습니다: \(message)"
        case .httpError(let statusCode, let message):
            if let message = message {
                return message
            }
            return "서버 오류가 발생했습니다 (코드: \(statusCode))"
        case .decodingError(let message):
            return "데이터 처리 중 오류가 발생했습니다: \(message)"
        case .unknown(let message):
            return "알 수 없는 오류가 발생했습니다: \(message)"
        case .cancelled:
            return "요청이 취소되었습니다."
        }
    }
}

