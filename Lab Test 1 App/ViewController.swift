//
//  ViewController.swift
//  Lab Test 1 App
//
//  Created by Omairys Uzcátegui on 2021-09-14.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, SaveViewControllerDelegate  {
    
    // MARK: - TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return students.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let student = students[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: studentCellIdentifier) as! StudentTableViewCell
        cell.setStudentCell(obj: student)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        coreDataStack.managedContext.delete(students.remove(at: indexPath.row))
        do {
            try coreDataStack.managedContext.save()
            tableView.deleteRows(at: [indexPath], with: .fade)
        } catch let error as NSError {
            print ("Saving error: \(error), description: \(error.userInfo)")
        }
    }
    // MARK: - Declaration
    lazy var coreDataStack = CoreDataStack(modelName: "Student")
    private let saveViewControllerSegueIdentifier = "toSaveViewController"
    private let editViewControllerSegueIdentifier = "editToSaveViewController"
    fileprivate let studentCellIdentifier = "StudentCell"
    var fetchRequest: NSFetchRequest<Student>?
    var asyncFetchRequest: NSAsynchronousFetchRequest<Student>?
    
    @IBOutlet weak var tableView: UITableView!
    var students: [Student] = [] // to populate the table
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let studentFetchRequest: NSFetchRequest<Student> = Student.fetchRequest()
        self.fetchRequest = studentFetchRequest
        self.asyncFetchRequest = NSAsynchronousFetchRequest<Student>(fetchRequest: studentFetchRequest, completionBlock: {
          [unowned self] (result: NSAsynchronousFetchResult) in

          guard let students = result.finalResult
          else {
            return
          }

            self.students = students
          self.tableView.reloadData()
        })
        
        fetchAndReload()
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let navController = segue.destination as? UINavigationController,
        let saveVC = navController.topViewController as? SaveViewController else {
            return
        }
        
        switch segue.identifier! {
        case saveViewControllerSegueIdentifier:
            
            saveVC.coreDataStack = coreDataStack
            saveVC.delegate = self
            
        case editViewControllerSegueIdentifier:
            let selectedIndexPath = self.tableView.indexPathForSelectedRow!
            let selectedStudent = self.students[selectedIndexPath.row]
            
            saveVC.currentStudent = selectedStudent
        default:
                break
            }
    }
    
    func fetchAndReload() {
        guard let fetchRequest = fetchRequest else {
            return
        }
        
        do {
            students = try coreDataStack.managedContext.fetch(fetchRequest)
            tableView.reloadData()
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    
    func saveViewController(filter: SaveViewController, didSelectPredicate predicate: NSPredicate?, sortDescriptor: NSSortDescriptor?) {

      guard let fetchRequest = fetchRequest else {
        return
      }

      fetchRequest.predicate = nil
      fetchRequest.sortDescriptors = nil
      fetchRequest.predicate = predicate

      if let sr = sortDescriptor {
        fetchRequest.sortDescriptors = [sr]
      }

      fetchAndReload()
    }


}

