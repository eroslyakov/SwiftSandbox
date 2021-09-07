import Foundation
import Combine
import PlaygroundSupport

var subscriptions = Set<AnyCancellable>()

example(of: "filter") {
    let numbers = (1...10).publisher
    
    numbers
        .filter { $0.isMultiple(of: 3) }
        .sink(receiveValue: { print("\($0) is multiple of 3") })
        .store(in: &subscriptions)
}



example(of: "removeDuplicates") {
    let words = "hey hey there ! want to listen to mister mister ?"
        .components(separatedBy: " ")
        .publisher
    
    words
        .removeDuplicates()
        .collect()
        .sink(receiveValue: { print($0.joined(separator: " ")) })
        .store(in: &subscriptions)
}



example(of: "compactMap") {
    let strings = ["a", "1.24", "3", "def", "76", "0.879"].publisher
    
    strings
        .compactMap { Float($0) }
        .sink(receiveValue: { print($0) })
        .store(in: &subscriptions)
}


example(of: "first(where:)") {
    let numbers = (1...9).publisher
    
    numbers
        .print()
        .first(where: { $0 % 3 == 0 })
        .sink(receiveCompletion: { print("completed with: \($0)") },
              receiveValue: { print($0) })
        .store(in: &subscriptions)
}


example(of: "last(where:)") {
    let numbers = (1...9).publisher
    
    numbers
        .print()
        .last(where: { $0 % 3 == 0 })
        .sink(receiveCompletion: { print("completed: \($0 == .finished)") },
              receiveValue: { print("value \($0)") })
        .store(in: &subscriptions)
}

example(of: "last(where:)") {
    let numbers = PassthroughSubject<Int, Never>()
    
    numbers
        .print()
        .last(where: { $0 % 3 == 0 })
        .sink(receiveCompletion: { print("completed: \($0 == .finished)") },
              receiveValue: { print("value \($0)") })
        .store(in: &subscriptions)
    
    numbers.send(1)
    numbers.send(2)
    numbers.send(3)
    numbers.send(4)
    numbers.send(5)
    numbers.send(6)
    numbers.send(7)
    numbers.send(8)
    numbers.send(completion: .finished)
}



example(of: "prefix") {
    let numbers = (1...10).publisher
    
    numbers
        .prefix(while: { $0 < 6 })
        .sink(receiveValue: { print("value \($0)") })
        .store(in: &subscriptions)
}



example(of: "drop") {
    let numbers = (1...10).publisher
    
    numbers
        .print()
        .drop(while: { $0 < 5 })
        .sink(receiveValue: { print($0) })
        .store(in: &subscriptions)
}





PlaygroundPage.current.finishExecution()
