//
//  NetworkManager.swift
//  SpringRestaurantIOSApp
//
//  Created by Praveen on 2025-04-02.
//

import Foundation

struct NetworkErrorData: Error {
    let error: Error
    let data: Data?
}

protocol NetworkManagerProtocol {
    func request(
        request: HTTPRequestProtocol
    ) async -> Result<Data, NetworkErrorData>
}

struct NetworkManager: NetworkManagerProtocol {
    
    func request(request: HTTPRequestProtocol) async -> Result<Data, NetworkErrorData> {
        do {
            let (data, response) = try await URLSession.shared.data(for: request.urlRequest())
            
            guard let httpResponse = response as? HTTPURLResponse else {
                return .failure(NetworkErrorData(error: NetworkError.noResponse, data: nil))
            }
            
            let statusCode = httpResponse.statusCode
            if statusCode < 200 || statusCode >= 300 {
                return .failure(NetworkErrorData(error: NetworkError.httpError(statusCode), data: data))
            }
        
            return .success(data)
        } catch {
            return .failure(NetworkErrorData(error: error, data: nil))
        }
    }
}

private extension HTTPRequestProtocol {
    func urlRequest() throws -> URLRequest {
        let path = endPoint.resolvedPath()
        guard let url = URL(string: baseURL + path),
              var components = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
            throw InvalidRequestError.invalidURL
        }
        
        if let queryItems = queryItems() {
            components.queryItems = queryItems
        }
        
        guard let finalUrl = components.url else {
            throw InvalidRequestError.invalidQueryComponents
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
    case invalidURL
    case noResponse
    case httpError(Int)
}

public enum InvalidRequestError: Error {
    case invalidURL
    case invalidQueryComponents
}

protocol HTTPEndPointProtocol {
    var restEndPoint: String { get }
    var pathParameters: [String: String]? { get }
    func resolvedPath() -> String
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
