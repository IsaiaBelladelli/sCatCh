
import SwiftUI
import OSLog

class StateController_Summary: ObservableObject {
    
    private var storageController = StorageController_Summary()
    
    @Published private var shownView: SubRootView_Summary.ViewType = .GetReady
    @Published private var timeRemaining: Int = 3
    @Published private var sheetStacks: [[Sheet]] = []
    
    private var getReadyMessage: String = "Well done!\nGet ready for Laughing"
    private var gameSettings: GameSettings!
    private var numOfRounds: Int = 0
    private var numOfPlayers: Int = 0
    
    var sheets: [Sheet] = [] //FIXME:
    
    private var countdownTimePublisher: TimePublisher =  { TimePublisher(every: 1) }()
    
    init(gameSettings: GameSettings, numOfRounds: Int, numOfPlayers: Int) {
        
        self.gameSettings = gameSettings
        self.numOfRounds = numOfRounds
        self.numOfPlayers = numOfPlayers
        
        self.countdownTimePublisher.subscribe { self.checkTimer() }
    }
    
    deinit {
        Logger.runCycle.critical("State controller summary deinitialize")
    }
    
    func getShownView() -> SubRootView_Summary.ViewType {
        return self.shownView
    }
    
    func getTimeRemaining() -> Int {
        return self.timeRemaining
    }
    
    func getGetReadyMessage() -> String {
        return self.getReadyMessage
    }
    
    func getSheetStacks() -> [[Sheet]] {
        return self.sheetStacks
    }
    
    func getTopic() -> String {
        return self.gameSettings?.getTopic() ?? ""
    }
    
    func backtoHome() {
        StateController_Root.shared.moveToState_Home()
    }
}

extension StateController_Summary {
    
    private func checkTimer() {
        Logger.runCycle.debug("\(type(of: self)): \(#function): Time remaining = \(self.timeRemaining)")
        
        switch self.timeRemaining {
        
        case 0:
            Logger.runCycle.debug("\(type(of: self)): \(#function): Get all sheets")
            
            self.storageController.getAllSheets(code: self.gameSettings.getCode(), dataHandler: self.handleDBData_Sheets)
            
            self.countdownTimePublisher.unsubscribe()
            
            self.shownView = .Summary
            
        default: self.timeRemaining -= 1
        }
    }
    
    private func handleDBData_Sheets(sheet: Sheet) {
        Logger.runCycle.debug("\(type(of: self)): \(#function): Sheet: number = \(sheet.getNumber()), Author: nickname = \(sheet.getAuthor().getNickname()) (\(sheet.getAuthor().getNumber()))")
        
        self.sheets.append(sheet)
        //self.sheetStacks = self.buildSheetStacks()
    }
    
    func buildSheetStacks() -> [[Sheet]] { //FIXME:
        
        var sheetStacks = [[Sheet]]()
        
        for playerNum in 1...self.numOfPlayers {
            var sheetStack = [Sheet]()
            
            for roundNum in 1...self.numOfRounds{
                
                let authorNum = self.getAuthorNumToBuildStacks(playerNum: playerNum, roundNum: roundNum, numOfPlayers: self.numOfPlayers)
                
                if let sheet = self.sheets.filter( {$0.getNumber() == roundNum && $0.getAuthor().getNumber() == authorNum}).first {
                    sheetStack.append(sheet)
                }
            }
            sheetStacks.append(sheetStack)            
        }
        //self.sheetStacks = sheetStacks //FIXME:
        
        return sheetStacks
    }
    
    private func getAuthorNumToBuildStacks(playerNum: Int, roundNum: Int, numOfPlayers: Int) -> Int {
        
        let authorNum = (playerNum + (numOfPlayers - roundNum - 1)) % numOfPlayers
        
        return authorNum == 0 ? numOfPlayers : authorNum        
    }    
}

