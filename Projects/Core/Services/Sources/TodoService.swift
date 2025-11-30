import Foundation
import Models

public protocol TodoServiceProtocol: Sendable {
  func fetchTasks() async -> [TaskEntity]
}

public final class TodoService: TodoServiceProtocol {
  public init() {}

  public func fetchTasks() async -> [TaskEntity] {
    return [
      TaskEntity(id: UUID().uuidString, title: "Sample task"),
      TaskEntity(id: UUID().uuidString, title: "Another task", isCompleted: true)
    ]
  }
}
