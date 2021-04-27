
import SwiftUI

struct SubRootView_WaitingRoom: View {
    
    @ObservedObject private var stateController: StateController_WaitingRoom
    
    init(stateController: StateController_WaitingRoom) {
        self.stateController = stateController
    }
    
    var body: some View {
        
        ZStack{
            
            LinearGradient(gradient: Gradient(colors: [Color(backgroundColorName1), Color(backgroundColorName2)]),
                           startPoint: .top, endPoint: .bottom)
            
            WaitingRoomView(topic: stateController.getTopic(),
                            code: stateController.getGameCode(),
                            players: stateController.getPlayers(),
                            activateButton: stateController.getIsHost(),
                            leaveAction:stateController.leaveGame,
                            startAction: stateController.startGame)
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
    }
}
