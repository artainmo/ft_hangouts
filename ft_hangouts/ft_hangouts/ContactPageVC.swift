//
//  ContactPageVC.swift
//  ft_hangouts
//
//  Created by Arthur Tainmont on 30/01/2023.
//

import UIKit

class ContactPageVC: UIViewController {
    
    var contact: [String:String] = [:]
    var updateContacts: (() -> Void)?
    
    @IBOutlet var phoneLabel: UILabel!
    @IBOutlet var companyLabel: UILabel!
    @IBOutlet var emailLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        phoneLabel.text = contact["phone"]
        companyLabel.text = contact["company"]
        emailLabel.text = contact["email"]
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Delete",
                    style: .done, target: self, action: #selector(removeContact))
    }
    
    @objc func removeContact() {
        var success = deleteContact(id: contact["id"]! as NSString)
        if success {
            self.updateContacts?()
            navigationController?.popViewController(animated: true)
        }
    }

}
