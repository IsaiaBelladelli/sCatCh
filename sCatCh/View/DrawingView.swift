
import SwiftUI
import PencilKit

struct DrawingView: View {
    
    @State var toolType: ToolTypeView.ToolType = .Pen
    @State var color: Color = Color.black
    
    private let canvasView: PKCanvasView
    private let guess: String
    private let iconSize: CGSize = CGSize(width: 20, height: 20)
    
    init(canvasView: PKCanvasView, guess: String) {
        self.canvasView = canvasView
        self.guess = guess
    }
    
    func convertToolType(toolType: ToolTypeView.ToolType) -> CanvasView.ToolType {
        switch toolType {
        case .Pen: return .Pen
        case .Marker: return .Marker
        case .Eraser: return .Eraser
        }
    }
    
    var body: some View {
        
        VStack{
            
            HStack{
                
                UndoView(iconSize: iconSize)
                    .padding(.horizontal, 10)
                
                ClearView(action: canvasView.clear, iconSize: iconSize)
                
                Spacer()
                
                ToolTypeView(toolType: $toolType, iconSize: iconSize)
                
                ColorPicker(selection: $color, label: {})
                    .frame(width: iconSize.width)
                    .padding(.horizontal, 15)
                
            }
            
            Text("Guess: ")
                .font(.caption)
                +
                Text("\(self.guess)")
                .font(.title2)
            
            CanvasView(canvasView: canvasView,
                       toolType: convertToolType(toolType: toolType) ,color: color)
            
        }
        
    }
    
}

struct UndoView: View {
    
    @Environment(\.undoManager) var undoManager
    
    private let iconSize: CGSize
    
    init(iconSize: CGSize = CGSize(width: 20, height: 20)) {
        self.iconSize = iconSize
    }
    
    var body: some View {
        HStack{
            Button(action : { self.undoManager?.undo()},
                   label: {Image(systemName: "arrow.uturn.backward")
                    .resizable()
                    .frame(width: iconSize.width, height: iconSize.height)
                    .foregroundColor(.black)
                   })
            
            Button(action : { self.undoManager?.redo()},
                   label: {Image(systemName: "arrow.uturn.forward")
                    .resizable()
                    .frame(width: iconSize.width, height: iconSize.height)
                    .foregroundColor(.black)
                   })
            
        }
    }
}

struct ClearView: View {
    
    private let action: ()->()
    private let iconSize: CGSize
    
    init(action: @escaping ()->() = {}, iconSize: CGSize = CGSize(width: 20, height: 20)) {
        self.action = action
        self.iconSize = iconSize
    }
    
    var body: some View {
        
        Button(action : action,
               label: {Image(systemName: "trash")
                .resizable()
                .frame(width: iconSize.width, height: iconSize.height)
                .foregroundColor(.black)
               })
    }
}

struct ToolTypeView: View {
    
    @Binding var toolType: ToolType
    
    private let iconSize: CGSize
    
    init(toolType: Binding<ToolType> ,iconSize: CGSize = CGSize(width: 20, height: 20)) {
        self._toolType = toolType
        self.iconSize = iconSize
    }
    
    var body: some View {
        
        HStack{
            
            IconView(toolType: $toolType, iconName: "pencil", associatedToolType: ToolType.Pen)
            
            IconView(toolType: $toolType, iconName: "paintbrush", associatedToolType: ToolType.Marker)
            
            IconView(toolType: $toolType, iconName: "circle.dashed", associatedToolType: ToolType.Eraser)
        }
    }
}

extension ToolTypeView {
    enum ToolType {
        case Pen, Marker, Eraser
    }
}

extension ToolTypeView {
    
    struct IconView: View {
        
        @Binding var toolType: ToolType
        
        private let iconSize: CGSize
        private let iconName: String
        private let associatedToolType: ToolType
        
        init(toolType: Binding<ToolType>, iconSize: CGSize = CGSize(width: 20, height: 20),
             iconName: String, associatedToolType: ToolType) {
            self._toolType = toolType
            self.iconSize = iconSize
            self.iconName = iconName
            self.associatedToolType = associatedToolType
            
        }
        
        var body: some View {
            
            ZStack{
                
                if(toolType == associatedToolType) {
                    Circle()
                        .fill(Color.black)
                        .opacity(opacityValue)
                        .frame(width: iconSize.width, height: iconSize.height)
                    
                }
                
                Button(action: {toolType = associatedToolType},
                       label: {
                        Image(systemName: iconName)
                            .resizable()
                            .frame(width: iconSize.width, height: iconSize.height)
                            .foregroundColor(.black)
                        
                       }
                )
                
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        DrawingView(canvasView: PKCanvasView(), guess: "Example Guess")
    }
}

