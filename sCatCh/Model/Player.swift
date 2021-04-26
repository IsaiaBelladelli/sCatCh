
import Foundation

protocol BasePlayer: Identifiable {
    
    var id: UUID { get }
    var nickname: String { get }
}

extension BasePlayer {
    
    func getId() -> UUID {
        return self.id
    }
    
    func getNickname() -> String {
        return self.nickname
    }
}

struct WaitingPlayer: BasePlayer {
    
    internal let id: UUID
    internal let nickname: String
    private let joinDate: Date
    
    internal init(id: UUID = UUID(), nickname: String, joinDate: Date) {
        self.id = id
        self.nickname = nickname
        self.joinDate = joinDate
    }
    
    func getJoinDate() -> Date {
        return self.joinDate
    }
}

struct Player: BasePlayer {
    
    internal let id: UUID
    internal let nickname: String
    private let number: Int
    
    internal init(id: UUID = UUID(), nickname: String = "One Player", number: Int = 0) {
        self.id = id
        self.nickname = nickname
        self.number = number
    }
    
    func getNumber() -> Int {
        return self.number
    }
}

struct ExamplePlayer {
    
    static func getExample<T>(type: T.Type, numOfPlayers: Int) -> [T] {
        
        var players: [T] = []
        
        for number in 1...numOfPlayers {
            
            switch type{
            
            case is WaitingPlayer.Type:
                players.append(WaitingPlayer(nickname: "Player_\(number)",
                                             joinDate: "2021-01-01 01:01:0\(number)".toDate()!) as! T)
                
            case is Player.Type:
                players.append(Player(nickname: "Player_\(number)",
                                      number: number) as! T)
                
            default: break
            }
        }
        return players
    }
}
