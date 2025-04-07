//
//  AsyncPublisherBootcamp.swift
//  SwiftConcurrencyBootcamp
//
//  Created by yunus olgun on 7.04.2025.
//

import SwiftUI

actor AsyncPublisherDataManager {
    
    @Published var myData: [String] = []
    
    func addData() async {
        myData.append("Apple")
        try? await Task.sleep(nanoseconds: 2_000_000_000)
        myData.append("Banana")
        try? await Task.sleep(nanoseconds: 2_000_000_000)
        myData.append("Orange")
        try? await Task.sleep(nanoseconds: 2_000_000_000)
        myData.append("Watermelon")
    }
}

class AsyncPublisherBootcampViewModel: ObservableObject {
 
    @MainActor @Published var dataArray: [String] = []
    let manager = AsyncPublisherDataManager()
    
    init() {
        addSubscribers()
    }
    
    private func addSubscribers() {
        Task {
            for await value in await manager.$myData.values {
                await MainActor.run {
                    self.dataArray = value
                }
            }
        }
    }
    
    func start() async {
        await manager.addData()
    }
}

struct AsyncPublisherBootcamp: View {
    
    @StateObject private var viewModel = AsyncPublisherBootcampViewModel()
    
    var body: some View {
        ScrollView {
            VStack {
                ForEach(viewModel.dataArray, id: \.self) { item in
                    Text(item)
                        .font(.headline)
                }
            }
        }
        .task {
            await viewModel.start()
        }
    }
}

#Preview {
    AsyncPublisherBootcamp()
}
