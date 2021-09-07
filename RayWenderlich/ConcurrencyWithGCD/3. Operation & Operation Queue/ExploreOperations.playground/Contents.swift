// Copyright (c) 2020 Razeware LLC
// For full license & permission details, see LICENSE.markdown.

import UIKit
import PlaygroundSupport
PlaygroundPage.current.needsIndefiniteExecution = true

let userGroup = DispatchGroup()
let userQueue = DispatchQueue(label: "serial.user.queue", qos: .utility)
DispatchQueue.setPrivateQueueDetection(userQueue)
//: # Explore Operations
//: An `Operation` represents a 'unit of work', and can be constructed as a `BlockOperation` or as a custom subclass of `Operation`.
//: ## BlockOperation
//: Create a `BlockOperation` to add two numbers
var result: Int?
// TODO: Create and run sumOperation
let sumOperation = BlockOperation {
    Thread.sleep(forTimeInterval: 3)
    print(String(describing: DispatchQueue.currentQOSClass!))
    print("is main thread: \(Thread.isMainThread)")
    result = 3 + 5
}

sumOperation.start()

//duration {
//    sumOperation.start()
//}
//userGroup.wait()

result

//: Create a `BlockOperation` with multiple blocks:
// TODO: Create and run multiPrinter
let multiPrinter = BlockOperation { print("First block"); sleep(2) }
multiPrinter.addExecutionBlock { print("Second block"); sleep(2) }
multiPrinter.addExecutionBlock { print("Third block"); sleep(2) }
multiPrinter.addExecutionBlock { print("Fourth block"); sleep(2) }
multiPrinter.addExecutionBlock { print("Fifth block"); sleep(2) }
multiPrinter.completionBlock = {
    print("all messages are printed!")
}

duration {
    multiPrinter.start()
}



PlaygroundPage.current.finishExecution()
