public struct TaskEntity: Sendable, Equatable {
  public let id: String
  public let title: String
  public let isCompleted: Bool

  public init(id: String, title: String, isCompleted: Bool = false) {
    self.id = id
    self.title = title
    self.isCompleted = isCompleted
  }
}
