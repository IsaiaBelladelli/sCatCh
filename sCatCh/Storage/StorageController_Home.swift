
import Firebase
import OSLog

class StorageController_Home: StorageController {
    
    func hostGame(code: Int, topic: String, maxNumOfRounds: Int, roundTime: Int, player: WaitingPlayer, dataHandler: @escaping (Bool) -> ()) {
        
        self.databaseRef.child(String(code)).getData(completion: { error, dataSnapshot in
            
            if let error = error {
                Logger.runCycle.debug("\(type(of: self)): \(#function): \(String(describing: error))")
                
                DispatchQueue.main.async {
                    dataHandler(false)
                }
            } else if dataSnapshot.exists() {
                
                DispatchQueue.main.async {
                    dataHandler(false)
                }
            } else {
                
                let playerDict = [player.getId().uuidString : [PlayerKeys.nickname.rawValue: player.getNickname(),
                                                               PlayerKeys.joinDate.rawValue: player.getJoinDate().toString()]]
                
                let gameDict: [String : Any] = [GameKeys.topic.rawValue: topic,
                                                GameKeys.maxNumOfRounds.rawValue : maxNumOfRounds,
                                                GameKeys.roundTime.rawValue: roundTime,
                                                GameKeys.roundNum.rawValue: 0,
                                                GameKeys.players.rawValue: playerDict]
                
                self.databaseRef.child(String(code)).setValue(gameDict)
                
                DispatchQueue.main.async {
                    dataHandler(true)
                }
            }
        })
    }
    
    func joinGame(player: WaitingPlayer, code: Int, dataHandler: @escaping (Bool) -> ()) {
        
        self.databaseRef.child(String(code)).getData(completion: { error, dataSnapshot in           
            
            if let error = error {
                Logger.runCycle.debug("\(type(of: self)): \(#function): \(String(describing: error))")
                
                DispatchQueue.main.async {
                    dataHandler(false)
                }                
            } else if dataSnapshot.exists() {
                
                let playerDict = [PlayerKeys.nickname.rawValue: player.getNickname(),
                                  PlayerKeys.joinDate.rawValue: player.getJoinDate().toString()]
                
                self.databaseRef.child("\(String(code))/\(GameKeys.players.rawValue)/\(player.getId().uuidString)")
                    .setValue(playerDict)
                
                DispatchQueue.main.async {
                    dataHandler(true)
                }
            } else {
                
                DispatchQueue.main.async {
                    dataHandler(false)
                }
            }
        })
    }
}
