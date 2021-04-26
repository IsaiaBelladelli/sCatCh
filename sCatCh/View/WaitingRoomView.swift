
import SwiftUI

struct WaitingRoomView: View {
    
    private var topic: String
    private var code: Int
    private var players: [WaitingPlayer]
    private var activateStartButton: Bool
    private var leaveAction: () -> ()
    private var startAction: () -> ()
    
    init(topic: String, code: Int, players: [WaitingPlayer], activateButton: Bool,
                  leaveAction: @escaping () -> (), startAction: @escaping () -> ()) {
        self.topic = topic
        self.code = code
        self.players = players
        self.activateStartButton = activateButton
        self.leaveAction = leaveAction
        self.startAction = startAction
        
        UITableView.appearance().backgroundColor = .clear
    }
    
    var body: some View {
        
        VStack{
            
            HStack{
                
                VStack{
                    Text("Game code")
                        .font(.caption)
                    Text(String(code))
                        .font(.title)
                }
                .padding()
                
                Spacer()
                
                VStack{
                    Text("Topic")
                        .font(.caption)
                    Text("\(topic)")
                        .font(.title)
                }
                .padding()
            }
            
            
            List{
                ForEach(players) { player in                    
                    
                    Text("\(player.getNickname())")
                        .font(.title)
                }
                .listRowBackground(Color(listItemColor))
            }
            
            HStack(alignment: .center) {
                    
                    Button("Leave") { leaveAction() }
                        .font(.title3)
                        .foregroundColor(.black)
                        .padding(buttonPaddingLength)
                        .overlay(
                            RoundedRectangle(cornerRadius: buttonCornerRadius)
                                .stroke(Color.black, lineWidth: buttonStrokeLineWidth)
                        )
                    
                    if activateStartButton {
                        
                        Spacer()
                        
                        Button("Start") { startAction() }
                            .font(.title)
                            .foregroundColor(.black)
                            .padding(buttonPaddingLength)
                            .overlay(
                                RoundedRectangle(cornerRadius: buttonCornerRadius)
                                    .stroke(Color.black, lineWidth: buttonStrokeLineWidth)
                            )
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
        }
    }
}

struct WaitingRoomView_Previews: PreviewProvider {
    static var previews: some View {
        WaitingRoomView(topic: "One Topic", code: 649,
                        players: ExamplePlayer.getExample(type: WaitingPlayer.self, numOfPlayers: 5),
                        activateButton: true,
                        leaveAction: {}, startAction: {})
    }
}


