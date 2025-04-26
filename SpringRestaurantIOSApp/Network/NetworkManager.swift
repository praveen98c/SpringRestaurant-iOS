//
//  NetworkManager.swift
//  SpringRestaurantIOSApp
//
//  Created by Praveen on 2025-04-02.
//

import Foundation

struct NetworkErrorData: Error {
    let error: NetworkError
    let data: Data?
    
    init(error: NetworkError, data: Data? = nil) {
        self.error = error
        self.data = data
    }
}

protocol NetworkManagerProtocol {
    func request(
        request: HTTPRequestProtocol
    ) async -> Result<Data, NetworkErrorData>
    
    func request(url: URL) async -> Result<Data, NetworkErrorData>
}

struct NetworkManager: NetworkManagerProtocol {
    
    func request(request: HTTPRequestProtocol) async -> Result<Data, NetworkErrorData> {
        let urlRequest: URLRequest
        do {
            urlRequest = try request.urlRequest()
        } catch {
            return .failure(NetworkErrorData(error: error, data: nil))
        }
        
        return await self.request(request: urlRequest)
    }
    
    func request(url: URL) async -> Result<Data, NetworkErrorData> {
        let urlRequest = URLRequest(url: url)
        return await request(request: urlRequest)
    }
    
    private func request(request: URLRequest) async -> Result<Data, NetworkErrorData> {
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkErrorData(error: NetworkError.noResponse, data: nil)
            }
            
            let statusCode = httpResponse.statusCode
            if statusCode < 200 || statusCode >= 300 {
                throw NetworkErrorData(error: NetworkError.httpError(statusCode), data: data)
            }
            
            return .success(data)
        } catch {
            let networkError: NetworkError
            var networkData: Data? = nil
            switch error {
            case let error as NetworkError:
                networkError = error
            case let error as URLError:
                networkError = error.toNetworkError()
            case let error as NetworkErrorData:
                networkError = error.error
                networkData = error.data
            default:
                networkError = .unknown(error)
            }
            return .failure(NetworkErrorData(error: networkError, data: networkData))
        }
    }
}

private extension HTTPRequestProtocol {
    func urlRequest() throws(NetworkError) -> URLRequest {
        let path = endPoint.resolvedPath()
        guard let url = URL(string: baseURL + path),
              var components = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
            throw NetworkError.invalidURL
        }
        
        if let queryItems = queryItems() {
            components.queryItems = queryItems
        }
        
        guard let finalUrl = components.url else {
            throw NetworkError.invalidQueryComponents
        }
        
        var req = URLRequest(url: finalUrl)
        req.httpMethod = method.rawValue
        req.allHTTPHeaderFields = combinedHeaders()
        req.httpBody = bodyType?.body
        return req
    }
}

enum BodyType: HTTPBodyTypeProtocol {
    
    case json([String: Any])
    
    var header: [String: String] {
        switch self {
        case .json:
            return ["Content-Type": "application/json"]
        }
    }
    
    var body: Data? {
        switch self {
        case .json(let dictionary):
            return try? JSONSerialization.data(withJSONObject: dictionary)
        }
    }
}

protocol HTTPRequestProtocol {
    var baseURL: String { get }
    var endPoint: HTTPEndPointProtocol { get }
    var method: HTTPMethod { get }
    var headers: [String: String]? { get }
    var queryParameters: [String: [Any]]? { get }
    var bodyType: BodyType? { get }
}

protocol HTTPBodyTypeProtocol {
    var header: [String: String] { get }
    var body: Data? { get }
}

enum HTTPMethod: String {
    case GET, POST, PUT, DELETE, PATCH
}

enum NetworkError: Error {
    case noResponse
    case httpError(Int)
    case invalidURL
    case invalidQueryComponents
    // URL Errors
    case notConnectedToInternet
    case timedOut
    case badServerResponse
    // General
    case unknown(Error)
}

protocol HTTPEndPointProtocol {
    var restEndPoint: String { get }
    var pathParameters: [String: String]? { get }
}

struct HTTPEndPoint: HTTPEndPointProtocol {
    let restEndPoint: String
    let pathParameters: [String : String]?
    
    init(restEndPoint: String, pathParameters: [String : String]? = nil) {
        self.restEndPoint = restEndPoint
        self.pathParameters = pathParameters
    }
}

extension HTTPEndPointProtocol {
    
    func resolvedPath() -> String {
        guard let pathParameters = pathParameters else {
            return restEndPoint
        }
        
        var resolved = restEndPoint
        for (key, value) in pathParameters {
            resolved = resolved.replacingOccurrences(of: "{\(key)}", with: value.description)
        }
        
        return resolved
    }
}

extension HTTPRequestProtocol {
    
    func queryItems() -> [URLQueryItem]? {
        queryParameters?.flatMap { key, values in
            values.map { URLQueryItem(name: key, value: "\($0)") }
        }
    }
    
    func combinedHeaders() -> [String: String] {
        var headers: [String: String] = headers ?? [:]
        
        if let header = bodyType?.header {
            headers.merge(header) { (_, new) in new }
        }
        
        return headers
    }
}

extension URLError {
    
    func toNetworkError() -> NetworkError {
        switch self.code {
        case .notConnectedToInternet:
            return .notConnectedToInternet
        case .timedOut:
            return .timedOut
        case .badServerResponse:
            return .badServerResponse
        default:
            return .unknown(self)
        }
    }
}
