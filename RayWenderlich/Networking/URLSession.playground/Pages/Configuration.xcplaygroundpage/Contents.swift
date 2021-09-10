import UIKit

let sharedSession = URLSession.shared
sharedSession.configuration.allowsCellularAccess // readonly
sharedSession.configuration.allowsCellularAccess = false // nothing changed
sharedSession.configuration.allowsCellularAccess

let myDefaultConfiguration = URLSessionConfiguration.default
let ephemeralConfig = URLSessionConfiguration.ephemeral
let backgroundConfiguration = URLSessionConfiguration.background(withIdentifier: "com.rosliakovevgenii.background.sessions")

myDefaultConfiguration.allowsCellularAccess = false // changed
myDefaultConfiguration.allowsCellularAccess

myDefaultConfiguration.allowsExpensiveNetworkAccess = true
myDefaultConfiguration.allowsConstrainedNetworkAccess = true

let myDefaultSession = URLSession(configuration: myDefaultConfiguration)
myDefaultSession.configuration.allowsConstrainedNetworkAccess
myDefaultSession.delegate

//: [Next](@next)

