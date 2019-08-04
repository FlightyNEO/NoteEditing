import Foundation

//enum NetworkError: Error {
//    case unreachable(message: String)
//}

enum SaveNotesBackendResult {
    case success
    case failure(NetworkError)
}

class SaveNotesBackendOperation: BaseBackendOperation {
    var saveResult: SaveNotesBackendResult?
    var notes: Notes = []
    private let networkManager = NetworkManager.manager
    
    override func main() {
        print("SaveNotesBackendOperation", #function)
        do {
            let data = try JSONEncoder().encode(notes)
            guard let content = String(data: data, encoding: .utf8) else {
                self.saveResult = .failure(.unreachable(message: "error"))
                finish()
                return
            }
            let files = [networkManager.fileName : content]
            let gist = GistPatch(information: networkManager.fileName, files: files)
            
            networkManager.editGist(gist) { result in
                switch result {
                case .success():
                    self.saveResult = .success
                    self.finish()
                case .failure(let error):
                    if case .cannotEdit = error {
                        self.createGist(gist)
                    } else {
                        self.saveResult = .failure(.unreachable(message: error.localizedDescription))
                        self.finish()
                    }
                }
            }
        } catch {
            saveResult = .failure(.unreachable(message: error.localizedDescription))
            finish()
        }
    }
    
    private func createGist(_ gist: GistPatch) {
        networkManager.createGist(gist) { result in
            switch result {
            case .success(_):
                self.saveResult = .success
            case .failure(let error):
                self.saveResult = .failure(.unreachable(message: error.localizedDescription))
            }
            self.finish()
        }
    }
    
}
