import XCTest
import Combine
import PlaygroundSupport

class CombineOperatorsTests: XCTestCase {

    var subscriptions = Set<AnyCancellable>()
    
    override func tearDown() {
        subscriptions = []
    }
  
    func test_collect() {
        // given
        let publisher = (1...3).publisher
        
        publisher
            // when
            .collect()
            .sink(receiveValue: { result in
                // then
                XCTAssert(result.count == 3, "Expected an array of length of 3")
            })
            .store(in: &subscriptions)
    }
    
    func test_flatMapWithMax2Publishers() {
        typealias IntPublisher = PassthroughSubject<Int, Never>
        var result = [Int]()
        let expected = [7, 2, 4]
        
        let subject1 = IntPublisher()
        let subject2 = IntPublisher()
        let subject3 = IntPublisher()
        
        let upperSubject = CurrentValueSubject<IntPublisher, Never>(subject1)
        
        upperSubject
            .flatMap(maxPublishers: .max(2)) { $0 }
            .sink(receiveValue: { result.append($0) })
            .store(in: &subscriptions)
        
        subject1.send(7)
        subject2.send(11) // ignored, cause has no subscriber
        upperSubject.send(subject2)
        subject2.send(2)
        subject3.send(23) // ignored, cause has no subscriber
        upperSubject.send(subject3) // ignored, cause flatMap already transformed two publishers
        subject3.send(47) // ignored
        subject3.send(98) // ignored
        subject1.send(4)
        upperSubject.send(completion: .finished)
        
        print("result: \(result)")
        XCTAssert(result == expected, "\(result) doesn't match with expected \(expected)")
    }
    
}

CombineOperatorsTests.defaultTestSuite.run()
PlaygroundPage.current.finishExecution()

/// Copyright (c) 2021 Razeware LLC
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// This project and source code may use libraries or frameworks that are
/// released under various Open-Source licenses. Use of those libraries and
/// frameworks are governed by their own individual licenses.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.
