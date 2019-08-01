import Foundation

class SaveNoteDBOperation: BaseDBOperation {
    private let note: Note
    private(set) var savingIndex: Int?
    
    init(note: Note, notebook: FileNotebook) {
        self.note = note
        super.init(notebook: notebook)
    }
    
    override func main() {
        print("SaveNoteDBOperation", #function)
        savingIndex = notebook.put(note)
        try? notebook.write()
        finish()
    }
}
