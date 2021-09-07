// Copyright (c) 2020 Razeware LLC
// For full license & permission details, see LICENSE.markdown.

import Foundation
import PlaygroundSupport
PlaygroundPage.current.needsIndefiniteExecution = true

// TODO: Create queues with high and low qos values
let high = DispatchQueue.global(qos: .userInteractive)
let medium = DispatchQueue.global(qos: .userInitiated)
let low = DispatchQueue.global(qos: .background)
// TODO: Create semaphore with value 1
let semaphore = DispatchSemaphore(value: 1)

func getCurrentQOS() -> String {
    return String(describing: DispatchQueue.current!.qos.qosClass)
}

// TODO: Dispatch task that sleeps before calling semaphore.wait()
high.async {
    sleep(2)
    print("\(Thread.current.qualityOfService.rawValue) \(getCurrentQOS()) High priority task is now waiting")
    semaphore.wait()
    defer {
        semaphore.signal()
    }
    print("\(Thread.current.qualityOfService.rawValue) \(getCurrentQOS()) High priority task is now running")
    PlaygroundPage.current.finishExecution()
}







for i in 1 ... 10 {
  medium.async {
    print("\(Thread.current.qualityOfService.rawValue) \(getCurrentQOS()) Running Medium task \(i)")
    let waitTime = Double(Int.random(in: 0..<7))
    Thread.sleep(forTimeInterval: waitTime)
  }
}

// TODO: Dispatch task that takes a long time
low.async {
    semaphore.wait()
    defer {
        semaphore.signal()
    }
    print("\(Thread.current.qualityOfService.rawValue) \(getCurrentQOS()) Low priority task is now runnning")
    sleep(5)
}

print("\(Thread.current.qualityOfService.rawValue) \(getCurrentQOS()) Outside priority groups")





