
import SwiftUI
import PencilKit
import OSLog

class StateController_Sheet: ObservableObject {
    
    private var storageController = StorageController_Sheet()
    
    @Published private var shownView: SubRootView_Sheet.ViewType = .GetReady
    @Published private var timeRemaining: Int = -10
    
    var guess: String = ""
    private var canvasView: PKCanvasView = PKCanvasView()
    
    private var gameSettings: GameSettings!
    private var player: Player!
    private var numOfPlayers: Int = 0
    private var numOfRounds: Int = 0
    private var isHost: Bool = false
    
    private var roundNum: Int = 0
    private var referenceSheet: Sheet!
    
    private var getReadyMessage: String = ""
    private var isContentSaved: Bool = false
    private var enableForceRoundEnd: Bool = false
    
    private var countdownTimePublisher: TimePublisher =  { TimePublisher(every: 1) }()
    
    init(gameSettings: GameSettings, player: Player, numOfPlayers: Int, isHost: Bool) {
        
        self.gameSettings = gameSettings
        self.player = player
        self.numOfPlayers = numOfPlayers
        self.numOfRounds = min(numOfPlayers, gameSettings.getMaxNumOfRounds())
        self.isHost = isHost
        
        self.storageController.observeRoundNum(code: self.gameSettings.getCode(), dataHandler: self.handleDBData_RoundNum)
        
        self.countdownTimePublisher.subscribe { self.checkTimer() }
    }
    
    func getShownView() -> SubRootView_Sheet.ViewType {
        return self.shownView
    }
    
    func getTimeRemaining() -> Int {
        return self.timeRemaining
    }
    
    func getGetReadyMessage() -> String {
        return self.getReadyMessage
    }
    
    func getTopic() -> String {
        return self.gameSettings.getTopic()
    }
    
    func getRoundNum() -> Int {
        return self.roundNum
    }
    
    func getNumOfRounds() -> Int {
        return self.numOfRounds
    }
    
    func getCanvasView() -> PKCanvasView {
        return self.canvasView
    }
    
    func getEnableForceRoundEnd() -> Bool {
        return self.enableForceRoundEnd
    }
    
    func getReferenceSheetContent() -> String {
        return (self.referenceSheet as? GuessSheet)?.getContent() ?? "None. Draw what you want!"
    }
    
    func getReferenceSheetContent() -> UIImage {
        return (self.referenceSheet as? DrawingSheet)?.getContent() ?? UIImage(named: "drawingnotfound_image")!
    }
    
    func resetCountdown() {
        
        switch self.shownView {
        
        case .GetReady:
            self.timeRemaining = 3
            
        case .Guessing, .Drawing:
            self.timeRemaining = gameSettings.getRoundTime()
        }
    }
    
    func checkTimer() {
        Logger.runCycle.debug("\(type(of: self)): \(#function): Time remaining = \(self.timeRemaining)")
        
        switch timeRemaining {
        
        case 1... :
            
             self.getReferenceSheet()
        
        case 0 :
            
            switch self.shownView{
            
            case .GetReady:
                
                self.getReferenceSheet()
                
                if self.roundNum.isMultiple(of: 2) {
                    self.shownView = .Drawing
                } else {
                    self.shownView = .Guessing
                }
                
            case .Drawing, .Guessing:
                self.saveSheet()
            }
            
        case -5 :
            
            switch self.shownView{
            
            case .Drawing, .Guessing:
                
                self.enableForceRoundEnd = true
                
            case .GetReady: break
            }
            
        default: break
        }
        
        self.timeRemaining -= 1
    }
    
