//
//  HTTPClient.swift
//
//  Created by Matthew Carroll on 8/29/16.
//  Copyright © 2016 Third Cup lc. All rights reserved.
//


import Foundation


extension URLRequest {
    
    init<A>(resource: Resource<A>, headers: HTTPHeader?) {
        self.init(url: resource.url)
        httpMethod = resource.method.method
        allHTTPHeaderFields = headers
        switch resource.method {
        case .get, .delete: break
        case .put(let body): httpBody = body
        case .post(let body): httpBody = body
        }
    }
}


final class HTTPClient {
    
    private let urlSession: URLSession = {
        let configuration = URLSessionConfiguration.default
        configuration.httpShouldUsePipelining = true
        configuration.urlCache = URLCache(memoryCapacity: 4 * 1024 * 1024, diskCapacity: 20 * 1024 * 1024, diskPath: nil)
        return URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue())
    }()

    func load<A>(resource: Resource<A>, completion: @escaping (A?) -> ()) {
        let headers = ["X-Parse-Application-Id": "appid", "Content-Type": "application/json"].addingEntries(from: resource.httpHeaders ?? [:])
        let request = URLRequest(resource: resource, headers: headers)
        urlSession.dataTask(with: request) { data, response, urlError in
            completion(data.flatMap(resource.parse))
            }.resume()
    }
}
