
import SwiftUI

struct SheetView: View {
        
    @State var isDone: Bool

    private let timeRemaining: Int
    private let topic: String
    private let interactView: AnyView
    private let currentRoundNum: Int
    private let totalRoundNum: Int
    private let doneAction: () -> ()
    private let forceEndingAction: ( () -> () )!
    
    init(timeRemaining: Int, topic: String, interactView: AnyView, currentRoundNum: Int, totalRoundNum: Int,
         doneAction: @escaping ()->(), forceEndingAction: ( ()->() )! ) {
        self._isDone = State(initialValue: false)
        self.timeRemaining = timeRemaining
        self.topic = topic
        self.interactView = interactView
        self.currentRoundNum = currentRoundNum
        self.totalRoundNum = totalRoundNum
        self.doneAction = doneAction
        self.forceEndingAction = forceEndingAction
    }
    
    var body: some View {
        
        VStack {
        
            HStack{
                
                CountdownView(timeRemaining: timeRemaining)
                
                Spacer()
                
                VStack{
                    
                    Text("Topic")
                        .font(.caption)
                    
                    Text(topic)
                        .font(.title2)
                }
                
                Spacer()
                
                DoneView(isDone: $isDone)
                    .font(.headline)
                    .onChange(of: isDone, perform: {_ in doneAction() })
            }
            .padding(.horizontal, 5)
            
            ZStack(alignment: .bottomTrailing){
                
                if !isDone && timeRemaining > 0{
                    self.interactView
                } else {
                    VStack {
                        GetReadyView(messagge: "Wait for Round End", timeRemaining: 0, showCountdown: false)
                        
                        if forceEndingAction != nil {
                            
                            Button("Force Ending") { forceEndingAction() }
                                .font(.title3)
                                .foregroundColor(.black)
                                .padding(buttonPaddingLength)
                                .overlay(
                                    RoundedRectangle(cornerRadius: buttonCornerRadius)
                                        .stroke(Color.black, lineWidth: buttonStrokeLineWidth)
                                )
                                .padding(.top,50)
                        }
                    }
                }
            }
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
            
            HStack{
                
                Spacer()
                
                Group{
                    Text(String(currentRoundNum))
                        .fontWeight(.bold)
                        +
                        Text("/\(totalRoundNum)")
                }
                .overlay( Circle()
                            .stroke(Color.black, lineWidth: buttonStrokeLineWidth)
                            .frame(width: circleFrameSize, height: circleFrameSize)
                )
                .padding()
            }
        }
    }
}

struct TopBarView_Previews: PreviewProvider {
    static var previews: some View {
        SheetView(timeRemaining: 0, topic: "One Topic",
                  interactView: AnyView(GetReadyView(messagge: "One Message", timeRemaining: 0, showCountdown: false)),
                  currentRoundNum: 1, totalRoundNum: 5, doneAction: {}, forceEndingAction: {})
    }
}


