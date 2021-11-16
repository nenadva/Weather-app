//
//  RemoteResource.swift
//
//  Created by Matthew Carroll on 8/29/16.
//  Copyright © 2016 Third Cup lc. All rights reserved.
//

import Foundation


typealias JSONDictionary = [String: AnyObject]
typealias HTTPHeader = [String: String]


enum HttpMethod<Body> {
    
    case delete
    case get
    case post(Body)
    case put(Body)
}

extension HttpMethod {
    
    var method: String {
        switch self {
        case .delete: return "DELETE"
        case .get: return "GET"
        case .post: return "POST"
        case .put: return "PUT"
        }
    }
    
    func map<B>(f: (Body) -> B) -> HttpMethod<B> {
        switch self {
        case .delete: return .delete
        case .get: return .get
        case .post(let body):
            return .post(f(body))
        case .put(let body):
            return .put(f(body))
        }
    }
}


struct Resource<A> {
    
    let url: URL
    let method: HttpMethod<Data>
    let parse: (Data) -> A?
    let httpHeaders: HTTPHeader?
}

enum ResourceError: Error {
    
    case nsurlError
    case httpError(String)
    
    var message: String? {
        guard case .httpError(let message) = self else { return nil }
        return message
    }
}

extension Resource {
    
    init(url: URL, method: HttpMethod<Any> = .get, headers: HTTPHeader? = nil, parseJSON: @escaping (Any) -> A?) {
        self.url = url
        self.method = method.map { json in
            try! JSONSerialization.data(withJSONObject: json, options: [])
        }
        self.parse = { data in
            let json = try? JSONSerialization.jsonObject(with: data, options: [])
            return json.flatMap(parseJSON)
        }
        self.httpHeaders = headers
    }
}
