// Copyright (c) 2020 Razeware LLC
// For full license & permission details, see LICENSE.markdown.

import UIKit
import PlaygroundSupport
PlaygroundPage.current.needsIndefiniteExecution = true
//: # DispatchSemaphore
let group = DispatchGroup()
let queue = DispatchQueue.global(qos: .userInitiated)
// TODO: Create a semaphore that allows four concurrent accesses
let semaphore = DispatchSemaphore(value: 4)
// TODO: Simulate downloading group of images
//for i in 1...10 {
//    queue.async(group: group) {
//        semaphore.wait()
//        defer {
//            print("deffered \(i)")
//            semaphore.signal()
//        }
//        print("Downloading image \(i)")
//        Thread.sleep(forTimeInterval: 3)
//        print("Image \(i) downloaded")
//    }
//}

func threadInfo() -> String {
    return "\(Thread.current.isMainThread ? "= Main =" : "= Glob =") \(Thread.current.qualityOfService.rawValue)"
}



// Really download group of images
let base = "https://wolverine.raywenderlich.com/books/con/image-from-rawpixel-id-"
let ids = [466881, 466910, 466925, 466931, 466978, 467028, 467032, 467042, 467052]
var images: [UIImage] = []

// TODO: Add semaphore argument to dataTask_Group
func dataTask_Group_Semaphore(with id: Int,
                              group: DispatchGroup,
                              semaphore: DispatchSemaphore,
                              completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
    // TODO: wait for semaphore before entering group
    guard let url = URL(string: "\(base)\(id)-jpeg.jpg") else { return }
    semaphore.wait()
    group.enter()
    print("\(threadInfo()) dataTask_Group_Semaphore called for \(id)")
    URLSession.shared.dataTask(with: url) { data, response, error in
        print("\(threadInfo()) dataTask_Group_Semaphore URLSession dataTask for \(id)")
        defer {
            print("\(threadInfo()) dataTask_Group_Semaphore defer block for \(id)")
            group.leave()
            semaphore.signal()
        }
        DispatchQueue.main.async {
            completionHandler(data, response, error)
        }
    }.resume()
}

for id in ids {
//    guard let url = URL(string: "\(base)\(id)-jpeg.jpg") else { continue }
    // TODO: Call dataTask_Group_Semaphore
    dataTask_Group_Semaphore(with: id, group: group, semaphore: semaphore) { data, _, error in
        guard error == nil, let data = data, let image = UIImage(data: data) else {
            return
        }
        print("\(threadInfo()) dataTask_Group_Semaphore completionHandler for \(id)")
        images.append(image)
    }
}

group.notify(queue: .main) {
    print("\(threadInfo()) All done!")
    images[0]
    PlaygroundPage.current.finishExecution()
}

//group.wait()
print("\(threadInfo()) After awaiting.")
