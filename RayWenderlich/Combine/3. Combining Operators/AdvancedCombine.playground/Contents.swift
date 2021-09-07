import Foundation
import Combine
import PlaygroundSupport

var subscriptions = Set<AnyCancellable>()

example(of: "switchToLatest") {
    let first = PassthroughSubject<Int, Never>()
    let second = PassthroughSubject<Int, Never>()
    let third = PassthroughSubject<Int, Never>()
    
    let publishers = PassthroughSubject<PassthroughSubject<Int, Never>, Never>()
    
    publishers
        .switchToLatest()
        .sink(receiveCompletion: { print("finished: \($0 == .finished)") },
              receiveValue: { print("received \($0)") })
        .store(in: &subscriptions)
    
    publishers.send(first)
    first.send(3)
    publishers.send(second) // after that switch first publisher will be cancelled (line 26 won't emit value 4)
    second.send(5)
    publishers.send(third) // after that switch seccond publisher will be cancelled (line 28 won't emit value 6)
    
    first.send(4) // ignored
    
    second.send(6) // ignored
    
    third.send(7)
    
    third.send(completion: .finished)
    
    publishers.send(completion: .finished)
}



example(of: "merge") {
    let publisher1 = PassthroughSubject<Int, Never>()
    let publisher2 = PassthroughSubject<Int, Never>()
    
    publisher1
        .merge(with: publisher2)
        .sink(receiveCompletion: { print("finished: \($0 == .finished)") },
              receiveValue: { print("received \($0)") })
        .store(in: &subscriptions)
    
    publisher1.send(9)
    publisher2.send(1)
    publisher1.send(8)
    publisher2.send(2)
    publisher1.send(7)
    publisher2.send(3)
    publisher1.send(6)
    publisher2.send(4)
    publisher1.send(5)
    
    publisher1.send(completion: .finished)
    publisher2.send(completion: .finished)
}


example(of: "combineLatest") {
    let publisherInt = PassthroughSubject<Int, Never>()
    let publisherStr = PassthroughSubject<String, Never>()
    
    publisherInt
        .combineLatest(publisherStr)
        .sink(receiveCompletion: { print("finished: \($0 == .finished)") },
              receiveValue: { print("received \($0)") })
        .store(in: &subscriptions)
    
    publisherInt.send(9)
    publisherInt.send(8)
    publisherStr.send("1")
    publisherStr.send("2")
    publisherInt.send(7)
    publisherStr.send("3")
    publisherInt.send(6)
    publisherStr.send("4")
    publisherInt.send(5)
    publisherStr.send("5")
    
    publisherInt.send(completion: .finished)
    publisherStr.send(completion: .finished)
}


example(of: "zip") {
    let publisherInt = PassthroughSubject<Int, Never>()
    let publisherStr = PassthroughSubject<String, Never>()
    
    publisherInt
        .zip(publisherStr)
        .sink(receiveCompletion: { print("finished: \($0 == .finished)") },
              receiveValue: { print("received \($0)") })
        .store(in: &subscriptions)
    
    publisherInt.send(1)
    publisherInt.send(2)
    publisherStr.send("a")
    publisherStr.send("b")
    publisherInt.send(3)
    publisherStr.send("c")
    publisherInt.send(4)
    publisherStr.send("d")
    publisherInt.send(5)
    publisherStr.send("e")
    
    publisherInt.send(completion: .finished)
    publisherStr.send(completion: .finished)
}

PlaygroundPage.current.finishExecution()
