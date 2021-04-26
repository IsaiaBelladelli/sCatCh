
import SwiftUI

struct JoinView: View {
    
    @State var nickname: String = ""
    @State var code: String = ""
    
    private let joinAction: (String, Int) -> ()
    
    init(joinAction: @escaping (String, Int) -> ()) {
        
        self.joinAction = joinAction
    }    
    
    var body: some View {
        
        VStack{
            
            VStack{
                Text("Nickname")
                    .font(.title2)
                    .fontWeight(.bold)
                
                TextField("Insert your nickname", text: $nickname)
                    .font(.title2)
                    .multilineTextAlignment(.center)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal, textFieldHorPaddingLength)
            }
            .padding(.vertical, groupVerPaddingLength)
            
            VStack{
                Text("Game code")
                    .font(.title2)
                    .fontWeight(.bold)
                
                TextField("Insert game code", text: $code)
                    .font(.title2)
                    .multilineTextAlignment(.center)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.numberPad)
                    .padding(.horizontal, textFieldHorPaddingLength)
            }
            .padding(.vertical, groupVerPaddingLength)
            
            Button( action: {joinAction(nickname, code.toInt()) },
                    label: {Text("Join")
                        .font(.title)
                        .foregroundColor(.black)
                        .padding(buttonPaddingLength)
                        .overlay(
                            RoundedRectangle(cornerRadius: buttonCornerRadius)
                                .stroke(Color.black, lineWidth: buttonStrokeLineWidth)
                        )})
                .padding(.vertical, groupVerPaddingLength)
            
            Spacer()
        }
        
    }
}

struct JoinView_Previews: PreviewProvider {
    static var previews: some View {
        JoinView(joinAction: {(p1: String, p2: Int) in print("Join Game")})
    }
}

