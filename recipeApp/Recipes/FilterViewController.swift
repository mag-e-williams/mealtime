//
//  FilterViewController.swift
//  mealtime
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
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let context = appDelegate.persistentContainer.viewContext
    let userViewModel = ProfileViewModel()
    let user = userViewModel.fetchUser("User")
    
    let newString = ""
    
    user?.setValue(newString, forKey: "filters")
    do {
      try context.save()
    } catch {
      print("Failed saving")
    }
    
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
    print("filter array")
    print(filterTitlesArray)
    let stringRepresentation = filterTitlesArray.joined(separator:",")
    print("HERE******************************************************")
    print(stringRepresentation)
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let context = appDelegate.persistentContainer.viewContext
    let userViewModel = ProfileViewModel()
    let user = userViewModel.fetchUser("User")
    
//    print("string Representation")
//    print(stringRepresentation)
    
    let prevfilterString : String
    if user!.value(forKey: "filters") == nil {
        prevfilterString = ""
    }
    else{
        prevfilterString = user!.value(forKey: "filters") as! String
    }
    
    var newString = ""
    if stringRepresentation != "" {
        newString = prevfilterString + "," + stringRepresentation
    }
    else {
        newString = prevfilterString
    }
    
    if newString.count != 0 {
        if newString[newString.index(newString.startIndex, offsetBy: 0)] == "," {
            newString.remove(at: newString.startIndex)
        }
    }
    
    user?.setValue(newString, forKey: "filters")
    do {
      try context.save()
    } catch {
      print("Failed saving")
    }
    
    print("filters printed here")
    print(newString)
    
    dismiss(animated: true, completion: nil)
  }
  
  var filters = Filters().getFilters()
  let viewModel = FilterViewModel()
  var unselected: [String] = []
    
  
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
    
    let filterString: String
    if user!.value(forKey: "filters") == nil{
        filterString = ""
    }
    else {
        filterString = user!.value(forKey: "filters") as! String
    }
    let filterTitles = filterString.split { $0 == "," }
    print(filterTitles)
    
    print("dude")
    for title in filterTitles {
      let i = filterList.firstIndex(of: String(title))
      if i != nil {
        let indexPath = IndexPath(row: i!, section: 0)
        self.filterTable.selectRow(at: indexPath, animated: false, scrollPosition: .none)
      }
    }
  }
  
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return (viewModel.numberOfRows()!)
  }
  
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
    cell.title?.text = viewModel.titleForRowAtIndexPath(indexPath)
    print("cmon")
    if filters[indexPath.row].isSelected! {
      if !cell.isSelected {
        print("confused")
         tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
      }
    } else {
      if cell.isSelected {
        unselected.append((cell.title?.text!)!)
        print("unselect")
        print(cell.title?.text)
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
