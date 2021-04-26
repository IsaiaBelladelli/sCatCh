
import SwiftUI

struct SubRootView_Home: View {
    
    @ObservedObject private var stateController: StateController_Home
    
    init(stateController: StateController_Home) {
        self.stateController = stateController
    }
    
    var body: some View {
        
        ZStack{
            
            LinearGradient(gradient: Gradient(colors: [Color(backgroundColorName1), Color(backgroundColorName2)]),
                           startPoint: .top, endPoint: .bottom)
            
            switch stateController.getShownView(){
            
            case .Home:
                HomeView(goToAction: stateController.setShownView)
            
            case .Host:
            OperationView(operationType: stateController.getShownView().rawValue,
                          interactView: AnyView(HostView(hostAction: stateController.hostGame)),
                          backAction: stateController.setShownView,
                          isOperationSuccessful: stateController.getIsOperationSuccessful(),
                          alertOkAction: stateController.resetIsOperationSuccessful)
                         
                
            case .Join:
                OperationView(operationType: stateController.getShownView().rawValue,
                              interactView: AnyView(JoinView(joinAction: stateController.joinGame)),
                              backAction: stateController.setShownView,
                              isOperationSuccessful: stateController.getIsOperationSuccessful(),
                              alertOkAction: stateController.resetIsOperationSuccessful)
                             
            }
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
    }
}

extension SubRootView_Home {
    enum ViewType: String {
        case Home, Host, Join
    }
}


