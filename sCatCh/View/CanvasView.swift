
import SwiftUI
import PencilKit

struct CanvasView: UIViewRepresentable {
    
    private let canvasView : PKCanvasView
    private let toolType: ToolType
    private let color: Color
    
    private var tool: PKTool {
        switch toolType {
        case .Pen: return PKInkingTool(.pen, color: UIColor(color), width: CGFloat(10))
        case .Marker: return PKInkingTool(.marker, color: UIColor(color), width: CGFloat(20))
        case .Eraser: return PKEraserTool(.bitmap)
        }
        
    }
    
    init(canvasView: PKCanvasView, toolType: CanvasView.ToolType, color: Color) {
        self.canvasView = canvasView
        self.toolType = toolType
        self.color = color
        
        canvasView.tool = tool
    }
    
    func makeUIView(context: Context) -> some UIView {
        
        canvasView.drawingPolicy = .anyInput
        return canvasView
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
    }
}

extension CanvasView {
    enum ToolType {
        case Pen, Marker, Eraser
    }
}

extension PKCanvasView {
    func clear() {
        self.drawing = PKDrawing()
    }
}
