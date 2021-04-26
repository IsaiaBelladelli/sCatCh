
import SwiftUI

struct SubRootView_Sheet: View {
    
    @ObservedObject private var stateController: StateController_Sheet
    
    init(stateController: StateController_Sheet) {
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
                    .onAppear(perform: { stateController.resetCountdown() })
                
            case .Drawing, .Guessing:
                
                SheetView(timeRemaining: max(stateController.getTimeRemaining(), 0),
                          topic: stateController.getTopic(),
                          interactView: self.getInteractView(),
                          currentRoundNum: stateController.getRoundNum(),
                          totalRoundNum: stateController.getNumOfRounds(),
                          doneAction: stateController.saveSheet,
                          forceEndingAction: stateController.getEnableForceRoundEnd() ? stateController.forceRoundEnd : nil)
                    .onAppear(perform: { stateController.resetCountdown() })
            }
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
    }
}

extension SubRootView_Sheet {    
    enum ViewType {
        case GetReady, Guessing, Drawing
    }
}

extension SubRootView_Sheet {
    
    func getInteractView() -> AnyView {
        
        switch stateController.getShownView() {
        case .Drawing:
            return AnyView(DrawingView(canvasView: stateController.getCanvasView(),
                                               guess: stateController.getReferenceSheetContent()))
        case .Guessing:
            return AnyView(GuessingView(guess: $stateController.guess,
                                   drawing: stateController.getReferenceSheetContent()))
            
        default: return AnyView(EmptyView())
        }
    }
}
