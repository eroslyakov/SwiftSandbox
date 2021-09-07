import UIKit
import Combine
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

var subscriptions = Set<AnyCancellable>()

let photoService = PhotoService()
var i = 0

photoService
    .fetchPhoto(quality: .high)
    .handleEvents(receiveSubscription: { _ in i += 1; print("Trying... \(i)") },
                  receiveOutput: { print("Got a value: \($0)") },
                  receiveCompletion: { completion in
                    guard case .failure(let error) = completion else {
                        return
                    }
                    print("Try failure: \(error)")
                  })
    .retry(3)
    .catch { error -> PhotoService.Publisher in
        print("Failed getting high resolution image; fallback to low resolution")
        return photoService.fetchPhoto(quality: .low)
    }
    .replaceError(with: UIImage(named: "na.jpg")!)
    .sink(
        receiveCompletion: {
            print($0)
            PlaygroundPage.current.finishExecution()
        },
        receiveValue: { image in
            image
            print("Got an image: \(image)") }
    )
    .store(in: &subscriptions)
