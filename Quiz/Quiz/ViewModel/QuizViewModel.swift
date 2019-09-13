//
//  QuizViewModel.swift
//  Quiz
//
//  Created by Eduardo Façanha on 11/09/19.
//  Copyright © 2019 Facanha. All rights reserved.
//

import Foundation

protocol QuizViewModelDelegate {
  func reloadTableView()
  func addAnswer(indexPath: IndexPath)
  func showLoading(title: String?,
                   message: String?,
                   indicatorPositionX: Double,
                   indicatorPositionY: Double,
                   indicatorSize: Double)
  func hideLoading()
  func showEndGame(title: String?,
                   message: String?,
                   action: String?,
                   completion: @escaping () -> ())
  func update(timer: String)
  func update(score: String)
  func update(playState: PlayState)
  func update(title: String)
}

enum PlayState {
  case start
  case reset
}

class QuizViewModel {
  
  public private(set) var currentState: PlayState = .start
  public var numberOfAnswers: Int {
    return quiz?.answers.count ?? 0
  }
  private let indicatorSize: Double = 50
  private let indicatorPositionX: Double = 10
  private let indicatorPositionY: Double = 5
  private let roundTime: Double = 18000
  private var timer: Timer!
  private var delegate: QuizViewModelDelegate?
  private var timerCount: Double = 0 {
    didSet{
      let dateFormatter = DateFormatter.init(format: [.minutes, .seconds])
      let timerPassed = dateFormatter.string(from: Date.init(timeIntervalSince1970: timerCount))
      delegate?.update(timer: timerPassed)
    }
  }
  private var quiz: Quiz? {
    didSet {
      self.updateScore()
      delegate?.update(title: self.title)
      delegate?.hideLoading()
    }
  }
  private var answersRemaining = [String]()
  private var answerscorrectly = [String]()
  private var score: Int {
    return answerscorrectly.count
  }
  private var title: String {
    return quiz?.question ?? ""
  }
  lazy var dataManager: DataManager = {
    let manager = DataManager(delegate: self)
    return manager
  }()
  
  init(id: Int, delegate: QuizViewModelDelegate?) {
    self.delegate = delegate
    delegate?.showLoading(title: nil,
                         message: NSLocalizedString("LOADING", comment: ""),
                         indicatorPositionX: indicatorPositionX,
                         indicatorPositionY: indicatorPositionY,
                         indicatorSize: indicatorSize)
    dataManager.requestQuiz(id: id)
  }
  
  /**
   Start or Reset the game
   */
  public func play() {
    if currentState == .start {
      if let quiz = quiz {
        answersRemaining = quiz.answers
        answerscorrectly = [String]()
        timer = Timer.scheduledTimer(timeInterval: 1,
                                     target: self,
                                     selector: #selector(timerCount(timer:)),
                                     userInfo: nil,
                                     repeats: true)
        currentState = .reset
      }
    } else {
      answerscorrectly = [String]()
      timer.invalidate()
      timerCount = 0
      currentState = .start
      updateScore()
      delegate?.reloadTableView()
    }
    delegate?.update(playState: currentState)
  }
  
  /**
   Verify if the answer given is correctly
   
   - Parameter answer: The answer wich should be verified if is correct.
   - Returns if is correct or not.
   */
  public func verify(answer: String) -> Bool {
    guard answersRemaining.contains(answer),
      let index = answersRemaining.firstIndex(where: {$0 == answer}) else { return false }
    let answer = answersRemaining[index]
//    answerscorrectly.append(answer)
    answerscorrectly.insert(answer, at: 0)
    answersRemaining.remove(at: index)
    insertAnswer(answer: answer)
    updateScore()
    if score == numberOfAnswers {
      won()
    }
    return true
  }
  
  private func getScore() -> String {
    return "\(self.answerscorrectly.count)/\(self.quiz?.answers.count ?? 0)"
  }
  
  private func updateScore() {
    delegate?.update(score: getScore())
  }
  
  private func insertAnswer(answer: String) {
    let indexPath = IndexPath.init(row: 0, section: 0)
    delegate?.addAnswer(indexPath: indexPath)
  }
  
  private func timeIsOver() {
    timer.invalidate()
    delegate?.showEndGame(title: NSLocalizedString("TIME_FINISHED",
                                                  comment: ""),
                         message: String(format: NSLocalizedString("TIME_FINISHED_DESCRIPTION",
                                                                   comment: ""),
                                         score,
                                         numberOfAnswers),
                         action: NSLocalizedString("TRY_AGAIN", comment: "")) {
                          self.play()
    }
  }
  
  private func won() {
    timer.invalidate()
    delegate?.showEndGame(title: NSLocalizedString("CONGRATULATIONS", comment: ""),
                         message: NSLocalizedString("CONGRATULATIONS_DESCRIPTION", comment: ""),
                         action: NSLocalizedString("PLAY_AGAIN", comment: "")) {
      self.play()
    }
  }

  @objc private func timerCount(timer: Timer) {
    timerCount += 1
    if timerCount == roundTime {
      timeIsOver()
    }
  }
}

extension QuizViewModel {
  public var numberOfRows: Int { return answerscorrectly.count }
  public func answer(at index: Int) -> String? {
    return answerscorrectly[index]
  }
}

extension QuizViewModel: ResponseHandler {
  func didReceive(quiz: Quiz) {
    self.quiz = quiz
  }
}
