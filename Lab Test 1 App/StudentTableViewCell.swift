//
//  StudentTableViewController.swift
//  Lab Test 1 App
//
//  Created by Omairys Uzcátegui on 2021-09-16.
//

import UIKit

class StudentTableViewCell: UITableViewCell{
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var age: UILabel!
    @IBOutlet weak var tution: UILabel!
    @IBOutlet weak var startDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setStudentCell(obj:Student)
    {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currencyAccounting
        formatter.maximumFractionDigits = 2
        
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"

        name.text = obj.name
        age.text = String(obj.age)
        
        let number = NSNumber(value: obj.tution)
        tution.text = formatter.string(from: number)!
        startDate.text = dateFormatter.string(from: obj.termStart!)
    }
    
    
}
