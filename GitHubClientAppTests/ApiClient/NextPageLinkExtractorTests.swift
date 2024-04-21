import XCTest
@testable import GitHubClientApp

class NextPageLinkExtractorTests: XCTestCase {
    func testExtractNextPageLink() {
        let headers = [
            "link": "<https://api.github.com/users?per_page=2&since=2>; rel=\"next\", <https://api.github.com/users{?since}>; rel=\"first\""
        ]
        
        XCTAssertEqual(NextPageLinkExtractor.getNextPageLink(from: headers), "https://api.github.com/users?per_page=2&since=2")
        
    }
    
    func testNotExtractOtherLink() {
        let headers = [
            "link": "<https://api.github.com/users{?since}>; rel=\"first\""
        ]
       
        XCTAssertNil(NextPageLinkExtractor.getNextPageLink(from: headers))
    }
    
    func testEmptyHeaders() {
        XCTAssertNil(NextPageLinkExtractor.getNextPageLink(from: [:]))
    }
}
