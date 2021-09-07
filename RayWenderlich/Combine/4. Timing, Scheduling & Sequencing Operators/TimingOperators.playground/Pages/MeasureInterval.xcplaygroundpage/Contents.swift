//: [to Timeout](@previous)
import Combine
import SwiftUI
import PlaygroundSupport

let subject = PassthroughSubject<String, Never>()
let measureSubject = subject
    .measureInterval(using: RunLoop.current)

let timeline = TimelineView(title: "Emitted values")
let measureTimeline = TimelineView(title: "Measured values")

subject.displayEvents(in: timeline)
measureSubject.displayEvents(in: measureTimeline)

let rootView = VStack(spacing: 100) {
    timeline
    measureTimeline
}.frame(width: 300, height: 300)

PlaygroundPage.current.liveView = UIHostingController(rootView: rootView)

let printSubjectSubscr = subject
    .sink(receiveValue: { print("\(deltaTime) subject emitted \($0)") })
let printMeasureSubscr = measureSubject
    .sink(receiveValue: { print("\(deltaTime) measure emitted \(round($0.magnitude * 100) / 100)") })

subject.feed(with: typingHelloWorld)



