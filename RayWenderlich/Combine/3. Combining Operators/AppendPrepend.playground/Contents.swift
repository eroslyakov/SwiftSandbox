import Foundation
import Combine
import PlaygroundSupport

var subscriptions = Set<AnyCancellable>()

example(of: "prepend") {
    let threeFour = [3, 4].publisher
    let oneTwo = (1...2).publisher
    
    threeFour
        .print()
        .prepend(oneTwo)
        .print()
        .prepend([-1, 0])
        .print()
        .prepend(stride(from: -4, to: -1, by: 1))
//        .collect()
        .print()
        .sink(receiveCompletion: { print("finished: \($0 == .finished)") },
              receiveValue: { print("received \($0)") })
        .store(in: &subscriptions)
}


example(of: "prepend(Publisher) explicit") {
    let threeFour = [3, 4].publisher
    let explicitPublisher = PassthroughSubject<Int, Never>()
    
    threeFour
        .print()
        .prepend(explicitPublisher)
        .print()
        .sink(receiveCompletion: { print("finished: \($0 == .finished)") },
              receiveValue: { print("received \($0)") })
        .store(in: &subscriptions)
    
    explicitPublisher.send(1)
    explicitPublisher.send(2)
    explicitPublisher.send(completion: .finished) // three four won't emit its values unless this
}



example(of: "append") {
    let one = [1].publisher
    
    one
        .print()
        .append([2, 3])
        .print()
        .append(4)
        .sink(receiveValue: { print($0) })
        .store(in: &subscriptions)
}


example(of: "append with explicit emitting") {
    let explicitOne = PassthroughSubject<Int, Never>()
    
    explicitOne
        .print()
        .append([2, 3])
        .print()
        .append(4)
        .sink(receiveValue: { print($0) })
        .store(in: &subscriptions)
    
    
    explicitOne.send(1)
    explicitOne.send(completion: .finished) // append won't work unless first publisher send completion
}



PlaygroundPage.current.finishExecution()
