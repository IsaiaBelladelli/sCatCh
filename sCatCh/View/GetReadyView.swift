
import SwiftUI

struct GetReadyView: View {
    
    private var messagge: String
    private var timeRemaining: Int
    private var showCountdown: Bool
    
    init(messagge: String, timeRemaining: Int, showCountdown: Bool) {
        self.messagge = messagge
        self.timeRemaining = timeRemaining
        self.showCountdown = showCountdown
    }
    
    var body: some View {
        VStack{
            Text(messagge)
                .font(.title)
                .multilineTextAlignment(.center)
            
            if showCountdown {
                CountdownView(timeRemaining: timeRemaining)
                
            } else {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: Color.black))
                    .scaleEffect(2)
            }
        }
    }
}

struct GetReadyView_Previews: PreviewProvider {
    static var previews: some View {
        GetReadyView(messagge: "Get ready for drawing", timeRemaining: 5, showCountdown: true)
    }
}


