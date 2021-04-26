
import Firebase
import OSLog

class StorageController_Sheet: StorageController {
    
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
    
    func observeRoundSheets(code: Int, roundNum: Int, dataHandler: @escaping (Int) -> ()) {
        self.databaseRef.child(String(code)).child(GameKeys.rounds.rawValue).child("\(GameKeys.round.rawValue)\(roundNum)")
            .observe(DataEventType.value) { dataSnapshot in
                
                if let sheetsDict = dataSnapshot.value as? Dictionary<String, Any> {
                    dataHandler(sheetsDict.count)
                }
            }
    }
    
    func stopObservingRoundSheets(code: Int, roundNum: Int) {
        self.databaseRef.child(String(code)).child(GameKeys.rounds.rawValue).child("\(GameKeys.round.rawValue)\(roundNum)").removeAllObservers()
    }
    
    func saveSheet(code: Int, sheet: Sheet) {
        
        var sheetDict: Dictionary<String, Any>!
        
        switch sheet {
        case is GuessSheet:
            sheetDict = [ SheetKeys.authorNum.rawValue: sheet.getAuthor().getNumber(),
                          SheetKeys.content.rawValue: (sheet as! GuessSheet).getContent()]
            
        case is DrawingSheet:
            sheetDict = [SheetKeys.authorNum.rawValue: sheet.getAuthor().getNumber()]
            
            let imageData = (sheet as! DrawingSheet).getContent().jpegData(compressionQuality: 1)
            self.storageRef.child("/drawings/\(sheet.getId().uuidString).jpg").putData(imageData!, metadata: nil)
            
        default: break
        }
        self.databaseRef.child(String(code)).child(GameKeys.rounds.rawValue).child("\(GameKeys.round.rawValue)\(sheet.getNumber())").child(sheet.getId().uuidString)
            .setValue(sheetDict)
    }
    
    func getReferenceSheet(code: Int, roundNum: Int, authorNum: Int, dataHandler: @escaping (Sheet) -> ()) {
        
        self.databaseRef.child(String(code)).child(GameKeys.rounds.rawValue).child("\(GameKeys.round.rawValue)\(roundNum)").getData { error, dataSnapshot in
            
            if let error = error {
                Logger.runCycle.debug("\(type(of: self)): \(#function): \(String(describing: error))")
                
            } else if dataSnapshot.exists() {
                
                if let sheetsDict = dataSnapshot.value as? Dictionary<String, Any> {
                    for sheet in sheetsDict {
                        
                        if let sheetValues = sheet.value as? Dictionary<String, Any> {
                            if sheetValues[SheetKeys.authorNum.rawValue].toInt() == authorNum { //|| true
                                
                                self.getSheet(id: sheet.key,
                                              author: Player(number: authorNum),
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

    func updateRoundNum(code: Int, roundNum: Int) {        
        self.databaseRef.child(String(code)).child(GameKeys.roundNum.rawValue).setValue(roundNum)
    }
}
