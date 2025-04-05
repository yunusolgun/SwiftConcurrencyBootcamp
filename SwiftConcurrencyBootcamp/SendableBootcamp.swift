//
//  SendableBootcamp.swift
//  SwiftConcurrencyBootcamp
//
//  Created by yunus olgun on 5.04.2025.
//

import SwiftUI

actor CurrentUserManaer {
    
    func updateDatabase(userInfo: MyUserInfo) {
        
    }
}

struct MyUserInfo: Sendable {
    var name: String
}

final class MyClassUserInfo: Sendable {
    let name: String
    
    init(name: String) {
        self.name = name
    }
}

class SendableBootcampViewModel: ObservableObject {
    
    let manager = CurrentUserManaer()
    
    func updateCurrentUserInfo() async {
        let info = MyUserInfo(name: "info")
        await manager.updateDatabase(userInfo: info)
    }
}

struct SendableBootcamp: View {
    
    @StateObject private var viewModel = SendableBootcampViewModel()
    
    var body: some View {
        Text("Hello, World!")
            .task {
                
            }
    }
}

#Preview {
    SendableBootcamp()
}
