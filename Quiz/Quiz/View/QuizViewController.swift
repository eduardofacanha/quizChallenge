//
//  ViewController.swift
//  Quiz
//
//  Created by Eduardo Façanha on 09/09/19.
//  Copyright © 2019 Facanha. All rights reserved.
//

import UIKit

class QuizViewController: UIViewController {
  
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var textField: UITextField!
  @IBOutlet weak var scoreLabel: UILabel!
  @IBOutlet weak var timerLabel: UILabel!
  @IBOutlet weak var playButton: PlayButton!
  private var alertController: UIAlertController?
  private var viewModel: QuizViewModel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    viewModel = QuizViewModel.init(id: 1, delegate: self)
    for navItem in (self.navigationController?.navigationBar.subviews)! {
      for itemSubView in navItem.subviews {
        if let largeLabel = itemSubView as? UILabel {
          largeLabel.text = self.title
          largeLabel.numberOfLines = 0
          largeLabel.lineBreakMode = .byWordWrapping
        }
      }
    }
    textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    tableView.tableFooterView = UIView()
  }
  
  @objc private func textFieldDidChange(textField: UITextField) {
    if let text = textField.text {
      if viewModel.verify(answer: text) {
        textField.text = ""
      }
    }
  }
  
  @IBAction private func playButton(_ button: PlayButton) {
    viewModel.play()
  }
}

extension QuizViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel.numberOfRows
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: AnswerCell.identifier, for: indexPath) as! AnswerCell
    cell.answer = viewModel.answer(at: indexPath.row)
    return cell
  }
}

extension QuizViewController: QuizViewModelDelegate {
  func showLoading(title: String?, message: String?, indicatorPositionX: Double, indicatorPositionY: Double, indicatorSize: Double) {
    alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: indicatorPositionX,
                                                                 y: indicatorPositionY,
                                                                 width: indicatorSize,
                                                                 height: indicatorSize))
    loadingIndicator.hidesWhenStopped = true
    loadingIndicator.style = UIActivityIndicatorView.Style.gray
    loadingIndicator.startAnimating();
    
    alertController!.view.addSubview(loadingIndicator)
    navigationController?.present(alertController!, animated: true, completion: nil)
  }
  
  func reloadTableView() {
    tableView.reloadData()
  }
  
  func addAnswer(indexPath: IndexPath) {
    tableView.insertRows(at: [indexPath], with: .automatic)
  }
  
  func hideLoading() {
    alertController?.dismiss(animated: true, completion: {self.alertController = nil})
  }
  
  func showEndGame(title: String?, message: String?, action: String?, completion: @escaping () -> ()) {
    alertController = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
    let action = UIAlertAction.init(title: action, style: .default) { (action) in
      completion()
    }
    alertController?.addAction(action)
    navigationController?.present(alertController!, animated: true, completion: nil)
  }
  
  func update(timer: String) {
    DispatchQueue.main.async {
      self.timerLabel.text = timer
    }
  }
  
  func update(score: String) {
    DispatchQueue.main.async {
      self.scoreLabel.text = score
    }
  }
  
  func update(playState: PlayState) {
    playButton.playState = playState
    textField.isEnabled = playState == .start ? false : true
  }
  
  func update(title: String) {
    DispatchQueue.main.async {
      self.title = title
    }
  }
}
