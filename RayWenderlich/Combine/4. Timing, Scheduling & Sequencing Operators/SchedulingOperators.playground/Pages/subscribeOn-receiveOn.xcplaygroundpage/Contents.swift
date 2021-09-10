import Foundation
import Combine

let computationPublisher = Publishers.ExpensiveComputation(duration: 5)

let backgroundQueue = DispatchQueue(label: "serial.private", qos: .background)

print("\(deltaTime) Start computation publisher on thread \(Thread.current.number)")

let computationSubscription = computationPublisher
    .subscribe(on: backgroundQueue)
    .receive(on: RunLoop.main)
    .sink { value in
        print("+\(deltaTime) Received computation result on thread \(Thread.current.number): '\(value)'")
    }

print("SOME OTHER WORK ON MAIN THREAD")


