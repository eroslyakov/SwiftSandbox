import Foundation
import Combine
import PlaygroundSupport

var subscriptions = Set<AnyCancellable>()

example(of: "collect") {
    var collected = [String]()
    
    ["A", "B", "C", "D", "E"]
        .publisher
        .map({ $0 + "+++"})
        .collect(2)
        .sink(receiveCompletion: { print($0) },
              receiveValue: {
                print("Received value: \($0)")
                collected.append(contentsOf: $0)
              })
        .store(in: &subscriptions)
    
    print(collected)
}

example(of: "map") {
    var res = [String]()
    let formatter = NumberFormatter()
    formatter.numberStyle = .spellOut
    
    [1, 7, 27, 198]
        .publisher
        .map {
            formatter.string(from: NSNumber(integerLiteral: $0)) ?? ""
        }
        .collect()
        .sink(receiveValue: { print($0); res.append(contentsOf: $0) })
        .store(in: &subscriptions)
    
    print(res)
}

example(of: "replaceEmpty") {
    let empty = Empty<Int, Never>()
    
    empty
        .replaceEmpty(with: 1)
        .sink(receiveCompletion: { print($0)},
              receiveValue: { print($0) })
        .store(in: &subscriptions)
}


example(of: "scan") {
    var dailyGainLoss: Int { .random(in: -10...10) }
    
    let stockPrice = (0..<22)
        .map { _ in
            dailyGainLoss
        }
        .publisher
        .print()
    
    stockPrice
        .scan(50) { prev, cur in
            max(0, prev + cur)
        }
        .sink(receiveValue: { print($0) })
        .store(in: &subscriptions)
}

example(of: "flatMap") {
    let charlotte = Chatter(name: "Charlotte", message: "Hi, I'm Charlotte")
    let james = Chatter(name: "James", message: "Hi, I'm James")
    
    let chat = CurrentValueSubject<Chatter, Never>(charlotte)
    
    chat
        .flatMap { $0.message }
        .sink(receiveValue: { print("received \($0)") })
        .store(in: &subscriptions)
    
    chat.value = james
    
    charlotte.message.value = "Charlotte: How's it going?"
    james.message.value = "James: Doing great. You?"
    charlotte.message.value = "Charlotte: You're so boring. Bye."
}

PlaygroundPage.current.finishExecution()
