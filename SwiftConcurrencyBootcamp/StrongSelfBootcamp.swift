//
//  StrongSelfBootcamp.swift
//  SwiftConcurrencyBootcamp
//
//  Created by yunus olgun on 7.04.2025.
//

import SwiftUI

final class StrongSelfDataService {
    
    func getData() -> String {
        return "Updated data"
    }
}

final class StrongSelfBootcampViewModel: ObservableObject {
    
    @Published var data: String = "Some title"
    let dataService = StrongSelfDataService()
    
    private var someTask: Task<Void, Never>? = nil
    
    func cancelTasks() {
        someTask?.cancel()
        someTask = nil
    }
    
    
    // This implies a strong reference...
    func updateData() {
        Task {
            data = await dataService.getData()
        }
    }
    
    
    // This is a strong reference...
    func updateData2() {
        Task {
            self.data = await dataService.getData()
        }
    }
    
    
    // This is a strong reference...
    func updateData3() {
        Task { [self] in
            self.data = await dataService.getData()
        }
    }
    
    // This is a weak reference...
    func updateData4() {
        Task { [weak self] in
            self?.data = await dataService.getData()
        }
    }
    
    
    // We don't need to manage weak/strong
    // We can manage the Task!
    func updateData5() {
        someTask = Task { [self] in
            self.data = await dataService.getData()
        }
    }
    
    
    func updateData8() async {
        self.data = await dataService.getData()
    }
    
}

struct StrongSelfBootcamp: View {
    
    @StateObject private var viewModel = StrongSelfBootcampViewModel()
    
    var body: some View {
        Text(viewModel.data)
            .onAppear {
                viewModel.updateData()
            }
            .onDisappear {
                viewModel.cancelTasks()
            }
            .task {
                await viewModel.updateData8()
            }
    }
}

#Preview {
    StrongSelfBootcamp()
}
