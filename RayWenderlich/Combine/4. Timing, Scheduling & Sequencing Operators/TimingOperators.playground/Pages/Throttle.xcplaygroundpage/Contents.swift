//: [to Debounce](@previous)
import Combine
import SwiftUI
import PlaygroundSupport

let throttleDelay = 1.0

let subject = PassthroughSubject<String, Never>()
let throttled = subject
    .throttle(for: .seconds(throttleDelay), scheduler: DispatchQueue.main, latest: true)
    .share()

let subjectTimeline = TimelineView(title: "Emitted values")
let throttledTimeline = TimelineView(title: "Throttled values")

let rootView = VStack(spacing: 50) {
    subjectTimeline
    throttledTimeline
}.frame(width: 300, height: 300)


subject.displayEvents(in: subjectTimeline)
throttled.displayEvents(in: throttledTimeline)

subject.feed(with: typingHelloWorld)


PlaygroundPage.current.liveView = UIHostingController(rootView: rootView)


let printEmitted = subject
    .sink(receiveValue: { print("+\(deltaTime)s: Subject emitted: \($0)") })

let printThrottled = throttled
    .sink(receiveValue: { print("+\(deltaTime)s: Throttled emitted: \($0)") })

