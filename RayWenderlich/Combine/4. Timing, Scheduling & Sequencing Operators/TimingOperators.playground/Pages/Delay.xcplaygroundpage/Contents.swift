import Combine
import SwiftUI
import PlaygroundSupport

let valuesPerSecond = 1.0
let delayInSeconds = 1.5
let started = Date()

let sourcePublisher = PassthroughSubject<Date, Never>()

let delayedPublisher = sourcePublisher.delay(for: .seconds(delayInSeconds), scheduler: RunLoop.current)

let subscription = Timer
    .publish(every: 1.0, on: .current, in: .common)
    .autoconnect()
    .subscribe(sourcePublisher)

let stopper = delayedPublisher
    .sink(receiveValue: { if $0 > started + 10 { PlaygroundPage.current.finishExecution() } })

let sourceTimeline = TimelineView(title: "Emitted values \(valuesPerSecond) per sec: ")
let delayedTimeline = TimelineView(title: "Delayed values with \(delayInSeconds) sec delay")

let view = VStack {
    sourceTimeline
    delayedTimeline
}

PlaygroundPage.current.liveView = UIHostingController(rootView: view)

sourcePublisher.displayEvents(in: sourceTimeline)
delayedPublisher.displayEvents(in: delayedTimeline)




//: [To Collect](@next)
