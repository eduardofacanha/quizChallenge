//
//  PlayButton.swift
//  Quiz
//
//  Created by Eduardo Façanha on 11/09/19.
//  Copyright © 2019 Facanha. All rights reserved.
//

import Foundation
import UIKit

class PlayButton: UIButton {
  private let radius: CGFloat = 10
  var playState: PlayState = .start {
    didSet {
      updateButton()
    }
  }
  override func layoutSubviews() {
    layer.cornerRadius = radius
    clipsToBounds = true
    updateButton()
    super.layoutSubviews()
  }
  
  private func updateButton() {
    if playState == .start {
      setTitle(NSLocalizedString("START", comment: ""), for: .normal)
    } else {
      setTitle(NSLocalizedString("RESET", comment: ""), for: .normal)
    }
  }
}
