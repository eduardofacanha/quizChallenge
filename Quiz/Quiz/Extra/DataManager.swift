//
//  DataManager.swift
//  Quiz
//
//  Created by Eduardo Façanha on 12/09/19.
//  Copyright © 2019 Facanha. All rights reserved.
//

import Foundation

protocol ResponseHandler {
  func didReceive(quiz: Quiz)
}

class DataManager {
  private var delegate: ResponseHandler
  
  init(delegate: ResponseHandler){
    self.delegate = delegate
  }

  /**
   It request a quiz from server and return the value using the ResponseHandler protocol
   
   - Parameter id: The id of the quiz.
   */
  public func requestQuiz(id: Int) {
    var urlComponents = URLComponents()
    urlComponents.scheme = HttpProtocol.https.rawValue
    urlComponents.host = Constants.host
    urlComponents.path = Constants.quizPath.appending("/\(id)")
    if let url = urlComponents.url {
      RestUtils.request(url: url, httpMethod: .get) { (data, response, error) in
        if let data = data {
          Quiz.fetchQuiz(data: data, completion: { (quiz) in
            if let quiz = quiz {
              self.delegate.didReceive(quiz: quiz)
            }
          })
        }
      }
    }
  }
}
