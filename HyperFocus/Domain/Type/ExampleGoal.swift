//
//  ExampleGoal.swift
//  HyperFocus
//
//  Created by 김영건 on 12/28/25.
//


enum ExampleGoal: CaseIterable {
    case ReadingBook
    case HomeWork
    case Running
}

extension ExampleGoal {
    var title: String {
        switch self {
        case .ReadingBook: return "Reading Book"
        case .HomeWork: return "Homework"
        case .Running: return "Running"
        }
    }
}
