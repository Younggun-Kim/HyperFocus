public enum AppResult<Success> {
  case success(Success)
  case failure(Error)
}
