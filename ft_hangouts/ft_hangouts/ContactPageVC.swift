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
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit",
                  style: .done, target: self, action: #selector(editContact))
    }
    
    @IBAction func removeContact() {
        let success = deleteContact(id: contact["id"]! as NSString)
        if success {
            self.updateContacts?()
            navigationController?.popViewController(animated: true)
        }
    }
    
    @objc func editContact() {
        let vc = storyboard?.instantiateViewController(identifier: "update") as! UpdateContactVC
        vc.title = "Edit Contact"
        vc.contact = contact
        vc.updateContacts = {
            DispatchQueue.main.async {
                self.updateContacts?()
                self.navigationController?.popViewController(animated: false)
            }
        }
        navigationController?.pushViewController(vc, animated: true)
    }

}
