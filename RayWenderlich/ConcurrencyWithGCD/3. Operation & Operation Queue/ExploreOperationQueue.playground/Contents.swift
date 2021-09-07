// Copyright (c) 2020 Razeware LLC
// For full license & permission details, see LICENSE.markdown.

import UIKit
import PlaygroundSupport
PlaygroundPage.current.needsIndefiniteExecution = true
//: # Explore OperationQueue
//: `OperationQueue` is responsible for scheduling and running a set of operations, somewhere in the background.
//: ## Creating a queue
//: Creating a queue is simple, using the default initializer; you can also set the maximum number of queued operations that can execute at the same time:
// TODO: Create printerQueue
let printerQueue = OperationQueue()
// TODO later: Set maximum to 2
printerQueue.maxConcurrentOperationCount = 1
//printerQueue.underlyingQueue = DispatchQueue.main
//: ## Adding `Operations` to Queues
/*: `Operation`s can be added to queues directly as closures
 - important:
 Adding operations to a queue is really "cheap"; although the operations can start executing as soon as they arrive on the queue, adding them is completely asynchronous.
 \
 You can see that here, with the result of the `duration` function:
 */
let op1 = BlockOperation { print("isMain: \(Thread.isMainThread) - First operation"); sleep(2) }
op1.qualityOfService = .utility
let op2 = BlockOperation { print("isMain: \(Thread.isMainThread) - Second operation"); sleep(2) }
op2.qualityOfService = .utility
let op3 = BlockOperation { print("isMain: \(Thread.isMainThread) - Third operation"); sleep(2) }
op3.qualityOfService = .background
let op4 = BlockOperation { print("isMain: \(Thread.isMainThread) - Fourth operation"); sleep(2) }
op4.qualityOfService = .background
let op5 = BlockOperation { print("isMain: \(Thread.isMainThread) - Fifth operation"); sleep(2) }
op5.qualityOfService = .userInitiated

op5.completionBlock = {
    print("Fifth operation is completed!")
}

// TODO: Add 5 operations to printerQueue
//duration {
//    printerQueue.addOperation(op1)
//    printerQueue.addOperation(op2)
//    printerQueue.addOperation(op3)
//    printerQueue.addOperation(op4)
//    printerQueue.addOperation(op5)
//}

// TODO: Measure duration of all operations
//duration {
//    printerQueue.waitUntilAllOperationsAreFinished()
//}

let privateQueue = DispatchQueue(label: "private.serial", qos: .utility)
let privateGroup = DispatchGroup()
privateQueue.async(group: privateGroup) {
    printerQueue.addOperations([op1, op2, op3, op4, op5], waitUntilFinished: true)
}

privateGroup.notify(queue: .global(qos: .userInteractive)) {
    print("All operations are done!")
    PlaygroundPage.current.finishExecution()
}

print("Last print line (should appear first)")

