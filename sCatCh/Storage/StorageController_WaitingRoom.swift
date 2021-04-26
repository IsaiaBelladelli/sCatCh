
import Firebase
import OSLog

class StorageController_WaitingRoom: StorageController {
    
    func getGameSettings(code: Int, dataHandler: @escaping (GameSettings) -> ()){
        
        self.databaseRef.child(String(code)).getData(completion: { error, dataSnapshot in
            
            if let error = error {
                Logger.runCycle.debug("\(type(of: self)): \(#function): \(String(describing: error))")
                
            } else if dataSnapshot.exists() {
                
                if let game = dataSnapshot.value as? Dictionary<String, Any> {
                    
                    let gameSettings = GameSettings(roundTime: game[GameKeys.roundTime.rawValue].toInt(),
                                                    topic: game[GameKeys.topic.rawValue].toString(),
                                                    code: code,
                                                    maxNumOfRounds: game[GameKeys.maxNumOfRounds.rawValue].toInt())
                    
                    DispatchQueue.main.async {
                        dataHandler(gameSettings)
                    }
                }
            }
        })
    }
    
    func getPlayers(code: Int, dataHandler: @escaping ([Player]) -> ()) {
        
        self.databaseRef.child(String(code)).child(GameKeys.players.rawValue).getData { error, dataSnapshot in
            
            if let error = error {
                Logger.runCycle.debug("\(type(of: self)): \(#function): \(String(describing: error))")
                
            } else if dataSnapshot.exists() {
                
                if let playersDict = dataSnapshot.value as? Dictionary<String, Any> {
                    
                    let players = self.buildPlayersArray(playerType: Player.self, playersDict: playersDict)
                    
                    DispatchQueue.main.async {
                        dataHandler(players)
                    }                    
                }
            }
        }
    }
    
    func observePlayers(code: Int, dataHandler: @escaping ([WaitingPlayer]) -> ()) {
        
        self.databaseRef.child(String(code)).child(GameKeys.players.rawValue)
            .observe(DataEventType.value) { dataSnapshot in
                
                if let playersDict = dataSnapshot.value as? Dictionary<String, Any> {
                    
                    let players = self.buildPlayersArray(playerType: WaitingPlayer.self, playersDict: playersDict)
                    
                    dataHandler(players)
                }
            }
    }
    
    func stopObservingPlayers(code: Int) {
        self.databaseRef.child(String(code)).child(GameKeys.players.rawValue).removeAllObservers()
    }
    
    func observeRoundNum(code: Int, dataHandler: @escaping (Int) -> ()) {
        self.databaseRef.child(String(code)).child(GameKeys.roundNum.rawValue)
            .observe(DataEventType.value) { dataSnapshot in
                
                if let roundNum = dataSnapshot.value as? Int {
                    dataHandler(roundNum)
                }
            }
    }
    
    func stopObservingRoundNum(code: Int) {
        self.databaseRef.child(String(code)).child(GameKeys.roundNum.rawValue).removeAllObservers()
    }
    
    func removePlayer(code: Int, playerId: UUID) {
        self.databaseRef.child("\(String(code))/\(GameKeys.players.rawValue)/\(playerId.uuidString)").removeValue()
    }
    
    func startGame(code: Int) {
        
        self.databaseRef.child(String(code)).getData(completion: { error, dataSnapshot in
            
            if let error = error {
                Logger.runCycle.debug("\(type(of: self)): \(#function): \(String(describing: error))")
                
            } else if dataSnapshot.exists() {
                
                if let game = dataSnapshot.value as? Dictionary<String, Any> {
                    var number = 1
                    
                    if let playersDict = game[GameKeys.players.rawValue] as? Dictionary<String, Any> {
                        for player in playersDict {
                            
                            self.databaseRef.child("\(String(code))/\(GameKeys.players.rawValue)/\(player.key)").child("number").setValue(number)
                            number += 1
                        }
                        self.databaseRef.child("\(String(code))/\(GameKeys.roundNum.rawValue)").setValue(1)
                    }
                }
            }
        })
    }
}
