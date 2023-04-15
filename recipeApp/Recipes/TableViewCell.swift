//
//  TableViewCell.swift
//  mealtime
//
//  Created by Maggie Williams on 11/6/19.
//  Copyright © 2019 CMU. All rights reserved.
//


import UIKit

class TableViewCell: UITableViewCell {
  
  @IBOutlet weak var title: UILabel!

  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    accessoryType = selected ? .checkmark : .none
    selectionStyle = .none
  }
  
  func getIndexPath() -> IndexPath? {
      guard let superView = self.superview as? UITableView else {
          print("superview is not a UITableView - getIndexPath")
          return nil
      }
      let i = superView.indexPath(for: self)
      return i
  }
  
}

extension UIResponder {
    /**
     * Returns the next responder in the responder chain cast to the given type, or
     * if nil, recurses the chain until the next responder is nil or castable.
     */
    func next<U: UIResponder>(of type: U.Type = U.self) -> U? {
        return self.next.flatMap({ $0 as? U ?? $0.next() })
    }
}

extension UITableViewCell {
    var tableView: UITableView? {
        return self.next(of: UITableView.self)
    }

    var indexPath: IndexPath? {
        return self.tableView?.indexPath(for: self)
    }
}
