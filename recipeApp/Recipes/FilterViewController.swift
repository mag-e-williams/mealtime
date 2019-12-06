//
//  FilterViewController.swift
//  recipeApp
//
//  Created by Maggie Williams on 12/6/19.
//  Copyright © 2019 CMU. All rights reserved.
//
import UIKit
import CoreData
import Foundation

class FilterViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
  
  @IBOutlet var filterTable: UITableView!
 
  @IBAction func closeButton(_ sender: UIBarButtonItem) {
    dismiss(animated: true, completion: nil)
  }
  
  let filterList =   ["African",
  "American",
  "British",
  "Cajun",
  "Caribbean",
  "Chinese",
  "Eastern European",
  "European",
  "French",
  "German",
  "Greek",
  "Indian",
  "Irish",
  "Italian",
  "Japanese",
  "Jewish",
  "Korean",
  "Latin American",
  "Mediterranean",
  "Mexican",
  "Middle Eastern",
  "Nordic",
  "Southern",
  "Spanish",
  "Thai",
  "Vietnamese"]
  
  @IBAction func doneButton(_ sender: UIBarButtonItem) {
    let filterTitlesArray = viewModel.selectedFilters.map { $0.title! }
    let stringRepresentation = filterTitlesArray.joined(separator:",")
    print("HERE******************************************************")
    print(stringRepresentation)
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let context = appDelegate.persistentContainer.viewContext
    let userViewModel = ProfileViewModel()
    let user = userViewModel.fetchUser("User")
    user?.setValue(stringRepresentation, forKey: "filters")
    do {
      try context.save()
    } catch {
      print("Failed saving")
    }
    
    dismiss(animated: true, completion: nil)
  }
  
  var filters = Filters().getFilters()
  let viewModel = FilterViewModel()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    filterTable?.allowsMultipleSelection = true
    
    let bundle = Bundle(for: type(of: self))
    let cellNib = UINib(nibName: "TableViewCell", bundle: bundle)
    self.filterTable.register(cellNib, forCellReuseIdentifier: "cell")
    
    viewModel.refresh()
    self.filterTable.reloadData()
    
    let userViewModel = ProfileViewModel()
    let user = userViewModel.fetchUser("User")
    
    let filterString = user!.value(forKey: "filters") as! String
    let filterTitles = filterString.split { $0 == "," }
    var filterObjArray = [Filter]()

    for title in filterTitles {
      var i = filterList.firstIndex(of: String(title))
      let indexPath = IndexPath(row: i!, section: 0)
      self.filterTable.selectRow(at: indexPath, animated: false, scrollPosition: .none)
        
    }
    
    
  }
  
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return (viewModel.numberOfRows()!)
  }
  
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
    cell.title?.text = viewModel.titleForRowAtIndexPath(indexPath)
    
    if filters[indexPath.row].isSelected! {
      if !cell.isSelected {
         tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
      }
    } else {
      if cell.isSelected {
        tableView.deselectRow(at: indexPath, animated: false)
      }
    }
    
    return cell
  }
   
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
  
   // update ViewModel item
    viewModel.filters[indexPath.row].isSelected = true
    viewModel.didToggleSelection?(!viewModel.selectedFilters.isEmpty)
  }
     
   func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
    // update ViewModel item
    viewModel.filters[indexPath.row].isSelected = false
    viewModel.didToggleSelection?(!viewModel.selectedFilters.isEmpty)
  }
     
   func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
      return indexPath
    }
  
}
