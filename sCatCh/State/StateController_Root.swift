
import SwiftUI
import OSLog

class StateController_Root: ObservableObject {
    
    static let shared = StateController_Root()
    
    private var stateController_Home: StateController_Home!
    private var stateController_WaitingRoom: StateController_WaitingRoom!
    private var stateController_Sheet: StateController_Sheet!
    private var stateController_Summary: StateController_Summary!    
    
    @Published private var shownView: RootView.ViewType
    
    init() {
        self.stateController_Home = StateController_Home()
        self.shownView = .Home
        
        Logger.runCycle.debug("\(type(of: self)): \(#function):")
    }
    
    func getShownView() -> RootView.ViewType{
        return self.shownView
    }
    
    func getStateController<T>(type: T.Type) -> T {
        switch type {
        case is StateController_Home.Type: return self.stateController_Home as! T
        case is StateController_WaitingRoom.Type: return self.stateController_WaitingRoom as! T
        case is StateController_Sheet.Type: return self.stateController_Sheet as! T
        case is StateController_Summary.Type: return self.stateController_Summary as! T
        default: return self.stateController_Home as! T
        }
    }
    
    func moveToState_Home() {
        Logger.runCycle.debug("\(type(of: self)): \(#function):")
        
        self.stateController_Home = StateController_Home()
        self.shownView = .Home
    }
    
    func moveToState_WaitingRoom(code: Int, player: WaitingPlayer, isHost: Bool) {
        Logger.runCycle.debug("\(type(of: self)): \(#function):")
        
        self.stateController_WaitingRoom = StateController_WaitingRoom(code: code, player: player, isHost: isHost)
        self.shownView = .WaitingRoom
    }
    
    func moveToState_Sheet(gameSettings: GameSettings, player: Player, numOfPlayers: Int, isHost: Bool) {
        Logger.runCycle.debug("\(type(of: self)): \(#function):")
        
        self.stateController_Sheet = StateController_Sheet(gameSettings: gameSettings, player: player,
                                                           numOfPlayers: numOfPlayers, isHost: isHost)
        self.shownView = .Sheet
    }
    
    func moveToState_Summary(gameSettings: GameSettings, numOfRounds: Int, numOfPlayers: Int) {
        Logger.runCycle.debug("\(type(of: self)): \(#function):")
        
        self.stateController_Summary = StateController_Summary(gameSettings: gameSettings, numOfRounds: numOfRounds, numOfPlayers: numOfPlayers)
        self.shownView = .Summary
    }
}
