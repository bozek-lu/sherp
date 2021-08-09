//
//  HTTPClient.swift
//  sherp
//
//  Created by Łukasz Bożek on 02/08/2021.
//

import Foundation
import Combine

public typealias HTTPResponse = (data: Data, response: URLResponse)

public enum HTTPMethod: String {
    case get
    case post
    case put
    case delete
    case head
}

enum RequestError: Error {
    case fetchingFailed
}

protocol HTTPClientProtocol {
    func httpTask(with request: URLRequestConvertible) -> AnyPublisher<HTTPResponse, Error>
}

/// Types adopting the `URLRequestConvertible` protocol can be used to safely construct `URLRequest`s.
protocol URLRequestConvertible {
    func asURLRequest() -> URLRequest
}

final class HTTPClient: HTTPClientProtocol {
    private let session: URLSession
    
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    func httpTask(with request: URLRequestConvertible) -> AnyPublisher<HTTPResponse, Error> {
        session.dataTaskPublisher(for: request.asURLRequest())
            .map { HTTPResponse($0.data, $0.response) }
            .mapError { error -> RequestError in
                RequestError.fetchingFailed
            }
            .eraseToAnyPublisher()
    }
}
