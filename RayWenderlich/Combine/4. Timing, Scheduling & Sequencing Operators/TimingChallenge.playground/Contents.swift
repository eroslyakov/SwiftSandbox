import Combine
import Foundation
import PlaygroundSupport

// A subject you get values from
let subject = PassthroughSubject<Int, Never>()

let collectSubscription = subject
    .print()
    .collect(.byTime(RunLoop.main, 0.5))
    .map { collected -> String in
        let formatted = collected.map { Character(Unicode.Scalar($0)!) }
        return String(formatted)
    }

let clapSubscription = subject
    .measureInterval(using: RunLoop.current)
    .map { interval in interval > 0.9 ? "👏" : "" }
    .filter { $0 != "" }
    
let mergedSubscription = collectSubscription
    .merge(with: clapSubscription)
    .receive(on: RunLoop.main)
    .collect()
    .sink(
        receiveCompletion: { _ in
            PlaygroundPage.current.finishExecution()
        },
        receiveValue: { print($0.joined()) }
    )

startFeeding(subject: subject)

