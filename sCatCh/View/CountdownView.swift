
import SwiftUI

struct CountdownView: View {
    
    private var timeRemaining: Int
    private let rectSize: CGSize
    private let rectColor: Color
    
    init(timeRemaining: Int, rectSize: CGSize = CGSize(width: 50, height: 50), rectColor: Color = Color.black) {
        self.timeRemaining = timeRemaining
        self.rectSize = rectSize
        self.rectColor = rectColor
    }
    
    var body: some View {
        
        ZStack{
            
            Rectangle()
                .stroke(rectColor, style: StrokeStyle(lineWidth: 4, lineCap: .round, lineJoin: .round))
                .frame(width: rectSize.width, height: rectSize.height)
            
            Text("\(self.timeRemaining)")
                .font(.title)
                .padding()
            
        }
    }
}

struct TimerView_Previews: PreviewProvider {
    static var previews: some View {
        CountdownView(timeRemaining: 5)
    }
}
