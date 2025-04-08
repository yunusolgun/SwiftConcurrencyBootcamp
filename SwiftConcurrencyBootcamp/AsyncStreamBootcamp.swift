//
//  AsyncStreamBootcamp.swift
//  SwiftConcurrencyBootcamp
//
//  Created by yunus olgun on 8.04.2025.
//

import SwiftUI

class AsyncStreamDataManager {
    
    func getAsyncStream() -> AsyncStream<Int> {
//        AsyncStream { [weak self] continuation in
//            self?.getFakeData { value in
//                continuation.yield(value)
//            }
//        }
        
        AsyncStream { [weak self] continuation in
            self?.getFakeData { value in
                continuation.yield(value)
            } onFinish: {
                continuation.finish()
            }

        }
        
    }
    
    func getFakeData(
        newValue: @escaping (_ value: Int) -> Void,
        onFinish: @escaping () -> Void
    ) {
        let items: [Int] = [1,2,3,4,5,6,7,8,9,10]
        
        for item in items {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(item)) {
                newValue(item)
                
                if item == items.last {
                    onFinish()
                }
            }
        }
    }
}

@MainActor
final class AsyncStreamViewModel: ObservableObject {
    
    let manager = AsyncStreamDataManager()
    @Published private(set) var currentNumber: Int = 0
    
    func onViewAppear() {
//        manager.getFakeData { [weak self] value in
//            self?.currentNumber = value
//        }
        
        
        Task {
            for await value in manager.getAsyncStream() {
                currentNumber = value
            }
        }
        
    }
    
}

struct AsyncStreamBootcamp: View {
    
    @StateObject private var viewModel = AsyncStreamViewModel()
    
    var body: some View {
        Text("\(viewModel.currentNumber)")
            .onAppear {
                viewModel.onViewAppear()
            }
    }
}

#Preview {
    AsyncStreamBootcamp()
}
