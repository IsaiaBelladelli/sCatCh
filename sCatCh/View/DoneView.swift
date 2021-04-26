
import SwiftUI

struct DoneView: View {
    
    @Binding var isDone: Bool
    
    init(isDone: Binding<Bool>) {
        self._isDone = isDone
    }
        
    var body: some View {
        
        Button("Done") {
            self.isDone.toggle()
        }
        .disabled(isDone)
        .foregroundColor(.black)
        .padding(buttonPaddingLength)
        .overlay(
            RoundedRectangle(cornerRadius: buttonCornerRadius)
                .stroke(Color.black, lineWidth: buttonStrokeLineWidth)
        )
        .opacity(isDone ? opacityValue : 1)
    }
}

struct DoneView_Previews: PreviewProvider {
    static var previews: some View {
        DoneView(isDone: .constant(false))
    }
}

