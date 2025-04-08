//
//  PhotoPickerBootcamp.swift
//  SwiftConcurrencyBootcamp
//
//  Created by yunus olgun on 8.04.2025.
//

import SwiftUI
import PhotosUI

@MainActor
final class PhotoPickerViewModel: ObservableObject {
    
    @Published private(set) var selectedImage: UIImage? = nil
    @Published var imageSelection: PhotosPickerItem? = nil {
        didSet {
            setImage(from: imageSelection)
        }
    }
    
    @Published private(set) var selectedImages: [UIImage] = []
    @Published var imageSelections: [PhotosPickerItem] = [] {
        didSet {
            setImages(from: imageSelections)
        }
    }
    
    private func setImage(from selection: PhotosPickerItem?) {
        guard let selection else { return }
        
        Task {
            if let data = try? await selection.loadTransferable(type: Data.self) {
                if let uiImage = UIImage(data: data) {
                    self.selectedImage = uiImage
                    return
                }
            }
        }
        
    }
    
    
    private func setImages(from selections: [PhotosPickerItem]) {
        
        Task {
            var images: [UIImage] = []
            for selection in selections {
                if let data = try? await selection.loadTransferable(type: Data.self) {
                    if let uiImage = UIImage(data: data) {
                        images.append(uiImage)
                    }
                }
            }
            selectedImages = images
        }
        
    }
}

struct PhotoPickerBootcamp: View {
    
    @StateObject private var viewModel = PhotoPickerViewModel()
    
    var body: some View {
        VStack(spacing:40) {
            Text("Hello, World!")
            
            if let image = viewModel.selectedImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(width:200, height: 200)
                    .cornerRadius(10)
            }
            
            
            PhotosPicker(selection: $viewModel.imageSelection, matching: .images) {
                Text("Open the photo picker")
                    .foregroundStyle(.red)
            }
            
            if !viewModel.selectedImages.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(viewModel.selectedImages, id: \.self) { image in
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 100, height: 100)
                                .cornerRadius(10)
                        }
                    }
                }
            }
            
            PhotosPicker(selection: $viewModel.imageSelections, matching: .images) {
                Text("Open the photos picker")
                    .foregroundStyle(.red)
            }
            
            
        }
    }
}

#Preview {
    PhotoPickerBootcamp()
}
