
import SwiftUI
import OSLog

class StateController_WaitingRoom: ObservableObject {
    
    private let storageController = StorageController_WaitingRoom()
    
    @Published private var gameSettings: GameSettings!
    @Published private var players: [WaitingPlayer] = []
    
    private var player: WaitingPlayer!
    private var isHost: Bool = false
    
    init(code: Int, player: WaitingPlayer, isHost: Bool) {
        
        self.player = player
        self.isHost = isHost
        
        self.storageController.getGameSettings(code: code, dataHandler: self.updateGameSettings)
        
        storageController.observePlayers(code: code, dataHandler: self.updatePlayers)
        storageController.observeRoundNum(code: code, dataHandler: self.checkRoundNum)
    }
    
    func getGameCode() -> Int {
        return self.gameSettings?.getCode() ?? 0
    }
    
    func getTopic() -> String {
        return self.gameSettings?.getTopic() ?? "None"
    }
    
    func getIsHost() -> Bool {
        return self.isHost
    }
    
    func getPlayers() -> [WaitingPlayer] {
        return self.players
    }
    
    func startGame() {
        Logger.runCycle.debug("\(type(of: self)): \(#function):")
        
        storageController.startGame(code: self.getGameCode())
    }
    
    func leaveGame() {
        Logger.runCycle.debug("\(type(of: self)): \(#function):")
        
        storageController.stopObservingPlayers(code: getGameCode())
        storageController.removePlayer(code: self.getGameCode(), playerId: player.getId())
        
        storageController.stopObservingRoundNum(code: getGameCode())
        
        StateController_Root.shared.moveToState_Home()
    }
}

extension StateController_WaitingRoom {
    
    private func updatePlayers(players: [WaitingPlayer]) {
        self.players = players
        self.players.sort(by: {$0.getJoinDate() < $1.getJoinDate()})
    }
    
    private func updateGameSettings(gameSettings: GameSettings) {
        self.gameSettings = gameSettings
    }
    
    private func checkRoundNum(roundNum: Int) {
        
        func handlePlayers(players: [Player]) {
            StateController_Root.shared.moveToState_Sheet(gameSettings: self.gameSettings,
                                                          player: players.filter({ $0.getId() == self.player.getId() }).first!,
                                                          numOfPlayers: players.count,
                                                          isHost: self.isHost)
        }
        
        if roundNum > 0 {
            storageController.stopObservingPlayers(code: self.getGameCode())
            storageController.stopObservingRoundNum(code: self.getGameCode())
            
            self.storageController.getPlayers(code: self.getGameCode(), dataHandler: handlePlayers)
        }
    }
}
