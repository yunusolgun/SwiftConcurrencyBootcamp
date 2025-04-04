//
//  AsyncLetBootcamp.swift
//  SwiftConcurrencyBootcamp
//
//  Created by yunus olgun on 4.04.2025.
//

import SwiftUI

struct AsyncLetBootcamp: View {
    
    @State private var images: [UIImage] = []
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    let url = URL(string: "https://picsum.photos/300")!
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: columns) {
                    ForEach(images, id: \.self) { image in
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 150)
                    }
                }
            }
            .navigationTitle("Async Let 🥳")
            .onAppear {
                Task {
                    do {
                        
                        async let fetchImage1 = self.fetchImage()
                        async let fetchImage2 = self.fetchImage()
                        async let fetchImage3 = self.fetchImage()
                        async let fetchImage4 = self.fetchImage()
                        
                        let (image1,image2,image3,image4) = try await (fetchImage1,fetchImage2,fetchImage3,fetchImage4)
                        
                        images.append(image1)
                        images.append(image2)
                        images.append(image3)
                        images.append(image4)
                        
                        images.append(contentsOf: [image1, image2, image3, image4])
                        
                        
//                        images.append(try await fetchImage())
//                        images.append(try await fetchImage())
//                        images.append(try await fetchImage())
//                        images.append(try await fetchImage())
                    } catch {
                        
                    }
                }
            }
        }
    }
    
    
    func fetchImage() async throws -> UIImage {
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let image = UIImage(data: data) {
                return image
            } else {
                throw URLError(.badURL)
            }
        } catch  {
            throw error
        }
    }
    
}

#Preview {
    AsyncLetBootcamp()
}
