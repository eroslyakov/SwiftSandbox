import Foundation
import Combine

var subscriptions = Set<AnyCancellable>()

example(of: "Making Phone Numbers") {

  let phoneNumbersPublisher = ["123-4567"].publisher
  let areaCode = "410"
  let phoneExtension = "901"

  
  phoneNumbersPublisher
    .prepend("1", areaCode)
    .append(phoneExtension)
    .collect()
    .sink(receiveValue: { print("Phone number is: \($0.joined(separator: "-"))")})
    .store(in: &subscriptions)
}
