import Foundation
import Combine

var subscriptions = Set<AnyCancellable>()

example(of: "NotificationCenter") {
    let nCenter = NotificationCenter.default
    let myNotification = Notification.Name("MyNotification")
    let publisher = nCenter
        .publisher(for: myNotification, object: nil)
    
    let subscription = publisher
        .print()
        .sink { notification in
            print("\(notification.name.rawValue) received from a publisher!")
        }
    
    nCenter.post(name: myNotification, object: nil)
    subscription.cancel()
    nCenter.post(name: myNotification, object: nil)
}



example(of: "Just") {
    let just = Just("Hello world")
    
    just
        .sink(receiveCompletion: {
            print("Received completion: \($0) of \(type(of: $0))")
        }, receiveValue: {
            print("Received value: \($0) of \(type(of: $0))")
        })
        .store(in: &subscriptions)
}



example(of: "assign(to:on:)") {
    class SomeObject {
        var value: String = "" {
            didSet {
                print(value)
            }
        }
    }
    
    let object = SomeObject()
    
    
    ["Hello", "World", "!"]
        .publisher
        .print()
        .assign(to: \.value, on: object)
        .store(in: &subscriptions)
}



example(of: "PassthroughSubject") {
    let subject = PassthroughSubject<String, Never>()
    
    let subscription = subject
        .sink(receiveValue: { print("Received value: \($0)") })
        
    subscription.store(in: &subscriptions)
    
    subject.send("Hi, Passthrough Subject!")
//    subscription.cancel()
    subject.send(completion: .finished)
    
    subject.send("Do you hear me?") // won't be send
    print(subscriptions.count)
}



example(of: "CurrentValueSubject") {
    let subject = CurrentValueSubject<Int, Never>(0)
    
    let subscription = subject
        .print()
        .sink(receiveValue: { print("Received value: \($0)") })
    subscription.store(in: &subscriptions)
    
    subject.send(7)
    subject.send(13)
    print("subject current value: \(subject.value)")
    subject.send(27)
    
    subject.send(completion: .finished)
    subject.send(9)
}



example(of: "Type erasure") {
    let subject = PassthroughSubject<Int, Never>()
    
    let publisher = subject.eraseToAnyPublisher() // erasing publisher type
    
    // publisher.send(2) doesn't work
    publisher
        .print()
        .sink(receiveValue: { print("Received value: \($0)") })
        .store(in: &subscriptions)
    
    subject.send(3)
    subject.send(7)
    subject.send(completion: .finished)
}

