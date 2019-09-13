//
//  QuizTests.swift
//  QuizTests
//
//  Created by Eduardo Façanha on 09/09/19.
//  Copyright © 2019 Facanha. All rights reserved.
//

import XCTest
@testable import Quiz

class QuizTests: XCTestCase {
  
  let quizNumber = 1
  var viewModel: QuizViewModel!
  var quiz: Quiz?

    override func setUp() {
      viewModel = QuizViewModel.init(id: quizNumber, delegate: nil)
    }

    override func tearDown() {
      viewModel = nil
    }
  
  func testWon() {
    let completedExpectation = expectation(description: "completed")
    completedExpectation.isInverted = true
    let dataManager = DataManager.init(delegate: self)
    dataManager.requestQuiz(id: quizNumber)
    waitForExpectations(timeout: 5, handler: nil)
    viewModel.play()
    if let answers = quiz?.answers {
      answers.forEach({ (answer) in
        let _ = self.viewModel.verify(answer: answer)
      })
      completedExpectation.fulfill()
    }
    XCTAssertEqual(quiz!.answers.count, viewModel.numberOfRows, "Should be equal")
  }
}

extension QuizTests: ResponseHandler {
  func didReceive(quiz: Quiz) {
    self.quiz = quiz
  }
}
