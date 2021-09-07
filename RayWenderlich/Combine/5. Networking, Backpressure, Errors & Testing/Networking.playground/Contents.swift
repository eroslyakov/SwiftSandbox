import Foundation
import Combine
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

var subscriptions = Set<AnyCancellable>()

struct Todo: Codable {
    let userId, id: Int
    let title: String
    let completed: Bool
}

example(of: "dataTaskPublisher with tryMap") {
    guard let url = URL(string: "https://jsonplaceholder.typicode.com/todos/1") else {
        return
    }
    
    URLSession.shared
        .dataTaskPublisher(for: url)
        .tryMap { try JSONDecoder().decode(Todo.self, from: $0.data) }
        .sink(receiveCompletion: { completion in
            switch completion {
            case .finished:
                print("Normally finished")
            case .failure(let error):
                print("Finished with error: \(error)")
            }
            PlaygroundPage.current.finishExecution()
        }, receiveValue: { decoded in
            print("Response: \(decoded)")
        })
        .store(in: &subscriptions)
}

//example(of: "dataTaskPublisher with decode Operator") {
//    guard let url = URL(string: "https://jsonplaceholder.typicode.com/todos/1") else {
//        return
//    }
//    
//    URLSession.shared
//        .dataTaskPublisher(for: url)
//        .map { $0.data }
//        .decode(type: Todo.self, decoder: JSONDecoder())
//        .sink(receiveCompletion: { completion in
//            switch completion {
//            case .finished:
//                print("Normally finished")
//            case .failure(let error):
//                print("Finished with error: \(error)")
//            }
//            PlaygroundPage.current.finishExecution()
//        }, receiveValue: { decoded in
//            print("Response: \(decoded)")
//        })
//        .store(in: &subscriptions)
//}
