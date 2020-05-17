import XCTest
@testable import DotEnvVapor

final class DotEnvVaporTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(DotEnvVapor().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
