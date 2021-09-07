//: [to Throttle](@previous)
import Combine
import SwiftUI
import PlaygroundSupport

enum TimeoutError: Error {
    case timedOut
}

let throttleDelay = 1.0

let subject = PassthroughSubject<Void, TimeoutError>()
let timedOutSubject = subject
    .timeout(.seconds(5), scheduler: DispatchQueue.main, customError: { .timedOut })
    .print()

let timeline = TimelineView(title: "original subject")
let timedOutTimeline = TimelineView(title: "timed out subject")

let rootView = VStack(spacing: 50) {
    Button("Press within 5 sec gap", action: subject.send)
    timeline
    timedOutTimeline
}.frame(width: 300, height: 500)

subject.displayEvents(in: timeline)
timedOutSubject.displayEvents(in: timedOutTimeline)

PlaygroundPage.current.liveView = UIHostingController(rootView: rootView)



