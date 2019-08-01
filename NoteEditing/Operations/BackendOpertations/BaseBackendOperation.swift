import Foundation

enum NetworkError: Error {
    case unreachable(message: String)
}

class BaseBackendOperation: AsyncOperation {
    override init() {
        super.init()
    }
}
