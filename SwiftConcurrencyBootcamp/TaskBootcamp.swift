//
//  TaskBootcamp.swift
//  SwiftConcurrencyBootcamp
//
//  Created by yunus olgun on 4.04.2025.
//

import SwiftUI

class TaskBootcampViewModel : ObservableObject {
    
    @Published var image: UIImage? = nil
    @Published var image2: UIImage? = nil
    
    func fetchImage() async {
        do {
            guard let url = URL(string: "https://picsum.photos/1000") else { return }
            let (data, _) = try await URLSession.shared.data(from: url)
            self.image = UIImage(data: data)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func fetchImage2() async {
        do {
            guard let url = URL(string: "https://picsum.photos/1000") else { return }
            let (data, _) = try await URLSession.shared.data(from: url)
            self.image2 = UIImage(data: data)
        } catch {
            print(error.localizedDescription)
        }
    }
    
}

struct TaskBootcamp: View {
    
    @StateObject private var viewModel = TaskBootcampViewModel()
    
    var body: some View {
        VStack(spacing: 40) {
            if let image = viewModel.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
            }
            if let image2 = viewModel.image2 {
                Image(uiImage: image2)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
            }
        }
        .task {
            // Bu modifier i kullanmak Task açmaktan daha iyi. Çünkü cancel işlemi gerektiğinde otomatik yapıyor.
            await viewModel.fetchImage()
        }
//        .onAppear {
////            Task {
////                await viewModel.fetchImage()
////            }
////            Task {
////                await viewModel.fetchImage2()
////            }
//            
//            Task(priority: .low) {
//                try? await Task.sleep(for: .seconds(2))
//                print("LOW: \(Task.currentPriority)")
//            }
//            
//            Task(priority: .medium) {
//                try? await Task.sleep(for: .seconds(2))
//                print("MEDIUM: \(Task.currentPriority)")
//            }
//            
//            Task(priority: .high) {
//                try? await Task.sleep(for: .seconds(2))
//                print("HIGH: \(Task.currentPriority)")
//                
//            }
//            
//            Task(priority: .background) {
//                try? await Task.sleep(for: .seconds(2))
//                print("BACKGROUND: \(Task.currentPriority)")
//            }
//            
//            Task(priority: .utility) {
//                try? await Task.sleep(for: .seconds(2))
//                print("UTILITY: \(Task.currentPriority)")
//            }
//            
//            Task(priority: .userInitiated) {
//                try? await Task.sleep(for: .seconds(2))
//                print("USER INITIAITED:  \(Task.currentPriority)")
//            }
//            
//        }
    }
}

#Preview {
    TaskBootcamp()
}
