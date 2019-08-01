import UIKit

extension Note {
    
    var json: [String: Any] {
        
        var json = [String: Any]()
        json["uid"] = uid
        json["title"] = title
        json["content"] = content
        
        if self.color != .white {
            json["color"] = CIColor(color: color).stringRepresentation
        }
        if importance != .common {
            json["importance"] = importance.rawValue
        }
        json["dateOfSelfDestruction"] = dateOfSelfDestruction?.timeIntervalSince1970
        
        return json
    }
    
    // MARK: -
    static func parse(json: [String: Any]) -> Note? {
        
        let uid = json["uid"] as? String ?? ""
        let title = json["title"] as? String ?? ""
        let content = json["content"] as? String ?? ""
        
        // Color
        var color = UIColor.white
        if let stringColor = json["color"] as? String {
            color = UIColor(ciColor: CIColor(string: stringColor))
        }
        
        // Importance
        let importance = Importance(rawValue: json["importance"] as? String ?? "") ?? .common
        
        // Date of self destruction
        var dateOfSelfDestruction: Date?
        if let timeInterval = json["dateOfSelfDestruction"] as? TimeInterval {
            dateOfSelfDestruction = Date(timeIntervalSince1970: timeInterval)
        }
        
        return Note(uid: uid, title: title, content: content, color: color, importance: importance, dateOfSelfDestruction: dateOfSelfDestruction)
        
    }
    
}

extension Note: Equatable {
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.uid == rhs.uid
    }
}

extension Note: CustomStringConvertible {
    var description: String {
        return "uid: " + uid + ", title: " + title
    }
}
