
import Firebase
import OSLog

class StorageController {
    
    let databaseRef: DatabaseReference = Database.database(url: databaseURL).reference()
    let storageRef: StorageReference = Storage.storage(url: storageURL).reference()
    
    func getSheet(id: String, author: Player, roundNum: Int, sheetValues: Dictionary<String, Any>, dataHandler: @escaping (Sheet) -> ()) {
        if let content = sheetValues[SheetKeys.content.rawValue] as? String {
            
            let guessSheet = GuessSheet(id: UUID(uuidString: id)!,
                                        author: author,
                                        number: roundNum,
                                        content: content )
            
            DispatchQueue.main.async {
                dataHandler(guessSheet)
            }
        } else {
            let drawingSheet = DrawingSheet(id: UUID(uuidString: id)!,
                                            author: author,
                                            number: roundNum)
            self.getDrawingSheet(sheet: drawingSheet, imageId: id, dataHandler: dataHandler)
        }
    }
    
    func getDrawingSheet(sheet: DrawingSheet, imageId: String, dataHandler: @escaping (Sheet) -> ()) {
        
        self.storageRef.child("/drawings/\(imageId).jpg").getData(maxSize: imageMaxSize) { data, error in
            
            if let error = error {
                Logger.runCycle.debug("\(type(of: self)): \(#function): \(String(describing: error))")
                
            } else {
                if let data = data, let image = UIImage(data: data) {
                    let sheet = DrawingSheet(id: sheet.getId(), author: sheet.getAuthor(),
                                             number: sheet.getNumber(), content: image)
                    
                    DispatchQueue.main.async {
                        dataHandler(sheet)
                    }
                }
            }
        }
    }
    
    func buildPlayersArray<T>(playerType: T.Type, playersDict: Dictionary<String, Any>) -> [T] {
        
        var players = [T]()
        
        for player in playersDict{
            if let playerValues = player.value as? Dictionary<String, Any> {
                
                switch playerType {
                case is Player.Type:
                    players.append(Player(id: UUID(uuidString: player.key)!,
                                          nickname: playerValues[PlayerKeys.nickname.rawValue].toString(),
                                          number: playerValues[PlayerKeys.number.rawValue].toInt()) as! T)
                    
                case is WaitingPlayer.Type:
                    players.append(WaitingPlayer(id: UUID(uuidString: player.key)!,
                                                 nickname: (player.value as! Dictionary<String, Any>)[PlayerKeys.nickname.rawValue].toString(),
                                                 joinDate: (player.value as! Dictionary<String, Any>)[PlayerKeys.joinDate.rawValue].toString().toDate()!) as! T)                    
                default: break
                }
            }
        }
        return players
    }
}
