//
//  GenericsB.swift
//  SwiftfulThinkingAdvancedLearning
//
//  Created by Baris Karalar on 13.03.24.
//

import SwiftUI

struct StringModelB {
    
    let info: String?
    
    func removeInfo() -> StringModelB {
        return StringModelB(info: nil)
    }
}

struct GenericModelB<T> {
    let info: T?
    
    func removeInfo() -> GenericModelB {
        GenericModelB(info: nil)
    }
}


class GenericBViewModel: ObservableObject {
    
    @Published var stringModel = StringModelB(info: "Hello Baris")
    
    @Published var genericStringModel = GenericModelB(info: "Hello world")
    @Published var genericBoolModel = GenericModelB(info: true)
    
    func removeData() {
        stringModel = stringModel.removeInfo()
        genericStringModel = genericStringModel.removeInfo()
        genericBoolModel = genericBoolModel.removeInfo()
    }
    
}

struct GenericViewB<T:View>: View {
    
    let content: T
    let title: String
    
    var body: some View {
        VStack {
            Text(title)
            content
        }
    }
}

struct GenericsB: View {
    
    @StateObject private var vm = GenericBViewModel()
    
    var body: some View {
        VStack {
            
            GenericViewB(content: Text("custom content"), title: "hohhoh hoh")
            
            Text(vm.stringModel.info ?? "no data")
            Text(vm.genericStringModel.info ?? "no data")
            Text(vm.genericBoolModel.info?.description ?? "no data")
        }
        .onTapGesture {
            vm.removeData()
        }
    }
}

#Preview {
    GenericsB()
}
