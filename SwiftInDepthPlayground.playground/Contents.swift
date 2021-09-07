
import UIKit
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

//struct LearningPlan {
//    let level: Int
//    var description: String
//
//    lazy private(set) var contents: String = {
//        print(">> Taking my sweet time to calculate...")
//        sleep(2)
//        switch level {
//        case ..<25: return "watch English doc"
//        case ..<50: return "translate a newspaper article"
//        case 100...: return "read academic paper"
//        default: return "try to read for 30 minutes"
//        }
//    }()
//}
//
//
//var todayPlan = LearningPlan(level: 18, description: "a plan for today")
//
//print(Date())

//todayPlan.contents = "watch Netflix"
//for _ in 1...5 {
//    print(todayPlan.contents)
//}
//print(Date())



// 4.8.1
//enum PasteBoardContents {
//    case url(url: String)
//    case emailAddress(emailAddress: String)
//    case other(contents: String)
//}
//
//enum PasteBoardEvent {
//    case added, erased, pasted
//}
//
//
//func describeAction(event: PasteBoardEvent?, contents: PasteBoardContents?) -> String {
//    switch (event, contents) {
//    case let (.added, .url(url)):
//        return "User added url the pasteboard: \(url)."
//    case (.added?, _):
//        return "User added something to the pasteboard"
//    case let (.erased?, .emailAddress(email)):
//        return "User erased email \(email) from the pasteboard"
//    default:
//        return "The pasteboard is updated"
//    }
//}
//
//describeAction(event: .added, contents: .url(url: "www.manning.com"))
//describeAction(event: .added, contents: .emailAddress(emailAddress: "info@manning.com"))
//describeAction(event: .erased, contents: .emailAddress(emailAddress: "info@manning.com"))
//describeAction(event: .erased, contents: nil)
//describeAction(event: nil, contents: .other(contents: "Swift in Depth"))

//let preferences: [String: Bool?] = ["faceIdEnabled": nil]
//
//if preferences["faceIdEnabled"] as? Bool ?? true {
//    print("Go to FaceID settings")
//} else {
//    print("FaceID is turned off")
//}
//
//public enum UserPreference: RawRepresentable {
//    case enabled
//    case disabled
//    case notSet
//
//    public init(rawValue: Bool?) {
//        switch rawValue {
//        case true: self = .enabled
//        case false: self = .disabled
//        default: self = .notSet
//        }
//    }
//
//    public var rawValue: Bool? {
//        switch self {
//            case .enabled: return true
//            case .disabled: return false
//            case .notSet: return nil
//        }
//    }
//}
//let isFaceIdEnabled = preferences["faceIdEnabled"]
//let faceIdPreference = UserPreference(rawValue: isFaceIdEnabled as? Bool)
//print("FaceID is \(faceIdPreference.rawValue)")



// 5.1.3
//struct Pancakes {
//
//    enum SyrupType {
//        case corn, molasses, maple
//    }
//
//    let syrup: SyrupType
//    let stackSize: Int
//
//    init(syrup: SyrupType, stackSize: Int = 10) {
//        self.syrup = syrup
//        self.stackSize = stackSize
//    }
//}
//
//let pancakes = Pancakes(syrup: .corn)
//let pancakes2 = Pancakes(syrup: .maple, stackSize: 7)
//print("pancakes with", pancakes.syrup, "syrup of stack size", pancakes.stackSize)
//print("pancakes with", pancakes2.syrup, "syrup of stack size", pancakes2.stackSize)



// 5.2.6 Inheriatnce and initializators

//protocol DeviceType {
//    init(serialNumber: String, room: String)
//}
//
//class Device: DeviceType {
//    var serialNumber: String
//    var room: String
//
//    static func makeDevice(serialNumber: String = "Unknown", room: String = "Unknown") -> Self {
//        let device = self.init(serialNumber: serialNumber, room: room)
//        return device
//    }
//
//    // required is used in initializer of non-final class
//    // that is conformed to protocol declaring this initializer
//    // and/or has static fabric methods returning an instance
//    // created by this initializer
//    required init(serialNumber: String, room: String) {
//        self.serialNumber = serialNumber
//        self.room = room
//    }
//
//    convenience init() {
//        self.init(serialNumber: "Unknown", room: "Unknown")
//    }
//
//    convenience init(serialNumber: String) {
//        self.init(serialNumber: serialNumber, room: "Unknown")
//    }
//
//    convenience init(room: String) {
//        self.init(serialNumber: "Unknown", room: room)
//    }
//}
//
//class Television: Device {
//    enum ScreenType {
//        case led, oled, lcd, unknown
//    }
//
//    enum Resolution {
//        case ultraHD, fullHD, HD, SD, unknown
//    }
//
//    let resolution: Resolution
//    let screenType: ScreenType
//
//    convenience required init(serialNumber: String, room: String) {
//        self.init(resolution: .unknown, screenType: .unknown, serialNumber: serialNumber, room: room)
//    }
//
//    init(resolution: Resolution, screenType: ScreenType, serialNumber: String, room: String) {
//        self.resolution = resolution
//        self.screenType = screenType
//        super.init(serialNumber: serialNumber, room: room)
//    }
//}
//
//let firstTelevision = Television(room: "Lobby")
//let secondTelevision = Television(serialNumber: "abc")
//let thirdTelevision = Television()
//
//class HandHeldTelevision: Television {
//    let weight: Int
//
//    convenience override init(resolution: Television.Resolution, screenType: Television.ScreenType, serialNumber: String, room: String) {
//        self.init(weight: 50, resolution: resolution, screenType: screenType, serialNumber: serialNumber, room: room)
//    }
//
//    init(weight: Int, resolution: Television.Resolution, screenType: Television.ScreenType, serialNumber: String, room: String) {
//        self.weight = weight
//        super.init(resolution: resolution, screenType: screenType, serialNumber: serialNumber, room: room)
//    }
//}
//
//let handHeldTelevision = HandHeldTelevision.makeDevice(serialNumber: "293nr30znNdjW")
//print(handHeldTelevision.weight, handHeldTelevision.resolution, handHeldTelevision.screenType, handHeldTelevision.serialNumber, handHeldTelevision.room)



// 6.1.2 Errors

public enum ParseLocationError: Error {
    case invalidData
    case middleOfTheOcean
    case locationDoesNotExist
}

public struct Location {
    let latitude: Double
    let longitude: Double
}

func parseLocation(_ latitude: String?, _ longitude: String?) throws -> Location {
    guard let lat = latitude,
          let long = longitude,
          let latitude = Double(lat),
          let longitude = Double(long) else {
        throw ParseLocationError.invalidData
    }
    return Location(latitude: latitude, longitude: longitude)
}

do {
    let location = try parseLocation(nil, "56.45")
    print(location)
} catch {
    print(error)
}

PlaygroundPage.current.finishExecution()
