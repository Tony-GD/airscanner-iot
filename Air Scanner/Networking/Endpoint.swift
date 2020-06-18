//
//  Endpoint.swift
//  Air Scanner
//
//  Created by Alexandr Gaidukov on 17.06.2020.
//  Copyright © 2020 Grid dynamics. All rights reserved.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

enum EndpointError: Error {
    case noInternetConnection
    case other
}

extension EndpointError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .noInternetConnection:
            return "Internet connection has been lost."
        default:
            return "Something went wrong. Please try again later"
        }
    }
}

final class Endpoint<A: Decodable>: ObservableObject {
    
    private lazy var encoder: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        return encoder
    }()
    
    private lazy var decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
    
    @Published var result: Result<A, EndpointError>?
    private var dataTask: URLSessionDataTask?
    
    private let baseURL: URL
    private let path: String
    private let method: HTTPMethod
    
    init(baseURL: URL, path: String, method: HTTPMethod) {
        self.baseURL = baseURL
        self.path = path
        self.method = method
    }
    
    func load<B: Encodable>(params: B?) {
        dataTask?.cancel()
        let url = baseURL.appendingPathComponent(path)
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(LocalStorage.shared.user?.idToken ?? "")", forHTTPHeaderField: "Authorization")
        
        if let params = params {
            switch method {
            case .post, .put:
                request.httpBody = try? encoder.encode(params)
            default:
                break
            }
        }
        
        dataTask = URLSession.shared.dataTask(with: request) {[weak self] data, response, error in
            guard error == nil else {
                switch (error as? URLError)?.code {
                case .cancelled?:
                    break
                case .notConnectedToInternet?, .networkConnectionLost?:
                    self?.update(with: .failure(.noInternetConnection))
                default:
                    self?.update(with: .failure(.other))
                }
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                self?.update(with: .failure(.other))
                return
            }
            
            if (200..<300) ~= httpResponse.statusCode {
                if let value = data.flatMap({ try? self?.decoder.decode(A.self, from: $0) }) {
                    self?.update(with: .success(value))
                } else {
                    self?.update(with: .failure(.other))
                }
            } else {
                self?.update(with: .failure(.other))
            }
        }
        dataTask?.resume()
    }
    
    private func update(with result: Result<A, EndpointError>) {
        DispatchQueue.main.async {
            self.result = result
        }
    }
}

//extension URLRequest {
//    init<A>(resource: Resource<A>) {
//        let url = URL(resource: resource)
//        self.init(url: url)
//        httpMethod = resource.method.rawValue
//        resource.headers.merging(["Accept": "application/json", "Content-Type": resource.contentType], uniquingKeysWith: { $1 }).forEach{
//            setValue($0.value, forHTTPHeaderField: $0.key)
//        }
//        switch resource.method {
//        case .post, .put, .patch:
//            httpBody = resource.body
//        default:
//            break
//        }
//    }
//}
