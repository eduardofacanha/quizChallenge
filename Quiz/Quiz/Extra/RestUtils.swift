//
//  RestUtils.swift
//  Quiz
//
//  Created by Eduardo Façanha on 10/09/19.
//  Copyright © 2019 Facanha. All rights reserved.
//

import Foundation

enum HttpProtocol: String {
  case http
  case https
}

enum HttpMethod: String {
  case get = "GET"
  case post = "POST"
  case put = "PUT"
}

class RestUtils: NSObject {
  
  /**
   Execute a http request using the given url
   
   - Parameter url: The http url of the request.
   - Parameter httpMethod: The httpMethod wich should be used.
   - Parameter completion: The closure with the result in data, response and error
   */
  static func request(url: URL,
                      httpMethod: HttpMethod,
                      completion: @escaping (_ data: Data?,_ response: URLResponse?,_ error: Error?) -> ()) {
    var request = URLRequest.init(url: url)
    request.httpMethod = httpMethod.rawValue
    let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
      completion(data, response, error)
    }
    task.resume()
  }
}
