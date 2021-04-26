
import SwiftUI

struct HomeView: View {
    
    private var goToAction: (SubRootView_Home.ViewType) -> ()
    
    init(goToAction: @escaping (SubRootView_Home.ViewType) -> ()) {
        self.goToAction = goToAction
    }
    
    var body: some View {
        
        VStack{
            
            Text(appName)
                .font(.system(.largeTitle, design: .rounded))
                .fontWeight(.bold)
                .padding(.bottom, 50)
            
            Group{
                
                Button( action: {self.goToAction(.Host)},
                        label: { Text("Host") })
                
                Button( action: {self.goToAction(.Join)},
                        label: { Text("Join") })
                
            }
            .font(.title)
            .foregroundColor(.black)
            .padding(buttonPaddingLength)
            .overlay(
                RoundedRectangle(cornerRadius: buttonCornerRadius)
                    .stroke(Color.black, lineWidth: buttonStrokeLineWidth)
            )
            .padding()
        }
        
    }
}

struct HomeView_Previews: PreviewProvider {
    
    static var previews: some View {
        HomeView(goToAction: { (p1: SubRootView_Home.ViewType) -> () in})
    }
}
