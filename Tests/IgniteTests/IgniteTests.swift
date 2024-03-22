import XCTest
@testable import Ignite


/// A base class that sets up an example publishing context for testing purposes.
class ElementTest: XCTestCase {
    /// A publishing context with sample values.
    let publishingContext = try! PublishingContext(for: TestSite(), rootURL: URL.documentsDirectory)
}
