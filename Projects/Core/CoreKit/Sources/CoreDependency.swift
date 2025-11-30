import Foundation
import Services

public protocol DependencyInjectable {}

public struct CoreEnvironment {
  public let todoService: TodoServiceProtocol

  public init(todoService: TodoServiceProtocol = TodoService()) {
    self.todoService = todoService
  }
}
