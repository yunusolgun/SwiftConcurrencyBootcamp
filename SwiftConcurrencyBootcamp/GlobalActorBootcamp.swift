//
//  GlobalActorBootcamp.swift
//  SwiftConcurrencyBootcamp
//
//  Created by yunus olgun on 5.04.2025.
//

import SwiftUI

@globalActor final class MyFirstGlobalActor {
    
    static var shared = MyNewDataManager()
   
}

actor MyNewDataManager {
    
    func getDataFromDatabase() -> [String] {
        return ["One", "Two", "Three", "Four", "Five"]
    }
    
}

class GlobalActorViewModel: ObservableObject {
    
    @Published var dataArray: [String] = []
//    let manager = MyNewDataManager()
    let manager = MyFirstGlobalActor.shared
    
    @MyFirstGlobalActor func getData() async {
        let data = await manager.getDataFromDatabase()
        self.dataArray = data
    }
}

struct GlobalActorBootcamp: View {
    
    @StateObject private var viewModel = GlobalActorViewModel()
    
    var body: some View {
        ScrollView {
            ForEach(viewModel.dataArray, id: \.self) { item in
                Text(item)
                    .font(.headline)
            }
        }
        .task {
            await viewModel.getData()
        }
    }
}

#Preview {
    GlobalActorBootcamp()
}
