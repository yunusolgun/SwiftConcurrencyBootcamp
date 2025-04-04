//
//  StructClassActorBootcamp.swift
//  SwiftConcurrencyBootcamp
//
//  Created by yunus olgun on 4.04.2025.
//

import SwiftUI

struct StructClassActorBootcamp: View {
    var body: some View {
        Text("Hello, World!")
            .onAppear {
                runTest()
            }
    }
}

#Preview {
    StructClassActorBootcamp()
}



class MyClass {
    var title: String
    
    init(title: String) {
        self.title = title
    }
}

extension StructClassActorBootcamp {
    
    private func runTest() {
        print("Test started!")
//        structTest1()
//        printDivider()
//        classTest1()
        structTest2()
    }
    
    private func printDivider() {
        print("""
        
        - - - - - - - - - - - - - - - - - - -
        
        """)
    }
    
    private func structTest1() {
        print("structTest1")
        let objectA = MyStruct(title: "Starting title!")
        print("objectA: \(objectA.title)")
        
        print("Pass the VALUES of objectA to objectB")
        var objectB = objectA
        print("objectB: \(objectB.title)")
        
        objectB.title = "Second title!"
        print("Object B title changed!")
        print("objectA: \(objectA.title)")
        print("objectB: \(objectB.title)")
        
    }
    
    
    private func classTest1() {
        print("classTest1")
        let objectA = MyClass(title: "Starting title!")
        print("objectA: \(objectA.title)")
        
        print("Pass the REFERENCES of objectA to objectB")
        let objectB = objectA
        print("objectB: \(objectB.title)")
        
        objectB.title = "Second title!"
        print("Object B title changed!")
        print("objectA: \(objectA.title)")
        print("objectB: \(objectB.title)")

    }
}

struct MyStruct {
    var title: String
}

// Immutable struct
struct CustomStruct {
    let title: String
    
    func updateTitle(newTitle: String) -> CustomStruct {
        CustomStruct(title: newTitle)
    }
}


struct MutatingStruct {
    var title: String
    
    mutating func updateTitle(newTitle: String) {
        title = newTitle
    }
}


extension StructClassActorBootcamp {
    
    private func structTest2() {
        print("structTest2")
        
                
        var struct1 = MyStruct(title: "title1")
        print("Struct1: \(struct1.title)")
        struct1.title = "title2"
        print("Struct1: \(struct1.title)")
        
        var struct2 = CustomStruct(title: "title1")
        print("Struct2: \(struct2.title)")
        struct2 = CustomStruct(title: "title2")
        print("Struct2: \(struct2.title)")
        
        var struct3 = CustomStruct(title: "title1")
        print("Struct3: \(struct3.title)")
        struct3 = struct3.updateTitle(newTitle: "title2")
        print("Struct3: \(struct3.title)")
        
        var struct4 = MutatingStruct(title: "title1")
        print("Struct4: \(struct4.title)")
        struct4.updateTitle(newTitle: "title2")
        print("Struct4: \(struct4.title)")

        
    }
}
