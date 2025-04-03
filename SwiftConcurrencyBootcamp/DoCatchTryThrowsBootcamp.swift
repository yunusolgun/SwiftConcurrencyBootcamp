//
//  DoCatchTryThrowsBootcamp.swift
//  SwiftConcurrencyBootcamp
//
//  Created by yunus olgun on 3.04.2025.
//

import SwiftUI

class DoCatchTryThrowsBootcampDataManager {
    
    let isActive: Bool = true
    
    func getTitle() -> (title:String?, error: Error?) {
        if isActive {
            return ("New Text", nil)
        } else {
            return (nil,URLError(.badURL))
        }
    }
    
    func getTitle2() -> Result<String, Error> {
        if isActive {
            return .success("New Text")
        } else {
            return .failure(URLError(.badServerResponse))
        }
    }
    
    func getTitle3() throws -> String {
        if isActive {
            return "New Text"
        } else {
            throw URLError(.backgroundSessionWasDisconnected)
        }
    }
    
    func getTitle4() throws -> String {
        if isActive {
            return "Final Text"
        } else {
            throw URLError(.backgroundSessionWasDisconnected)
        }
    }
    
}

class DoCatchTryThrowsViewModel: ObservableObject {
    
    @Published var text: String = "Starting text"
    let manager = DoCatchTryThrowsBootcampDataManager()
    
    func fetchTitle() {
        
        
        do {
            let newTitle = try manager.getTitle3()
            self.text = newTitle
            
            let finalTitle = try manager.getTitle4()
            self.text = finalTitle
        } catch {
            self.text = error.localizedDescription
        }
        
        /*
        let result = manager.getTitle2()
        switch result {
        case .success(let newTitle):
            self.text = newTitle
        case .failure(let error):
            self.text = error.localizedDescription
        }
         */
        
        
        /*
        let returnedValue = manager.getTitle()
        if let newTitle = returnedValue.title {
            self.text = newTitle
        } else if let error = returnedValue.error {
            self.text = error.localizedDescription
        }
         */
    }
}

struct DoCatchTryThrowsBootcamp: View {
    
    @StateObject var viewModel = DoCatchTryThrowsViewModel()
    
    var body: some View {
        Text(viewModel.text)
            .frame(width:300, height: 300)
            .background(Color.blue)
            .onTapGesture {
                viewModel.fetchTitle()
            }
    }
}

#Preview {
    DoCatchTryThrowsBootcamp()
}
