
import SwiftUI

struct SummaryView: View {
    
    @State private var stackIndex: Int
    
    private let sheetStacks: [[Sheet]]
    private let topic: String
    private let backHomeAction: () -> ()
    
    init(sheetStacks: [[Sheet]], topic: String, backHomeAction: @escaping () -> ()) {
        self.stackIndex = 0
        self.sheetStacks = sheetStacks
        self.topic = topic
        self.backHomeAction = backHomeAction
        
        UITableView.appearance().backgroundColor = .clear
    }
    
    var body: some View {
        
        VStack{
            
            ZStack{
                
                HStack{
                    Spacer()
                    
                    ScreenshotView()
                }
                .padding(.horizontal, 10)
                
                VStack{
                    Text("Topic")
                        .font(.caption)
                    Text(topic)
                        .font(.title)
                }
                .padding(.vertical, 10)
            }
            
            if self.sheetStacks.count > 0 {
                List{
                    
                    ForEach(self.sheetStacks[stackIndex], id:\.id) {sheet in
                        
                        HStack{
                            
                            Text("\(sheet.getNumber())")
                                .font(.title2)
                                .overlay( Circle()
                                            .stroke(Color.black, lineWidth: buttonStrokeLineWidth)
                                            .frame(width: circleFrameSize, height: circleFrameSize)
                                )
                                .padding(.horizontal, 5)
                                .frame(width: circleFrameSize+10)
                            
                            VStack{
                                
                                self.createSheetContentView(sheet: sheet)
                                
                                HStack{
                                    Spacer()
                                    
                                    Text("by: \(sheet.getAuthor().getNickname())")
                                        .font(.caption)
                                }
                            }
                        }
                    }
                    .listRowBackground(Color(listItemColor))
                }
                .gesture(DragGesture(minimumDistance: 50, coordinateSpace: .global)
                            .onEnded({ value in self.updateStackIndex(value: value)} ))
                
            } else {
                Spacer()
                
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: Color.black))
                    .scaleEffect(2)
            }
            
            Spacer()
            
            Button("Back to Home") {
                backHomeAction()
            }
            .font(.title2)
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

extension SummaryView {
    
    func createSheetContentView(sheet: Sheet) -> AnyView {
        
        switch sheet{
        
        case is GuessSheet:
            return AnyView(Text((sheet as! GuessSheet).getContent())
                    .font(.title))
            
        case is DrawingSheet:
            return AnyView(Image(uiImage: (sheet as! DrawingSheet).getContent())
                    .resizable()
                    .frame(height: 270)
                    .aspectRatio(contentMode: .fit))
        
        default: return AnyView(EmptyView())
        }
    }
    
    func updateStackIndex(value: DragGesture.Value ) {
        
        if value.translation.width > 0  {
            self.stackIndex += (sheetStacks.count-1)
            
        } else if value.translation.width < 0 {
            self.stackIndex += 1
        }
        
        self.stackIndex %= sheetStacks.count
    }
}

struct SummaryView_Previews: PreviewProvider {
    static var previews: some View {
        SummaryView(sheetStacks: [
                        ExampleSheet.getExample(numOfSheets: 3),
                        ExampleSheet.getExample(numOfSheets: 5),
                        ExampleSheet.getExample(numOfSheets: 5)],
                    topic: "One Topic", backHomeAction: {})
    }
}
