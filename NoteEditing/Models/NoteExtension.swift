import UIKit

extension Note {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        uid = try container.decode(String.self, forKey: .uid)
        title = try container.decode(String.self, forKey: .title)
        content = try container.decode(String.self, forKey: .content)
        
        // Color
        if let stringColor = try? container.decode(String.self, forKey: .color) {
            color = UIColor(ciColor: CIColor(string: stringColor))
        } else {
            color = UIColor.white
        }
        
        // ImportanceString
        if let importanceString = try? container.decode(String.self, forKey: .importance) {
            importance = Importance(rawValue: importanceString) ?? .common
        } else {
            importance = .common
        }
        
        // Date of self destruction
        if let timeInterval = try? container.decode(TimeInterval.self, forKey: .dateOfSelfDestruction) {
            dateOfSelfDestruction = Date(timeIntervalSince1970: timeInterval)
        } else {
            dateOfSelfDestruction = nil
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(uid, forKey: .uid)
        try container.encode(title, forKey: .title)
        try container.encode(content, forKey: .content)
        
        if self.color != .white {
            let colorString = CIColor(color: color).stringRepresentation
            try container.encode(colorString, forKey: .color)
        }
        
        if importance != .common {
            try container.encode(importance.rawValue, forKey: .importance)
        }
        
        try container.encode(dateOfSelfDestruction?.timeIntervalSince1970, forKey: .dateOfSelfDestruction)
    }
}

extension Note: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(uid)
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
