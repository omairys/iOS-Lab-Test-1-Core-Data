//
//  SaveViewController.swift
//  Lab Test 1 App
//
//  Created by Omairys Uzcátegui on 2021-09-16.
//

import UIKit
import CoreData

protocol SaveViewControllerDelegate: AnyObject {
  func saveViewController(filter: SaveViewController, didSelectPredicate predicate: NSPredicate?, sortDescriptor: NSSortDescriptor?)
}

class SaveViewController: UIViewController {

    private var datePicker : UIDatePicker?
    @IBOutlet weak var inputName: UITextField!
    @IBOutlet weak var inputAge: UITextField!
    @IBOutlet weak var inputTution: UITextField!
    @IBOutlet weak var inputStartDate: UITextField!
    var coreDataStack : CoreDataStack!
    weak var delegate: SaveViewControllerDelegate?
    var selectedSortDescriptor: NSSortDescriptor?
    var selectedPredicate: NSPredicate?
    //var student: [Student]!
    var currentStudent : Student?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .date
        datePicker?.preferredDatePickerStyle = .wheels
        datePicker?.addTarget(self, action: #selector(SaveViewController.dateChanged(datePicker:)), for: .valueChanged)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(SaveViewController.viewTapped(gestureReconizer:)))
        
        view.addGestureRecognizer(tapGesture)
        inputStartDate.inputView = datePicker
        
        self.currentStudent = self.currentStudent ?? NSEntityDescription.insertNewObject(forEntityName: "Student",
                                                                                         into: self.coreDataStack.managedContext) as! Student
        
        setUIValues()
        
    }
    
    @objc func viewTapped(gestureReconizer: UITapGestureRecognizer){
        view.endEditing(true)
    }
    
    @objc func dateChanged(datePicker: UIDatePicker){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        inputStartDate.text = dateFormatter.string(from: datePicker.date)
        view.endEditing(true)
    }
    
    func setUIValues() {
        guard
            let currentName = self.currentStudent?.name,
            let currentAge = self.currentStudent?.age,
            let currentTution = self.currentStudent?.tution,
            let currentStartDate = self.currentStudent?.termStart else {
                return
            }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        self.inputName.text = currentName
        self.inputAge.text = String(currentAge)
        self.inputTution.text = String(currentTution)
        self.inputStartDate.text = dateFormatter.string(from: (currentStartDate))
    }

    
    @IBAction func save(_ sender: UIBarButtonItem) {
        guard
            let name = inputName.text,
            let ageString = inputAge.text,
            let tutionString = inputTution.text,
            let startDateString = inputStartDate.text else {
                return
            }
        
        if name.isEmpty || ageString.isEmpty || tutionString.isEmpty || startDateString.isEmpty {
            let alert = UIAlertController(title: "Alert", message: "All fields are mandatory", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
            return
        }else{
            self.currentStudent!.name = name
            self.currentStudent!.age = Int32(ageString)!
            self.currentStudent!.tution = Double(tutionString)!
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd/yyyy"
            let date = dateFormatter.date(from: startDateString)
            self.currentStudent?.termStart = date

            do {
                try coreDataStack.managedContext.save()
            } catch let error as NSError {
                print("Save error: \(error), description: \(error.userInfo)")
            }
            
            delegate?.saveViewController(filter: self, didSelectPredicate: selectedPredicate, sortDescriptor: selectedSortDescriptor)
            dismiss(animated: true, completion: nil)
        }
    }
    
    
    @IBAction func exit(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
}
