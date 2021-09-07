import UIKit
import Combine
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

var subscriptions = Set<AnyCancellable>()

class IntSubscriber: Subscriber {
    
    typealias Input = Int
    typealias Failure = Never
    
    func receive(subscription: Subscription) {
        subscription.request(.max(2))
    }
    
    func receive(_ input: Int) -> Subscribers.Demand {
        print("Received value \(input)")
        switch input {
        case 1...3:
            return .max(1)
        case 5:
            return .max(2)
        default:
            return .none
        }
    }
    
    func receive(completion: Subscribers.Completion<Never>) {
        print("Received \(completion)")
    }
}

let subscriber = IntSubscriber()

let publisher = (1...10).publisher

publisher
    .subscribe(subscriber)



