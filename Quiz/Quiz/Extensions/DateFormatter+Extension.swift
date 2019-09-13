//
//  DateFormatter+Extension.swift
//  Quiz
//
//  Created by Eduardo Façanha on 11/09/19.
//  Copyright © 2019 Facanha. All rights reserved.
//

import Foundation

extension DateFormatter {
  enum DateFormat: Int, CaseIterable {
    case minutes
    case seconds
    
    func string() -> String {
      switch self {
      case .minutes: return "mm"
      case .seconds: return "ss"
      }
    }
  }
  
  convenience init(format: [DateFormat]) {
    self.init()
    format.sorted{$0.rawValue < $1.rawValue}.forEach({dateFormat.append("\($0.string()):")})
    dateFormat = String(dateFormat.dropLast())
  }
}
