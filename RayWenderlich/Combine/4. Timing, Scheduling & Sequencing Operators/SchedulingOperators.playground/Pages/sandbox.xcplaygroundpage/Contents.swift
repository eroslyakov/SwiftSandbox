import Foundation
import Combine
import PlaygroundSupport

let j1 = Just(1)
    .map { _ in print("1", Thread.isMainThread) }
    .subscribe(on: DispatchQueue.global(qos: .background)) // Position of subscribe(on:) has changed
    .map { print("2", Thread.isMainThread) }
    .subscribe(on: DispatchQueue.main) // ignored
    .map { print("3", Thread.isMainThread) }
    .receive(on: DispatchQueue.main)
    .map {  print("4", Thread.isMainThread) }
    .receive(on: DispatchQueue.global())
    .sink { print("5", Thread.isMainThread) }

URLSession.shared.dataTaskPublisher(for: URL(string: "https://www.vadimbulavin.com")!)
    .subscribe(on: DispatchQueue.main) // Subscribe on the main thread
    .map { $0.data }
    .receive(on: DispatchQueue.main)
    .sink(receiveCompletion: { print("fininshed: ", $0 == .finished) },
          receiveValue: { val in
            print(val, Thread.isMainThread) // Are we on the main thread?
          })

struct BusyPublisher: Publisher {
    typealias Output = Int
    
    typealias Failure = Never
    
    func receive<S>(subscriber: S) where S : Subscriber, Failure == S.Failure, Output == S.Input {
        sleep(4)
        subscriber.receive(subscription: Subscriptions.empty)
        subscriber.receive(10)
        subscriber.receive(completion: .finished)
    }
}

let busy = BusyPublisher()
let token = busy
    .subscribe(on: DispatchQueue.global())
    .receive(on: DispatchQueue.main)
    .sink(receiveValue: { print("received from busy", $0) })

print("AFTER REQUEST")





let finExec = Empty<Never, Never>()
    .delay(for: .seconds(5), scheduler: DispatchQueue.global())
    .sink(receiveCompletion: { _ in
        PlaygroundPage.current.finishExecution()
    },
    receiveValue: { _ in })



//: [Next](@next)
