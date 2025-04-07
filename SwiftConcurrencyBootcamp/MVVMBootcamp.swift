//
//  MVVMBootcamp.swift
//  SwiftConcurrencyBootcamp
//
//  Created by yunus olgun on 7.04.2025.
//

import SwiftUI

final class MyManagerClass {
    
    func getData() async throws -> String {
        return "Some data"
    }
}

actor MyManagerActor {
    
    func getData() async throws -> String {
        return "Some data"
    }
}

@MainActor
final class MVVMBootcampViewModel: ObservableObject {
    
    let managerClass = MyManagerClass()
    let managerActor = MyManagerActor()
    
    @Published private(set) var myData: String = "Starting text"
    private var tasks: [Task<Void,Never>] = []
    
    func cancelTasks() {
        tasks.forEach({ $0.cancel() })
    }
    
    
    func onCallToActionButtonPressed() {
        let task = Task {
            do {
//                myData = try await managerClass.getData()
                myData = try await managerActor.getData()
            } catch {
                print(error)
            }
        }
        tasks.append(task)
    }
    
}

struct MVVMBootcamp: View {
    
    @StateObject private var viewModel = MVVMBootcampViewModel()
    
    var body: some View {
        VStack {
            Button(viewModel.myData) {
                viewModel.onCallToActionButtonPressed()
            }
            
        }
        .onDisappear {
            
        }
    }
}

#Preview {
    MVVMBootcamp()
}
