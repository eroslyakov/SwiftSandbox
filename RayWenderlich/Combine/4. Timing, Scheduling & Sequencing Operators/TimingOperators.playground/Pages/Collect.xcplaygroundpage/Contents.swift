//: [to Delay](@previous)
import Combine
import SwiftUI
import PlaygroundSupport

let valuesPerSecond = 1.0
let collectTimeStride = 4

let sourcePublisher = PassthroughSubject<Date, Never>()
let collectPublisher = sourcePublisher
    .collect(collectTimeStride)
    .flatMap { $0.publisher }

let started = Date()
let timerSubscription = Timer
    .publish(every: 1.0, on: .main, in: .common)
    .autoconnect()
    .print()
    .subscribe(sourcePublisher)

let cancelSubscription = sourcePublisher
    .sink(receiveValue: { current in
        guard current < started + 5 else {
            defer { PlaygroundPage.current.finishExecution() }
            timerSubscription.cancel()
            return
        }
    })

let sourceTimeView = TimelineView(title: "source timeline of emitting values every \(valuesPerSecond) sec")
let batchedTimeView = TimelineView(title: "timeline of batched values by \(collectTimeStride)")

let rootView = VStack(alignment: .center, spacing: 40, content: {
    sourceTimeView
    batchedTimeView
}).frame(width: 300, height: 300, alignment: .top)

sourcePublisher.displayEvents(in: sourceTimeView)
collectPublisher.displayEvents(in: batchedTimeView)

PlaygroundPage.current.liveView = UIHostingController(rootView: rootView)

//: [to Debounce](@next)






