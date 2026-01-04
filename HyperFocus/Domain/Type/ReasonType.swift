//
//  ExampleGoal.swift
//  ReasonType
//
//  Created by 김영건 on 12/28/25.
//


enum ReasonType: CaseIterable, Equatable, Hashable {
    case readingBook
    case homework
    case running
    case custom(String)
    
    static var allCases: [ReasonType] =  [.readingBook, .homework, .running]
    
    init (rawValue: String) {
        switch rawValue {
        case ReasonType.readingBook.title: self = .readingBook
        case ReasonType.homework.title: self = .homework
        case ReasonType.running.title: self = .running
        default: self = .custom(rawValue)
        }
    }
}

extension ReasonType {
    var title: String {
        switch self {
        case .readingBook: return "Reading Book"
        case .homework: return "Homework"
        case .running: return "Running"
        case .custom(let title): return title
        }
    }
    
    var isValid: Bool {
        return title.count <= 60
    }
}