    func saveSheet() {
        if !isContentSaved {
            Logger.runCycle.debug("\(type(of: self)): \(#function): RoundNum: \(self.roundNum)")
            
            switch self.shownView {
            
            case .Drawing:
                
                let drawing = self.getDrawingFromCanvas()
                
                let sheet = DrawingSheet(author: self.player, number: self.roundNum, content: drawing)
                self.storageController.saveSheet(code: self.gameSettings.getCode(), sheet: sheet)
                
                canvasView.drawing = PKDrawing()
                
            case .Guessing:
                
                let guess = self.guess
                
                let sheet = GuessSheet(author: self.player, number: self.roundNum, content: guess)
                self.storageController.saveSheet(code: self.gameSettings.getCode(), sheet: sheet)
                
                self.guess = ""
                
            default: break
            }
            
            isContentSaved = true
        }
    }
    
    func forceRoundEnd() {
        self.storageController.updateRoundNum(code: self.gameSettings.getCode(), roundNum: self.roundNum + 1)
    }
}

extension StateController_Sheet {
    
    private func setGetReadyMessage() {
        
        if self.roundNum.isMultiple(of: 2) {
            getReadyMessage = "Get ready for Drawing"
            
        } else {
            getReadyMessage = "Get ready for Guessing"
        }
    }
    
    private func getDrawingFromCanvas() -> UIImage {
        canvasView.drawing.image(from: canvasView.bounds, scale: 1)
    }
    
    private func initializeRound() {
        
        switch self.roundNum {
        
        case 1...self.numOfRounds:
            
            self.referenceSheet = nil
            
            if self.isHost {
                self.storageController.observeRoundSheets(code: self.gameSettings.getCode(),
                                                          roundNum: self.roundNum,
                                                          dataHandler: self.handleDBData_RoundSheets)
            }
            
            self.isContentSaved = false
            self.enableForceRoundEnd = false
            
            self.setGetReadyMessage()
            
            self.shownView = .GetReady
            
        default:
            self.countdownTimePublisher.unsubscribe()
            self.storageController.stopObservingRoundNum(code: self.gameSettings.getCode())
            
            StateController_Root.shared.moveToState_Summary(gameSettings: gameSettings, numOfRounds: numOfRounds, numOfPlayers: numOfPlayers)
        }
    }
    
    private func getAuthorNumToGetRefSheet(numOfPlayers: Int, playerNum: Int) -> Int {
        let authorNum = (playerNum + 1) % numOfPlayers
        
        return authorNum == 0 ? numOfPlayers : authorNum
    }
    
    private func handleDBData_RoundNum(roundNum: Int) {
        if roundNum != self.roundNum {
            
            if self.isHost {
                self.storageController.stopObservingRoundSheets(code: self.gameSettings.getCode(), roundNum: self.roundNum)
            }
            
            self.roundNum = roundNum
            self.initializeRound()
        }
    }
    
    private func handleDBData_ReferenceSheet(sheet: Sheet) {
        Logger.runCycle.debug("\(type(of: self)): \(#function): Sheet: number = \(sheet.getNumber()), Author: number = \(sheet.getAuthor().getNumber())")
        
        self.referenceSheet = sheet
    }
    
    private func handleDBData_RoundSheets(numOfSavedSheets: Int) {
        if self.isHost && numOfSavedSheets == self.numOfPlayers {
            Logger.runCycle.debug("\(type(of: self)): \(#function): Force round end")
            
            self.forceRoundEnd()
        }
    }
    
    private func getReferenceSheet() {
        
        if self.referenceSheet == nil {
            
            if self.roundNum > 1 {
                Logger.runCycle.debug("\(type(of: self)): \(#function):")
                
                let authorNum = self.getAuthorNumToGetRefSheet(numOfPlayers: self.numOfPlayers,
                                                               playerNum: self.player.getNumber())
                
                self.storageController.getReferenceSheet(code: self.gameSettings.getCode(),
                                                         roundNum: self.roundNum - 1,
                                                         authorNum: authorNum,
                                                         dataHandler: self.handleDBData_ReferenceSheet)
            } else {
                self.referenceSheet = DrawingSheet(content: UIImage(named: "writeguess_image")!)
            }
        }
    }
}
