//
//  ActorsBootcamp.swift
//  SwiftConcurrencyBootcamp
//
//  Created by yunus olgun on 5.04.2025.
//

import SwiftUI

/*
 1. What is the problem that actor are solving?
 2. How was this problem solved prior to actors?
 3. Actors can solve the problem
 */

class MyDataManager {
    static let instance = MyDataManager()
    private init () {}
    
    var data: [String] = []
    private let lock = DispatchQueue(label: "com.example.MyDataManager")
    
//    func getRandomData() -> String? {
//        self.data.append(UUID().uuidString)
//        print(Thread.current)
//        return data.randomElement()
//    }
    
    func getRandomData(completionHandler: @escaping (_ title: String?) -> Void) {
        lock.async {
            self.data.append(UUID().uuidString)
            print(Thread.current)
            completionHandler(self.data.randomElement())
        }

    }
    
}

actor MyActorDataManager {
    static let instance = MyActorDataManager()
    private init () {}
    
    var data: [String] = []
    
    func getRandomData() -> String? {
        self.data.append(UUID().uuidString)
        print(Thread.current)
        return data.randomElement()
    }
    
    nonisolated func getSavedData() -> String {
        return "new data"
    }
    
}

struct HomeView: View {
    
//    let manager = MyDataManager.instance
    let manager = MyActorDataManager.instance
    @State private var text: String = ""
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    
    
    var body: some View {
        ZStack {
            Color.gray.opacity(0.8).ignoresSafeArea()
            
            Text(text)
                .font(.headline)
        }
        .onAppear(perform: {
            let newString = manager.getSavedData()
        })
        .onReceive(timer) { x in
            Task {
                if let data = await manager.getRandomData() {
                    await MainActor.run {
                        self.text = data
                    }
                }
            }
            
//            DispatchQueue.global(qos: .background).async {
//                
//                manager.getRandomData { title in
//                    if let data = title {
//                        DispatchQueue.main.async {
//                            self.text = data
//                        }
//                    }
//                }
//                
////                if let data = manager.getRandomData() {
////                    DispatchQueue.main.async {
////                        self.text = data
////                    }
////                }
//            }

        }
    }
}


struct BrowseView: View {
    
//    let manager = MyDataManager.instance
    let manager = MyActorDataManager.instance
    @State private var text: String = ""
    let timer = Timer.publish(every: 0.01, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            Color.yellow.opacity(0.8).ignoresSafeArea()
            
            Text(text)
                .font(.headline)
            
        }
        .onReceive(timer) { x in
            
            Task {
                if let data = await manager.getRandomData() {
                    await MainActor.run {
                        self.text = data
                    }
                }
            }
            
//            DispatchQueue.global(qos: .default).async {
//                manager.getRandomData { title in
//                    if let data = title {
//                        DispatchQueue.main.async {
//                            self.text = data
//                        }
//                    }
//                }
////                if let data = manager.getRandomData() {
////                    DispatchQueue.main.async {
////                        self.text = data
////                    }
////                }
//            }
        }
    }
}


struct ActorsBootcamp: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
            
            
            BrowseView()
                .tabItem {
                    Label("Browse", systemImage: "magnifyingglass")
                }
            
        }
    }
}

#Preview {
    ActorsBootcamp()
}
