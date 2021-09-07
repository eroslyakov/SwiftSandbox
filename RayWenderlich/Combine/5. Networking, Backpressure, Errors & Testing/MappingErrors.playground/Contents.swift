import UIKit
import Combine
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

var subscriptions = Set<AnyCancellable>()

enum NameError: Error {
    case tooShort(String)
    case unknown
}

Just("Hello")
    .setFailureType(to: NameError.self)
    .tryMap { throw NameError.tooShort($0) }
    .mapError { $0 as! NameError }
    .sink(receiveCompletion: { completed in
        switch completed {
        case .failure(.tooShort(let input)):
            print("\(input) is too short")
        case .failure(.unknown):
            print("Finished with unknown error")
        case .finished:
            print("Normally finished")
        }
        PlaygroundPage.current.finishExecution()
    },
    receiveValue: { print($0) })


