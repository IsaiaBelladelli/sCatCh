
import SwiftUI

struct ScreenshotView: View {
    
    @State var image: UIImage = UIImage()
    
    private let iconSize: CGSize = CGSize(width: 20, height: 20)
    
    var body: some View {
        Button(
            action: {
                
                image = takeScreenshot(crop: false) ?? UIImage()
                
                UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
            },
            label: {
                Image(systemName: "square.and.arrow.down.fill")
                    .resizable()
                    .frame(width: iconSize.width, height: iconSize.height)
                    .foregroundColor(.black)
            }
                
        )
    }
}

struct SaveImageView_Previews: PreviewProvider {
    static var previews: some View {
        ScreenshotView()
    }
}

