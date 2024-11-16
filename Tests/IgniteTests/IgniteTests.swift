import XCTest
@testable import Ignite

// swiftlint:disable force_try
/// A base class that sets up an example publishing context for testing purposes.
class ElementTest: XCTestCase {

    /// A publishing context with sample values for root site tests.
    let publishingContext = try! PublishingContext(for: TestSite(),
                                                   from: URL.documentsDirectory)
    /// A publishing context with sample values for subsite tests.
    let publishingSubsiteContext = try! PublishingContext(for: TestSubsite(),
                                                          from: URL.documentsDirectory)
}
// swiftlint:enable force_try
