//
//  TabBarController.swift
//  recipeApp
//
//  Created by Maggie Williams on 11/7/19.
//  Copyright © 2019 CMU. All rights reserved.
//

import UIKit
import Foundation

class TabBarController:  UITabBarController, UITabBarControllerDelegate {
  
  var homeViewController: HomeViewController!
  var profileViewController: ProfileViewController!
  var discoverViewController: DiscoverViewController!

  
  override func viewDidLoad(){
    super.viewDidLoad()
    self.delegate = self
    
    homeViewController = HomeViewController()
    profileViewController = ProfileViewController()
    discoverViewController = DiscoverViewController()


  
  }
  
//  //MARK: UITabbar Delegate
//  func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
//    if viewController.isKind(of: ActionViewController.self) {
//      let vc =  ActionViewController()
//      vc.modalPresentationStyle = .overFullScreen
//      self.present(vc, animated: true, completion: nil)
//      return false
//    }
//    return true
//  }
  
}
