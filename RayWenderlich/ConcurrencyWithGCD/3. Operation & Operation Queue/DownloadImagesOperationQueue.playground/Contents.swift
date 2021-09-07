// Copyright (c) 2020 Razeware LLC
// For full license & permission details, see LICENSE.markdown.

import UIKit
import PlaygroundSupport
PlaygroundPage.current.needsIndefiniteExecution = true
//: # Downloading Images in an OperationQueue
//: Subclass `AsyncOperation` to create an operation that
//: uses `URLSession` `dataTask(with:)` to download an image.
//: Then use this in an `OperationQueue` to download the images
//: represented by the `ids` array.
class ImageLoadOperation: AsyncOperation {
    private let url: URL
    var image: UIImage?
    
    init(url: URL) {
        self.url = url
        super.init()
    }
    
    // TODO: Call dataTask with url and save image
    override func main() {
        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let self = self else { return }
            defer { self.state = .finished }
            guard error == nil,
               let data = data,
               let image = UIImage(data: data) else {
                print("Image from \(self.url) is broken")
                return
            }
            self.image = image
        }.resume()
    }
}
//: For each `id`, create a `url`.
//: Then, for each url, create an `ImageLoadOperation`,
//: and add it to an `OperationQueue`.
//: When each operation completes, add its output `image` to the `images` array.
let base = "https://wolverine.raywenderlich.com/books/con/image-from-rawpixel-id-"
let ids = [466881, 466910, 466925, 466931, 466978, 467028, 467032, 467042, 467052, 00000]
var images: [UIImage] = []
let queue = OperationQueue()

for (id, imageId) in ids.enumerated() {
    guard let url = URL(string: "\(base)\(imageId)-jpeg.jpg") else {
        print("Url for imageId \(imageId) invalid")
        continue
    }
    // TODO: Create operation with completionBlock and add to queue
    let loadingOperation = ImageLoadOperation(url: url)
    loadingOperation.completionBlock = {
        defer {
            if id == ids.count - 1 {
                print("All images are loaded! \(images.count) items")
                images[7]
                PlaygroundPage.current.finishExecution()
            }
        }
        guard let image = loadingOperation.image else {
            print("There is no image from url \(url)")
            return
        }
        images.append(image)
        print("image \(id) is loaded and saved")
    }
    queue.addOperation(loadingOperation)
}

duration {
    queue.waitUntilAllOperationsAreFinished()
}

//images[7]
//
//PlaygroundPage.current.finishExecution()
