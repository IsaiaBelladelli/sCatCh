
import SwiftUI
import OSLog

class StateController_Home: ObservableObject {
    
    private let storageController = StorageController_Home()
    
    @Published private var shownView: SubRootView_Home.ViewType = .Home
    @Published private var isOperationSuccessful: Bool = true
    
    func getShownView() -> SubRootView_Home.ViewType {
        return self.shownView
    }
    
    func getIsOperationSuccessful() -> Bool {
        return self.isOperationSuccessful
    }
    
    func hostGame(topic: String, maxNumOfRounds: Int, roundTime: Int, nickname: String) {        
        Logger.runCycle.debug("\(type(of: self)): \(#function):")
        
        if roundTime > 0 && !nickname.isEmpty {
            
            
            func handleDBData_Host(isHostSuccessful: Bool) {
                
                if isHostSuccessful {
                    StateController_Root.shared.moveToState_WaitingRoom(code: code, player: player, isHost: true)
                }
                self.isOperationSuccessful = isHostSuccessful
            }
            
            let code = (100000..<1000000).randomElement()!
            let topic = topic.isEmpty ? "None" : topic
            let player = WaitingPlayer(id: UUID(), nickname: nickname, joinDate: Date())
            
            storageController.hostGame(code: code,
                                       topic: topic,
                                       maxNumOfRounds: maxNumOfRounds,
                                       roundTime: roundTime,
                                       player: player,
                                       dataHandler: handleDBData_Host)
        } else {
            self.isOperationSuccessful = false
        }
    }
    
    func joinGame(nickname: String, code: Int) {
        Logger.runCycle.debug("\(type(of: self)): \(#function):")
        
        if !nickname.isEmpty {
            
            func handleDBData_Join(isJoinSuccessful: Bool) {
                
                if isJoinSuccessful {
                    StateController_Root.shared.moveToState_WaitingRoom(code: code, player: player, isHost: false)
                }
                self.isOperationSuccessful = isJoinSuccessful
            }
            
            let player = WaitingPlayer(id: UUID(), nickname: nickname, joinDate: Date())
            
            storageController.joinGame(player: player, code: code, dataHandler: handleDBData_Join)
            
        } else {
            self.isOperationSuccessful = false
        }
    }
    
    func resetIsOperationSuccessful() {
        self.isOperationSuccessful = true
    }
    
    func setShownView(viewType: SubRootView_Home.ViewType) {
        self.shownView = viewType
    }
}
