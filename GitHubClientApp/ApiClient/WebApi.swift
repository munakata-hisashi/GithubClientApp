import Foundation

enum WebApi {
    static func call(with input: Request) async throws -> Response {
        let urlRequest = createURLRequest(by: input)
        do {
           
            let (data, response) = try await URLSession.shared.data(for: urlRequest)
            let output = try createOutput(data: data, urlResponse: response as? HTTPURLResponse)
            return output
        } catch {
            throw ConnectionError.noDataOrNoResponse(debugInfo: error.localizedDescription)
        }
    }
    
    static private func createURLRequest(by input: Request) -> URLRequest {
        var request = URLRequest(url: input.url)
        
        request.httpMethod = input.methodAndPayload.method
        
        request.httpBody = input.methodAndPayload.body
        
        request.allHTTPHeaderFields = input.headers
        
        return request
    }
    
    static private func createOutput(data: Data, urlResponse: HTTPURLResponse?) throws -> Response {
        guard let urlResponse else { throw ConnectionError.noDataOrNoResponse(debugInfo: "no response")}
        var headers: [String: String] = [:]
        for (key, value) in urlResponse.allHeaderFields.enumerated() {
            headers[key.description] = String(describing: value)
        }
        return Response(statusCode: .from(code: urlResponse.statusCode), headers: headers, payload: data)
    }
}




