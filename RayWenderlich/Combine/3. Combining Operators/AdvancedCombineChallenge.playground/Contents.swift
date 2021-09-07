import Foundation
import Combine
import PlaygroundSupport

var subscriptions = Set<AnyCancellable>()

example(of: "Making Phone Numbers Part 2") {
    
    let phoneNumbersPublisher = ["123-4567", "555-1212", "555-1111", "123-6789"].publisher
    let areaCodePublisher = ["410", "757", "800", "540"].publisher
    let phoneExtensionPublisher = ["EXT 901", "EXT 523", "EXT 137", "EXT 100"].publisher
    
    phoneNumbersPublisher
        .zip(areaCodePublisher, phoneExtensionPublisher)
        .sink(receiveCompletion: { print("finished: \($0 == .finished)") },
              receiveValue: { print("\($0.1)-\($0.0) \($0.2)")})
        .store(in: &subscriptions)

}

PlaygroundPage.current.finishExecution()
