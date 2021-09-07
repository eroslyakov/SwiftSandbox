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
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import XCTest
@testable import DogPatch


struct OrthopedicDogtor: Decodable {
  let id: String
  let sellerID: String
  let about: String
  let birthday: Date
  let breed: String
  let breederRating: Double
  let cost: Decimal
  let created: Date
  let imageURL: URL
  let name: String
  let bone: Int
}
// stub for server request
struct FakeDataTaskMaker: DataTaskMaker {
  static let dummyUrl = URL(string: "dummy")!
  let data: Data
  
  init() {
    let testBundle = Bundle(for: AsyncDogPatchTestCase.self)
    let dataURL = testBundle.url(forResource: "dogs", withExtension: "json")!
    data = try! Data(contentsOf: dataURL)
  }
  
  func dataTask(with _: URL,
                completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void
  ) -> URLSessionDataTask {
    completionHandler(
      data,
      HTTPURLResponse(
        url: Self.dummyUrl,
        statusCode: 200,
        httpVersion: nil,
        headerFields: nil
      ),
      nil
    )
    return URLSession.shared.dataTask(with: Self.dummyUrl)
  }
}

final class AsyncDogPatchTestCase: XCTestCase {
  let timeout: TimeInterval = 2
  var expectation: XCTestExpectation!
  let requestStub = FakeDataTaskMaker()
  
  override func setUp() {
    expectation = expectation(description: "Server responds in reasonable time")
  }

  func test_noServerResponse() {
    let url = URL(string: "doggone")!
    URLSession.shared.dataTask(with: url) { data, response, error in
      defer { self.expectation.fulfill() }
      
      XCTAssertNil(data)
      XCTAssertNil(response)
      XCTAssertNotNil(error)
    }
    .resume()
    
    waitForExpectations(timeout: timeout)
  }
  
  func test_client() {
    _ = DogPatchClient(baseURL: FakeDataTaskMaker.dummyUrl, session: requestStub).getDogs { dogs, error in
      defer { self.expectation.fulfill() }
      sleep(1)
      
      XCTAssertEqual(dogs?.count, 4)
      XCTAssertNil(error)
    }
    waitForExpectations(timeout: 1)
  }
  
  func test_decodeDogs() {
    let url = URL(string: "https://dogpatchserver.herokuapp.com/api/v1/dogs")!
    _ = requestStub.dataTask(with: url) { data, response, error in
      defer { self.expectation.fulfill() }
      sleep(1)
      XCTAssertNil(error)
      
      do {
        let response = try XCTUnwrap(response as? HTTPURLResponse)
        XCTAssertEqual(response.statusCode, 200)
        
        let data = try XCTUnwrap(data)
        XCTAssertNoThrow(try JSONDecoder().decode([Dog].self, from: data))
      } catch {
        XCTFail()
      }
    }
    
    waitForExpectations(timeout: timeout)
  }
  
  func test_orthopedicDogtor() {
    _ = requestStub.dataTask(with: URL(string: "https://dogpatchserver")!) { data, response, error in
      defer { self.expectation.fulfill() }
      sleep(1)

      do {
        XCTAssertEqual((response as? HTTPURLResponse)?.statusCode, 200)
        let data = try XCTUnwrap(data)
        _ = try JSONDecoder().decode([OrthopedicDogtor].self, from: data)
      } catch {
        switch error {
        case DecodingError.keyNotFound(let keys, _) where keys.stringValue == "bone":
          break
        default:
          XCTFail("\(error)")
        }
      }
    }
    
    waitForExpectations(timeout: timeout)
  }
}
