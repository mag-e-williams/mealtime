//
//  Cancellable .swift
//  recipeApp
//
//  Created by Maggie Williams on 12/4/19.
//  Copyright © 2019 CMU. All rights reserved.
//

import Foundation

protocol Cancellable {

  func cancel()

}

extension URLSessionTask: Cancellable {}
