import SwiftUI

struct ChangeProfileImageView: View {
    let selectedImageData: Data?
    let imageURL: URL?
    
    var body: some View {
        if let selectedImageData = selectedImageData,
           let selectedImage = UIImage(data: selectedImageData) {
            Image(uiImage: selectedImage)
                .resizable()
                .scaledToFill()
                .frame(width: 110, height: 110)
                .clipShape(Circle())
        } else {
            AsyncImage(url: imageURL) { phase in
                if let image = phase.image {
                    image
                        .resizable()
                        .scaledToFill()
                } else {
                    Image(ImageResource.personCircle)
                        .resizable()
                        .scaledToFill()
                }
            }
            .frame(width: 110, height: 110)
            .clipShape(Circle())
        }
    }
}
