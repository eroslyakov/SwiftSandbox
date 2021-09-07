import Foundation
import Combine
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

let rwUrl = URL(string: "https://www.raywenderlich.com")!

var subscriptions = Set<AnyCancellable>()

//example(of: "share") {
//    let shared = URLSession.shared
//        .dataTaskPublisher(for: rwUrl)
//        .map(\.data)
//        .print("shared")
//        .share()
//
//    print("subscribing FIRST")
//    shared
//        .sink(
//            receiveCompletion: { _ in print("completed") },
//            receiveValue: { print("subscription ONE received \($0)") }
//        )
//        .store(in: &subscriptions)
//
////    sleep(4)
//    print("subscribing SECOND")
//    shared
//        .sink(
//            receiveCompletion: { _ in print("completed") },
//            receiveValue: { print("subscription TWO received \($0)") }
//        )
//        .store(in: &subscriptions)
//}

example(of: "multicast") {
    
    let multicasted = URLSession.shared
        .dataTaskPublisher(for: rwUrl)
        .map(\.data)
        .print("shared")
        .multicast(subject: PassthroughSubject<Data, URLError>())
    
    multicasted
        .sink(
            receiveCompletion: { print("stream ONE finished: \($0 == .finished)") },
            receiveValue: { print("stream ONE received \($0)") }
        )
        .store(in: &subscriptions)
    
    multicasted
        .sink(
            receiveCompletion: { print("stream TWO finished: \($0 == .finished)") },
            receiveValue: { print("stream TWO received \($0)") }
        )
        .store(in: &subscriptions)
    
    // publish
    multicasted.connect().store(in: &subscriptions)
}
