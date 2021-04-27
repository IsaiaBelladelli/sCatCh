
import SwiftUI

struct RootView: View {
    
    @ObservedObject private var stateController = StateController_Root.shared
    
    var body: some View {
        
        switch stateController.getShownView() {
        
        case .Home:
            SubRootView_Home(stateController: stateController.getStateController(type: StateController_Home.self))
            
        case .WaitingRoom:
            SubRootView_WaitingRoom(stateController: stateController.getStateController(type: StateController_WaitingRoom.self))
            
        case .Sheet:
            SubRootView_Sheet(stateController: stateController.getStateController(type: StateController_Sheet.self))
            
        case .Summary:
            SubRootView_Summary(stateController: stateController.getStateController(type: StateController_Summary.self))    
        }        
    }
}

extension RootView {
    
    enum ViewType {
        case Home, WaitingRoom, Sheet, Summary
    }
}

