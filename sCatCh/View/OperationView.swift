
import SwiftUI

struct OperationView: View {
    
    private let operationType: String
    private let interactView: AnyView
    private let backAction: (SubRootView_Home.ViewType) -> ()
    private let isOperationSuccessful: Bool
    private let alertOkAction: () -> ()
    
    init(operationType: String,
         interactView: AnyView,
         backAction: @escaping (SubRootView_Home.ViewType) -> (),
         isOperationSuccessful: Bool,
         alertOkAction: @escaping () -> ()) {
        
        self.operationType = operationType
        self.interactView = interactView
        self.backAction = backAction
        self.isOperationSuccessful = isOperationSuccessful
        self.alertOkAction = alertOkAction
    }
    
    var body: some View {
        
        VStack{
            
            self.interactView
            
            Spacer()
            
            Button( action: { backAction(.Home) },
                    label: {Text("Back")
                        .font(.title3)
                        .foregroundColor(.black)
                        .padding(buttonPaddingLength)
                        .overlay(
                            RoundedRectangle(cornerRadius: buttonCornerRadius)
                                .stroke(Color.black, lineWidth: buttonStrokeLineWidth)
                        )})
                .padding()
            
            
        }
        .alert(isPresented: .constant(!self.isOperationSuccessful), content: {
            Alert(title: Text("Operation failed"), message: Text("Check input"),
                  dismissButton: .default(Text("Ok"), action: {self.alertOkAction()} ))
        })
    }
        
}

struct OperationView_Previews: PreviewProvider {
    static var previews: some View {
        OperationView(operationType: "Operation",
                      interactView: AnyView(Text("Operation View")),
                      backAction: {(p1: SubRootView_Home.ViewType) -> () in},
                      isOperationSuccessful: true,
                      alertOkAction: {})
    }
}
