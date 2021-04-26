
import SwiftUI

struct GuessingView: View {
    
    @Binding var guess: String
    
    private let drawing: UIImage
    
    internal init(guess: Binding<String>, drawing: UIImage) {
        self._guess = guess
        self.drawing = drawing
    }
    
    var body: some View {
        
        VStack{
            
            Image(uiImage: drawing)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding()
            
            
            TextField("Guess the drawing", text: $guess)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .multilineTextAlignment(.center)
                .padding()
        }
    }
}

struct GuessingView_Previews: PreviewProvider {
    static var previews: some View {
        GuessingView(guess: .constant("Example Guess"),
                     drawing: UIImage(systemName: "scribble")!)
    }
}
