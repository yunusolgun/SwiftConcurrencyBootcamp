//
//  RefreshableBootcamp.swift
//  SwiftConcurrencyBootcamp
//
//  Created by yunus olgun on 7.04.2025.
//

import SwiftUI

final class RefreshableDataService {
    
    func getData() async throws -> [String] {
        try await Task.sleep(for: .seconds(3))
        return ["Apple", "Orange", "Banana"].shuffled()
    }
}

@MainActor
final class RefreshableBootcampViewModel: ObservableObject {
    @Published private(set) var items: [String] = []
    let manager = RefreshableDataService()
    
    func loadData() async {
        do {
            items = try await manager.getData()
        } catch {
            print(error)
        }
    }
    
}

struct RefreshableBootcamp: View {
    
    @StateObject private var viewmodel = RefreshableBootcampViewModel()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    ForEach(viewmodel.items, id: \.self) { item in
                        Text(item)
                    }
                }
            }
            .refreshable {
                await viewmodel.loadData()
            }
            .navigationTitle("Refreshable")
            .task {
                await viewmodel.loadData()
            }
        }

    }
}

#Preview {
    RefreshableBootcamp()
}
