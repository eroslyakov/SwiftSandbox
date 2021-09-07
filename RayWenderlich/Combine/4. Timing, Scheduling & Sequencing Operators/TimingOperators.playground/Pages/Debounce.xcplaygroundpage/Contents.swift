//: [to Collect](@previous)
import Combine
import SwiftUI
import PlaygroundSupport

let subject = PassthroughSubject<String, Never>()
let debounced = subject
    .debounce(for: .seconds(1), scheduler: DispatchQueue.main)
    .share()

let subjectTimeline = TimelineView(title: "Emitted values")
let debouncedTimeline = TimelineView(title: "Debounced values")

let rootView = VStack(spacing: 50) {
    subjectTimeline
    debouncedTimeline
}.frame(width: 300, height: 300)


subject.displayEvents(in: subjectTimeline)
debounced.displayEvents(in: debouncedTimeline)

subject.feed(with: typingHelloWorld)


PlaygroundPage.current.liveView = UIHostingController(rootView: rootView)


let printSubscription1 = subject
    .sink(receiveValue: { print("+\(deltaTime)s: Subject emitted: \($0)") })

let printSubscription2 = debounced
    .sink(receiveValue: { print("+\(deltaTime)s: Debounced emitted: \($0)") })

//: [to Throttle](@next)
