
import SwiftUI

protocol Sheet {
    
    var id: UUID { get }
    var author: Player { get }
    var number: Int { get }
}

extension Sheet {
    
    func getId() -> UUID {
        return self.id
    }
    
    func getAuthor() -> Player {
        return self.author
    }
    
    func getNumber() -> Int {
        return self.number
    }
}

struct GuessSheet: Sheet, Identifiable {
    
    internal var id: UUID
    internal var author: Player
    internal let number: Int
    private let content: String
    
    init(id: UUID = UUID(), author: Player = Player(),
         number: Int = 0,
         content: String = "Example Guess") {
        
        self.id = id
        self.author = author
        self.number = number
        self.content = content
    }
    
    func getContent() -> String {
        return self.content
    }
}

struct DrawingSheet: Sheet, Identifiable {
    
    internal var id: UUID
    internal var author: Player
    internal let number: Int
    private let content: UIImage
    
    init(id: UUID = UUID(), author: Player = Player(),
         number: Int = 0,
         content: UIImage = UIImage(systemName: "pencil.and.outline")!) {
        
        self.id = id
        self.author = author
        self.number = number
        self.content = content
    }
    
    func getContent() -> UIImage{
        return self.content
    }
}

struct ExampleSheet {
    
    static func getExample(numOfSheets: Int) -> [Sheet] {
        
        var sheets = [Sheet]()
        
        for number in 1...numOfSheets {
            
            if number.isMultiple(of: 2) {
                sheets.append(DrawingSheet(author: Player(nickname: "Player_\(number)", number: number), number: number))
            } else {
                sheets.append(GuessSheet(author: Player(nickname: "Player_\(number)", number: number), number: number))
            }
        }
        return sheets
    }
}
