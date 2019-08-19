import Foundation

enum SaveNoteError: Error {
    case unreachable(message: String)
}

class SaveNoteOperation: AsyncOperation {
    
    typealias CompletionHandler = (Result<Int?, SaveNoteError>) -> Void
    
    private let note: Note
    private let notebook: FileNotebook
    private let saveToDb: SaveNoteDBOperation
    private var saveToBackend: SaveNotesBackendOperation?
    
    private var completion: CompletionHandler
    
    init(note: Note, notebook: FileNotebook, backendQueue: OperationQueue, dbQueue: OperationQueue, completion: @escaping CompletionHandler) {
        self.note = note
        self.notebook = notebook
        self.completion = completion
        
        saveToDb = SaveNoteDBOperation(note: note, notebook: notebook)
        
        super.init()
        
        let saveToBackend = SaveNotesBackendOperation()
        saveToDb.completionBlock = {
            saveToBackend.notes = notebook.notes
            self.saveToBackend = saveToBackend
            backendQueue.addOperation(saveToBackend)
        }

        addDependency(saveToBackend)
        addDependency(saveToDb)
        
        dbQueue.addOperation(saveToDb)
    }
    
    override func main() {
        print("SaveNoteOperation", #function)
        completionBlock = {
            self.completion(.success(self.saveToDb.savingIndex))
        }
        finish()
    }
}
