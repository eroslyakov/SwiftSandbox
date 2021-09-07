import Foundation
import Combine
import PlaygroundSupport

var subscriptions = Set<AnyCancellable>()

example(of: "min") {
    let source = [-50, 254, 2].publisher
    
    source
        .print("publisher")
        .min()
        .sink { min in
            print("the minimum is \(min)")
        }
        .store(in: &subscriptions)
}

example(of: "count") {
    let source = (UnicodeScalar("а").value...UnicodeScalar("я").value).publisher
    source
        .compactMap { UnicodeScalar($0) }
        .print("publisher")
        .count()
        .sink(receiveValue: { print("cyrillic alphabet consists of \($0) letters") })
        .store(in: &subscriptions)
}

example(of: "output(at:)") {
    let source = (UnicodeScalar("а").value...UnicodeScalar("я").value).publisher
    let position = 17
    source
        .compactMap { UnicodeScalar($0) }
        .print("publisher")
        .output(at: position)
        .sink(receiveValue: { print("\(position + 1)th cyrillic letter is '\($0)'") })
        .store(in: &subscriptions)
}

example(of: "output(in:)") {
    let source = (UnicodeScalar("а").value...UnicodeScalar("я").value).publisher
    let range = 0...9
    source
        .compactMap { UnicodeScalar($0) }
        .print("publisher")
        .output(in: range)
        .collect()
        .map { $0.map({ Character($0) })}
        .sink(receiveValue: { (chars: [Character]) in
            print("from \(range.min()! + 1) to \(range.max()! + 1) cyrillic letters are '\(chars)'") })
        .store(in: &subscriptions)
}


PlaygroundPage.current.finishExecution()

