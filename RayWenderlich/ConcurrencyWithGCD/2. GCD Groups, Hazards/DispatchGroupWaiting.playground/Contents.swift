// Copyright (c) 2020 Razeware LLC
// For full license & permission details, see LICENSE.markdown.

import UIKit
import PlaygroundSupport
PlaygroundPage.current.needsIndefiniteExecution = true
//: # DispatchGroup Waiting
//: You can make the current thread wait for a dispatch group to complete.
//:
//: __DANGER__ This is a synchronous call on the __current__ queue, so will block it. You cannot have anything in the group that needs to use the current queue, otherwise you'll deadlock.
let group = DispatchGroup()
let queue = DispatchQueue.global(qos: .userInitiated)
let mainQueue = DispatchQueue.main
let defaultQueue = DispatchQueue.global()

enum Queues { case mainq, globalq, defaultq }
let specificnKey = DispatchSpecificKey<Queues>()
mainQueue.setSpecific(key: specificnKey, value: .mainq)
queue.setSpecific(key: specificnKey, value: .globalq)
defaultQueue.setSpecific(key: specificnKey, value: .defaultq)

func printContextQueue() -> String {
    switch DispatchQueue.getSpecific(key: specificnKey) {
    case .globalq:
        return "== Global Queue: "
    case .mainq:
        return "== Main Queue: "
    case .defaultq:
        return "== Default Queue"
    case .none:
        return ""
    }
}

queue.async(group: group) {
    let queue = printContextQueue()
    print("\(queue) Start task 1")
    sleep(4)
    print("\(queue)End task 1")
}

queue.async(group: group) {
    let queue = printContextQueue()
    print("\(queue) Start task 2")
    sleep(1)
    print("\(queue) End task 2")
}

group.notify(queue: defaultQueue) {
  // TODO: Announce completion, stop playground page
    print("\(printContextQueue()) Task Group completed.")
    PlaygroundPage.current.finishExecution()
}
//: The tasks continue to run, even if the wait times out.
// TODO: Wait for 5 seconds, then for 3 seconds
if group.wait(timeout: .now() + 5) == .timedOut {
    print("\(printContextQueue()) tired of waiting")
    PlaygroundPage.current.finishExecution()
}
print("\(printContextQueue()) outside sync wait")




