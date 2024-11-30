import SwiftUI
import _PhotosUI_SwiftUI

struct MyInfoView: View {
    @ObservedObject private var viewModel: MyInfoViewModel
    @State private var selectedItem: PhotosPickerItem?
    @Environment(\.dismiss) private var dismiss
    @FocusState private var focusedField: Field?
    @Namespace private var topID
    @Namespace private var descriptionID
    var didTapUpdateConfirmButton: (() -> Void)?
    
    enum Field: Hashable {
        case nickname
        case description
    }
    
    init(viewModel: MyInfoViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                VStack(spacing: 0) {
                    ZStack(alignment: .bottomTrailing) {
                        ProfileImageView(
                            selectedImageData: viewModel.userSelectedImageData,
                            imageURL: viewModel.userImageURL
                        )
                        PhotosPicker(
                            selection: $selectedItem,
                            matching: .images
                        ) {
                            ZStack {
                                Circle()
                                    .fill(.white)
                                    .frame(width: 22, height: 22)
                                
                                Image(systemName: "plus")
                                    .font(.system(size: 15, weight: .bold))
                                    .foregroundStyle(.black)
                            }
                        }
                        .onChange(of: selectedItem) { newItem in
                            if let item = newItem {
                                viewModel.didSelectImage(item)
                            }
                        }
                        .offset(x: -4, y: -4)
                    }
                    .padding(.top, 22)
                    .id(topID)
                    
                    Spacer()
                        .frame(height: 15)
                    
                    NickNameTextFieldView(
                        characterLimit: viewModel.nickNameCharacterLimit,
                        isPossibleInput: viewModel.isPossibleNickName,
                        text: $viewModel.userNickName
                    )
                    .focused($focusedField, equals: .nickname)
                    
                    Spacer()
                        .frame(height: 22)
                    
                    DescriptionTextFieldView(
                        characterLimit: viewModel.descriptionCharacterLimit,
                        isPossibleInput: viewModel.isPossibleDescription,
                        text: $viewModel.userDescription
                    )
                    .frame(maxHeight: 105)
                    .focused($focusedField, equals: .description)
                    .id(descriptionID)
                    
                    Spacer(minLength: 115)
                }
            }
            .scrollDisabled(true)
            .onChange(of: focusedField) { field in
                switch field {
                case .description:
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.22) {
                        withAnimation {
                            proxy.scrollTo(descriptionID, anchor: .top)
                        }
                    }
                default:
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.22) {
                        withAnimation {
                            proxy.scrollTo(topID, anchor: .top)
                        }
                    }
                }
            }
        }
        .background(Color.background)
        .safeAreaInset(edge: .bottom) {
            BasicButton(
                type: .confirm,
                isEnabled: viewModel.isPossibleConfirmButton
            ) {
                Task {
                    try await viewModel.updateUser()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: 66)
            .padding(.horizontal, 22)
            .padding(.bottom, 34)
        }
        .onTapGesture {
            focusedField = .none
        }
        .alert(
            viewModel.alertState.title,
            isPresented: $viewModel.showAlert) {
                Button("확인") {
                    if viewModel.alertState == .successUpdate {
                        didTapUpdateConfirmButton?()
                    }
                }
            }
    }
}
