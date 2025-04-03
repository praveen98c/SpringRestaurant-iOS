//
//  NetworkManager.swift
//  SpringRestaurantIOSApp
//
//  Created by Praveen on 2025-04-02.
//

import Foundation

protocol NetworkManagerProtocol {
    func request(
        request: HTTPRequestProtocol
    ) async throws -> Data
}

struct NetworkManager: NetworkManagerProtocol {
    func request(request: HTTPRequestProtocol) async throws -> Data {
        let (data, response) = try await URLSession.shared.data(for: request.urlRequest())
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.noResponse
        }
        
        let statusCode = httpResponse.statusCode
        if statusCode < 200 || statusCode >= 300 {
            throw NetworkError.httpError(statusCode)
        }
        
        return data
    }
}

private extension HTTPRequestProtocol {
    func urlRequest() throws -> URLRequest {
        guard let url = URL(string: baseURL + endPoint.restEndPoint),
              var components = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
            throw InvalidRequestError.invalidURL
        }
        
        if let queryParameters = queryParameters {
            var queryItems: [URLQueryItem] = []
            for (key, value) in queryParameters {
                for v in value {
                    queryItems.append(URLQueryItem(name: key, value: "\(v)"))
                }
            }
            
            components.queryItems = queryItems
        }
        
        var headers: [String: String]? = headers
        
        if let bodyType = bodyType {
            headers = headers ?? [:]
            headers?[bodyType.header.key] = bodyType.header.value
        }
        
        guard let finalUrl = components.url else {
            throw InvalidRequestError.invalidQueryComponents
        }
        
        var req = URLRequest(url: finalUrl)
        req.httpMethod = method.rawValue
        
        if let headers = headers {
            req.allHTTPHeaderFields = headers
        }
        
        if let body = bodyType?.body {
            req.httpBody = body
        }
        return req
    }
}

enum BodyType: HTTPBodyTypeProtocol {
    
    case json([String: Any])
    
    var header: (key: String, value: String) {
        switch self {
        case .json:
            return (key: "Content-Type", value: "application/json")
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
    var header: (key: String, value: String) { get }
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
}
