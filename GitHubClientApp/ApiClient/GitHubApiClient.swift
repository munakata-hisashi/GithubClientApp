import Foundation

protocol GitHubApiClient {
    /// - throws: ConnectionError
    func call(with input: Request) async throws -> Response
}

struct GitHubApiClientImpl: GitHubApiClient {
    func call(with input: Request) async throws -> Response {
        do {
            let urlRequest = try createURLRequest(by: input)
            let (data, response) = try await URLSession.shared.data(for: urlRequest)
            let output = try createOutput(data: data, urlResponse: response as? HTTPURLResponse)
            return output
        } catch {
            throw ConnectionError.noDataOrNoResponse(debugInfo: error.localizedDescription)
        }
    }
    
    private func createURLRequest(by input: Request) throws -> URLRequest {
        guard let token = Env["PERSONAL_ACCESS_TOKEN"] else {
            throw ConnectionError.notFoundToken
        }
        let url = input.url.appending(queryItems: input.queries)
        var request = URLRequest(url: url)
        
        request.httpMethod = input.methodAndPayload.method
        
        request.httpBody = input.methodAndPayload.body
        
        var headers = input.headers
        
        headers["Accept"] = "application/vnd.github+json"
        headers["Authorization"] = "Bearer \(token)"
        headers["X-GitHub-Api-Version"] = "2022-11-28"
        
        for (key, value) in headers {
            request.addValue(value, forHTTPHeaderField: key)
        }
        
        return request
    }
    
    /// GitHubのAPIはページングにlinkヘッダーを使うのでlinkヘッダーが含まれていたらResponse.headersに追加する
    private func createOutput(data: Data, urlResponse: HTTPURLResponse?) throws -> Response {
        guard let urlResponse else { throw ConnectionError.noDataOrNoResponse(debugInfo: "no response")}
        
        var headers: [String: String] = [:]
        if let linkValue = urlResponse.value(forHTTPHeaderField: "link") {
            headers["link"] = linkValue
        }

        return Response(statusCode: .from(code: urlResponse.statusCode), headers: headers, payload: data)
    }
}




