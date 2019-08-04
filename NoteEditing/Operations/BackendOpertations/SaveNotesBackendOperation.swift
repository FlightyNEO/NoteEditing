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
        editNotes()
    }
    
    private func editNotes() {
        networkManager.editNotes(notes) { result in
            switch result {
            case .success():
                self.saveResult = .success
                self.finish()
            case .failure(let error):
                if case .cannotEdit = error {
                    self.createNotes()
                } else {
                    self.saveResult = .failure(.unreachable(message: error.localizedDescription))
                    self.finish()
                }
            }
        }
    }
    
    private func createNotes() {
        networkManager.createNotes(notes) { result in
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
