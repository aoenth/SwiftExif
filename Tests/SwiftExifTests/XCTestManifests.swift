#if !canImport(ObjectiveC)
import XCTest

extension SwiftExifTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__SwiftExifTests = [
        ("test", test),
        ("testExifReadExifData", testExifReadExifData),
        ("testExifReadIfd", testExifReadIfd),
        ("testImageReadData", testImageReadData),
        ("testIptcReadIptcData", testIptcReadIptcData),
    ]
}

public func __allTests() -> [XCTestCaseEntry] {
    return [
        testCase(SwiftExifTests.__allTests__SwiftExifTests),
    ]
}
#endif