
import Firebase
import OSLog

class StorageController_Summary: StorageController {
    
    func getAllSheets(code: Int, dataHandler: @escaping (Sheet) -> ()) {
        
        self.databaseRef.child(String(code)).getData { error, dataSnapshot in
            
            if let error = error {
                Logger.runCycle.debug("\(type(of: self)): \(#function): \(String(describing: error))")
                
            } else if dataSnapshot.exists() {
                if let game = dataSnapshot.value as? Dictionary<String, Any> {
                    
                    if let playersDict = game[GameKeys.players.rawValue] as? Dictionary<String, Any> {
                        let players = self.buildPlayersArray(playerType: Player.self, playersDict: playersDict)
                        
                        if let roundsDict = game[GameKeys.rounds.rawValue] as? Dictionary<String, Any> {
                            for round in roundsDict {
                                let roundNum = round.key.last!.wholeNumberValue!
                                
                                if let sheetsDict = round.value as? Dictionary<String, Any> {
                                    for sheet in sheetsDict{
                                        
                                        if let sheetValues = sheet.value as? Dictionary<String, Any> {
                                            
                                            if let author = players.filter({$0.getNumber() == sheetValues[SheetKeys.authorNum.rawValue].toInt()}).first {
                                                
                                                self.getSheet(id: sheet.key,
                                                              author: author,
                                                              roundNum: roundNum,
                                                              sheetValues: sheetValues,
                                                              dataHandler: dataHandler)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
