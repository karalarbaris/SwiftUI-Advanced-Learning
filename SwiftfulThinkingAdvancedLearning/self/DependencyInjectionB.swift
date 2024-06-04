//
//  DependencyInjectionB.swift
//  SwiftfulThinkingAdvancedLearning
//
//  Created by Baris Karalar on 04.06.24.
//

import SwiftUI
import Combine


struct PostsModelB: Identifiable, Codable {
    let userId: Int
    let id: Int
    let title: String
    let body: String
}

protocol DataServiceProtocolB {
    func getData() -> AnyPublisher<[PostsModelB], Error>
}

class ProductionDataServiceB: DataServiceProtocolB {
        
    let url: URL
    
    init(url: URL) {
        self.url = url
    }
    
    func getData() -> AnyPublisher<[PostsModelB], Error> {
        URLSession.shared.dataTaskPublisher(for: url)
            .map({ $0.data })
            .decode(type: [PostsModelB].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
}

class MockDataServiceB: DataServiceProtocolB {
    
    let testData: [PostsModelB]
    
    init(testData: [PostsModelB]?) {
        self.testData = testData ?? [ PostsModelB(userId: 123, id: 312332, title: "baro", body: "sdfadsasfd"),
                                      PostsModelB(userId: 879, id: 18979, title: "karo", body: "scaf3223423")
        ]
    }
    
    func getData() -> AnyPublisher<[PostsModelB], any Error> {
        Just(testData)
            .tryMap({ $0 })
            .eraseToAnyPublisher()
    }
    
    
}

class DependencyInjectionBViewModel: ObservableObject {

    @Published var dataArray: [PostsModelB] = []
    var cancellables = Set<AnyCancellable>()
    let dataService: DataServiceProtocolB
    
    init(dataService: DataServiceProtocolB) {
        self.dataService = dataService
        loadPosts()
    }
    
    private func loadPosts() {
        dataService.getData()
            .sink { _ in
                
            } receiveValue: { [weak self] returnedPosts in
                self?.dataArray = returnedPosts
            }
            .store(in: &cancellables)

    }
}

struct DependencyInjectionB: View {
    
    @StateObject private var vm: DependencyInjectionBViewModel
    
    init(dataService: DataServiceProtocolB) {
        _vm = StateObject(wrappedValue: DependencyInjectionBViewModel(dataService: dataService))
    }
    
    var body: some View {
        ScrollView {
            VStack {
                ForEach(vm.dataArray) { post in
                    Text(post.title)
                }
            }
        }
    }
}

#Preview {
//    let dataService = ProductionDataServiceB(url: URL(string: "https://jsonplaceholder.typicode.com/posts")!)
    let dataService = MockDataServiceB(testData: nil)

    return DependencyInjectionB(dataService: dataService)
}
