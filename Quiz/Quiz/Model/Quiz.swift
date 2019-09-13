//
//  Quiz.swift
//  Quiz
//
//  Created by Eduardo Façanha on 10/09/19.
//  Copyright © 2019 Facanha. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class Quiz: NSManagedObject, Decodable {
  @NSManaged var question: String
  @NSManaged var answers: [String]
  
  enum CodingKeys: String, CodingKey {
    case question
    case answer
  }
  
  required convenience init(from decoder: Decoder) throws {
    guard let contextUserInfoKey = CodingUserInfoKey.context,
      let managedObjectContext = decoder.userInfo[contextUserInfoKey] as? NSManagedObjectContext,
      let entity = NSEntityDescription.entity(forEntityName: "Quiz",
                                              in: managedObjectContext) else { fatalError() }
    self.init(entity: entity, insertInto: managedObjectContext)
    let container = try decoder.container(keyedBy: CodingKeys.self)
    question = try container.decode(String.self, forKey: .question)
    answers = try container.decode([String].self, forKey: .answer)
  }
}

extension Quiz {
  private static func createQuiz(data: Data,
                                 context: NSManagedObjectContext,
                                 completion: @escaping ((Quiz?) -> ())) {
    var quiz: Quiz?
    let decoder = JSONDecoder()
    decoder.userInfo[CodingUserInfoKey.context!] = context
    do {
      quiz = try decoder.decode(Quiz.self, from: data)
    } catch {}
    completion(quiz)
  }
  /**
   Fetch the quiz on coreData with the value from server
   
   - Parameter data: The data to be converted in Quiz.
   - Parameter completion: The the closure given the quiz object.
   */
  static func fetchQuiz(data: Data, completion: @escaping ((Quiz?) -> ())) {
    let context = CoreDataStack.shared.context
    let all = getAllQuizzes()
    var quiz: Quiz?
    createQuiz(data: data, context: context) { (newQuiz) in
      if let newQuiz = newQuiz {
        let question = newQuiz.question
        var existentQuiz: Quiz?
        all?.forEach({ (quiz) in
          if quiz.question == question {
            existentQuiz = quiz
          }
        })
        if let existentQuiz = existentQuiz {
          existentQuiz.answers = newQuiz.answers
          context.delete(newQuiz)
          quiz = existentQuiz
        } else {
          quiz = newQuiz
        }
        do {
          try context.save()
        } catch {}
      }
      completion(quiz)
    }
  }
  
  /**
   Get all quizzes from coreData
   
   - Parameter data: The data to be converted in Quiz.
   - Returns all quizzes founded.
   */
  static func getAllQuizzes() -> [Quiz]? {
    let context = CoreDataStack.shared.context
    let fetchRequest = NSFetchRequest<Quiz>.init(entityName: "Quiz")
    fetchRequest.returnsObjectsAsFaults = false
    do {
      return try context.fetch(fetchRequest)
    } catch {
      return nil
    }
  }
}
