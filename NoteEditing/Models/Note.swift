import UIKit

typealias Notes = [Note]

struct Note {
    let uid: String
    var title: String
    var content: String
    var color: UIColor
    var importance: Importance
    var dateOfSelfDestruction: Date?
    
    // MARK: -
    enum Importance: String {
        case unimportant, common, important
    }
    
    // MARK: - Initialization
    init(uid: String = UUID().uuidString,
         title: String,
         content: String,
         color: UIColor = .white,
         importance: Importance,
         dateOfSelfDestruction: Date?) {
        
        self.uid = uid
        self.title = title
        self.content = content
        self.color = color
        self.importance = importance
        self.dateOfSelfDestruction = dateOfSelfDestruction
        
    }
    
}
