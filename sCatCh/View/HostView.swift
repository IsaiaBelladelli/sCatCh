
import SwiftUI

struct HostView: View {
    
    @State var topic: String = ""
    @State var maxNumOfRounds: Int = 3
    @State var roundTime: String = "60"
    @State var nickname: String = ""
    
    private let hostAction: (String, Int, Int, String) -> ()
    
    init(hostAction: @escaping (String, Int, Int, String) -> ()) {
        self.hostAction = hostAction
    }
    
    var body: some View {
        
        VStack(alignment: .center){
            
            VStack{
                Text("Topic")
                    .font(.title2)
                    .fontWeight(.bold)
                
                TextField("Insert a topic", text: $topic)
                    .multilineTextAlignment(.center)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal, textFieldHorPaddingLength)
            }
            .padding(.vertical, groupVerPaddingLength)
            
            VStack{
                 Text("Max Number of Rounds")
                     .font(.title2)
                     .fontWeight(.bold)
                
                StepperView(value: $maxNumOfRounds,
                            minimumValue: 3, maximumValue: 11)
             }
             .padding(.vertical, groupVerPaddingLength)
            
            VStack{
                Text("Countdown")
                    .font(.title2)
                    .fontWeight(.bold)
                
                TextField("Insert a countdown", text: $roundTime)
                    .multilineTextAlignment(.center)
                    .font(.title2)
                    .keyboardType(.numberPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal, textFieldHorPaddingLength)
            }
            .padding(.vertical, groupVerPaddingLength)
            
            VStack{
                Text("Nickname")
                    .font(.title2)
                    .fontWeight(.bold)
                
                TextField("Insert your nickname", text: $nickname)
                    .multilineTextAlignment(.center)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal, textFieldHorPaddingLength)
            }
            .padding(.vertical, groupVerPaddingLength)
            
            Button( action: { hostAction(topic, maxNumOfRounds, roundTime.toInt(), nickname) },
                    label: {Text("Host")
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

struct StepperView: View {
    
    @Binding var value: Int
    
    private let minimumValue: Int
    private let maximumValue: Int
    private let iconSize: CGSize = CGSize(width: 30, height: 30)
    
    init(value: Binding<Int>, minimumValue: Int, maximumValue: Int) {
        self._value = value
        self.minimumValue = minimumValue
        self.maximumValue = maximumValue
    }
    
    var body: some View {
        
        HStack{
            
            ZStack{
                
                RoundedRectangle(cornerRadius: 5)
                    .fill(Color.black)
                    .frame(width: iconSize.width, height: iconSize.height)
                    .opacity(opacityValue)
                
                Button(action: { self.value -= 1 }, label: {
                Image(uiImage: UIImage(systemName: "minus")!)
                })
                .disabled(self.value <= self.minimumValue)
            }
            
            Text("\(self.value)")
                .font(.title2)
                .padding(.horizontal,20)
            
            ZStack{
                
                RoundedRectangle(cornerRadius: 5)
                    .fill(Color.black)
                    .frame(width: iconSize.width, height: iconSize.height)
                    .opacity(opacityValue)
                
                Button(action: { self.value += 1 }, label: {
                Image(uiImage: UIImage(systemName: "plus")!)
                })
                .disabled(self.value >= self.maximumValue)
            }
        }
    }
}


struct SetupView_Previews: PreviewProvider {
    static var previews: some View {
        HostView(hostAction: {(p1: String, p2: Int, p3: Int, p4: String) in print("Host game")})
    }
}

