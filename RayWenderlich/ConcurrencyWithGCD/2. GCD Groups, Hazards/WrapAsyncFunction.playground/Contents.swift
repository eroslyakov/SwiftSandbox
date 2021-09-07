// Copyright (c) 2020 Razeware LLC
// For full license & permission details, see LICENSE.markdown.

import UIKit
import PlaygroundSupport
PlaygroundPage.current.needsIndefiniteExecution = true
//: # Wrapping an Asynchronous Function for DispatchGroup
//: There are lots of asynchronous APIs that don't have group parameters. What can you do with them, so the group knows when they *really* finish?
//:
//: Remember from Part 1 the `slowAdd` function you wrapped as an asynchronous function?
let numberArray = [(0,1), (2,3), (4,5), (6,7), (8,9)]

func isMainThread() -> String {
    return Thread.isMainThread ? "== MAIN THREAD   ==" : "== GLOBAL THREAD =="
}

func asyncAdd(_ input: (Int, Int),
  runQueue: DispatchQueue = DispatchQueue.global(qos: .userInitiated),
  completionQueue: DispatchQueue = DispatchQueue.global(),
  completion: @escaping (Result<Int, SlowAddError>) -> ()) {
  runQueue.async {
    print("\(isMainThread()) from asyncAddGroup [runQueue]")
    let result = slowAddPlus(input)
    completionQueue.async {
        print("\(isMainThread()) from asyncAddGroup [completionQueue]")
        completion(result) }
  }
}
//: Wrap `asyncAdd` function
// TODO: Create asyncAdd_Group
func asyncAddGroup(_ input: (Int, Int),
                   runQueue: DispatchQueue = DispatchQueue.global(qos: .userInitiated),
                   completionQueue: DispatchQueue = DispatchQueue.global(),
                   dispatchGroup: DispatchGroup,
                   completion: @escaping (Result<Int, SlowAddError>) -> ()) {
    print("\(isMainThread()) asyncAddGroup called")
    dispatchGroup.enter()
    asyncAdd(input, runQueue: runQueue, completionQueue: completionQueue) { result in
        print("\(isMainThread()) inside asyncAdd completion closure")
        defer { dispatchGroup.leave() }
        completion(result)
    }
}
//func asyncAddGroup(_ input: (Int, Int),
//                   runQueue: DispatchQueue = DispatchQueue.global(qos: .userInitiated),
//                   completionQueue: DispatchQueue = DispatchQueue.global(),
//                   dispatchGroup: DispatchGroup,
//                   completion: @escaping (Result<Int, SlowAddError>) -> ()) {
//    runQueue.async(group: dispatchGroup, qos: .userInitiated) {
//        let result = slowAddPlus(input)
//        completionQueue.async { completion(result) }
//    }
//}




//print("\n=== Group of async tasks ===\n")
let wrappedGroup = DispatchGroup()

for pair in numberArray {
  // TODO: use the new function here to calculate the sums of the array
    asyncAddGroup(pair, dispatchGroup: wrappedGroup) { result in
        switch result {
        case .success(let sum):
            print("\(isMainThread()) inside asyncAddGroup completion closure: \(sum)")
        case .failure(let error):
            print("\(isMainThread()) inside asyncAddGroup completion closure: \(error)")
        }
    }
}

// TODO: Notify of completion
wrappedGroup.notify(queue: .global()) {
    print("\(isMainThread()) inside notify closure: All slow addings performed")
    PlaygroundPage.current.finishExecution()
}

wrappedGroup.wait()
print("\(isMainThread()) after waiting")
