
import SwiftUI

struct SubRootView_Summary: View {
    
    @ObservedObject private var stateController: StateController_Summary
    
    init(stateController: StateController_Summary) {
        self.stateController = stateController
    }
    
    var body: some View {
        
        ZStack{
            
            LinearGradient(gradient: Gradient(colors: [Color(backgroundColorName1), Color(backgroundColorName2)]),
                           startPoint: .top, endPoint: .bottom)
            
            switch stateController.getShownView() {
            
            case .GetReady:
                GetReadyView(messagge: stateController.getGetReadyMessage(),
                             timeRemaining: stateController.getTimeRemaining(),
                             showCountdown: true)
            case .Summary:                
                SummaryView(sheetStacks: stateController.getSheetStacks(),
                            topic: stateController.getTopic(),
                            backHomeAction: stateController.backtoHome)
            }
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
    }
}

extension SubRootView_Summary {
    enum ViewType {
        case GetReady, Summary
    }
}



