//
//  AnswerCell.swift
//  Quiz
//
//  Created by Eduardo Façanha on 11/09/19.
//  Copyright © 2019 Facanha. All rights reserved.
//

import Foundation
import UIKit

class AnswerCell: UITableViewCell {
  static let identifier = "AnswerCell"
  var answer: String? {
    didSet {
      textLabel?.text = answer
    }
  }
}
