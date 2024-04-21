import Foundation

enum NextPageLinkExtractor {
    static func getNextPageLink(from headers: [String: String]) -> String? {
        guard let headerValue = headers["link"], headerValue.contains("rel=\"next\"") else {
            return nil
        }
        
        let links = headerValue
            .split(separator: ",")
            .filter { $0.contains("rel=\"next\"")}
        
        let pattern = /<([^>]*)>/
        
        guard let link = links.first, let match = link.firstMatch(of: pattern) else {
            return nil
        }
        
        return String(match.1)
    }
}
