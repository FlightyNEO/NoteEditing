import Foundation

//enum NetworkError: Error {
//    case unreachable(message: String)
//}

enum SaveNotesBackendResult {
    case success
    case failure(NetworkError)
}

class SaveNotesBackendOperation: BaseBackendOperation {
    var result: SaveNotesBackendResult?
    
    init(notes: Notes?) {
        super.init()
    }
    
    override func main() {
        //sleep(2) // Что-то происходит
        print("SaveNotesBackendOperation", #function)
        // Сохраняем в бэкэнд
        // if success
        //result = .success
        // else if failure
        result = .failure(.unreachable(message: "Failure mock"))
        finish()
    }
}
