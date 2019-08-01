import Foundation

class BaseDBOperation: AsyncOperation {
    var notebook: FileNotebook
    
    init(notebook: FileNotebook) {
        self.notebook = notebook
        super.init()
    }
}
