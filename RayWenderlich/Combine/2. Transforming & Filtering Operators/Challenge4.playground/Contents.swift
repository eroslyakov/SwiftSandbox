import Foundation
import Combine
import PlaygroundSupport

var subscriptions = Set<AnyCancellable>()

example(of: "challenge") {
    let numbers = (1...100).publisher
    
    numbers
        .dropFirst(50)
        .prefix(20)
        .filter { $0 % 2 == 0 }
        .sink(receiveCompletion: { print("finished: \($0 == .finished)") },
              receiveValue: { print("\($0) is even") })
        .store(in: &subscriptions)
}


PlaygroundPage.current.finishExecution()
