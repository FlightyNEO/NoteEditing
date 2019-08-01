import Foundation

class FileNotebook {
    
    enum DataManagerError: Error {
        case canNotFetchNote(message: String)
    }
    
    private struct Path {
        private init() { }
        
        static var component = "Notes_Dictionary"
        static var `extension` = "plist"
    }
    
    // MARK: - Initializations
    
    convenience init(notes: Notes) {
        self.init()
        self.add(notes)
    }
    
    // MARK: - Properties
    private(set) var notes = Notes()
    
    private static var url: URL {
        let documentDerictory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let archiveURL = documentDerictory.appendingPathComponent(Path.component).appendingPathExtension(Path.extension)
        
        return archiveURL
    }
    
    // MARK: - Public methods
    
    /// Add note to first position or replace.
    /// - Parameter note: added note
    /// - Return: index at added note
    public func put(_ note: Note) -> Int {
        guard let index = notes.firstIndex(of: note) else {
            notes.insert(note, at: 0)
            return 0
        }
        notes[index] = note
        return index
    }
    
    /// Add notes to the end of the array
    /// - Parameter notes: added notes
    public func add(_ notes: Notes) {
        self.notes += notes
        self.notes.removeDuplicates()
    }
    
    /// Remove note from array
    /// - Parameter uid: removed note uid
    public func remove(atUID uid: String) -> Int? {
        guard let index = notes.firstIndex(where: { $0.uid == uid } ) else { return nil }
        notes.remove(at: index)
        return index
    }
    
    /// Write to file
    public func write() throws {
        do {
            let json = notes.map { $0.json }
            let data = try JSONSerialization.data(withJSONObject: json, options: [])
            try data.write(to: FileNotebook.url, options: NSData.WritingOptions.noFileProtection)
        } catch let error {
            throw error
        }
    }
    
    /// Read from file
    public class func read() throws -> FileNotebook {
        do {
            let data = try Data(contentsOf: FileNotebook.url)
            guard let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] else {
                throw DataManagerError.canNotFetchNote(message: "Can't fetch emojis from derictory")
            }
            
            let notebook = FileNotebook()
            json.forEach {
                guard let note = Note.parse(json: $0) else { return }
                _ = notebook.put(note)
            }
            
            return notebook
            
        } catch let error {
            throw error
        }
    }
    
}
