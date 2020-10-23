import XCTest
@testable import CocoaHeadsSampleApp

final class CocoaHeadsSampleAppTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(CocoaHeadsSampleApp().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
