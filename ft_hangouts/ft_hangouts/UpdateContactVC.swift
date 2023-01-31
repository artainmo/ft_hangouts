//
//  UpdateContactVC.swift
//  ft_hangouts
//
//  Created by Arthur Tainmont on 31/01/2023.
//

import UIKit

class UpdateContactVC: UIViewController, UITextFieldDelegate {
    
    var contact: [String:String] = [:]
    var updateContacts: (() -> Void)?
    
    @IBOutlet var fieldFirstname: UITextField!
    @IBOutlet var fieldLastname: UITextField!
    @IBOutlet var fieldCompany: UITextField!
    @IBOutlet var fieldPhone: UITextField!
    @IBOutlet var fieldEmail: UITextField!
    
    @IBOutlet var errorLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        errorLabel.isHidden = true
        fieldFirstname.delegate = self
        fieldLastname.delegate = self
        fieldCompany.delegate = self
        fieldPhone.delegate = self
        fieldEmail.delegate = self
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(saveTask))
    }
    
    @objc func saveTask() {
        var error = false
        
        if let firstname = fieldFirstname.text, !firstname.isEmpty {
            if !updateContact(id: contact["id"]! as NSString,
                          columnToUpdate: "firstname",
                              newValue: firstname as NSString) {
                error = true
            }
        }
        if let lastname = fieldLastname.text, !lastname.isEmpty {
            if !updateContact(id: contact["id"]! as NSString,
                          columnToUpdate: "lastname",
                             newValue: lastname as NSString) {
                error = true
            }
        }
        if let company = fieldCompany.text, !company.isEmpty {
            if !updateContact(id: contact["id"]! as NSString,
                          columnToUpdate: "company",
                             newValue: company as NSString) {
                error = true
            }
        }
        if let phone = fieldPhone.text, !phone.isEmpty {
            if !updateContact(id: contact["id"]! as NSString,
                          columnToUpdate: "phone",
                             newValue: phone as NSString) {
                error = true
            }
        }
        if let email = fieldEmail.text, !email.isEmpty {
            if !updateContact(id: contact["id"]! as NSString,
                          columnToUpdate: "email",
                             newValue: email as NSString) {
                error = true
            }
        }
        
        if !error {
            self.updateContacts?()
            navigationController?.popViewController(animated: true)
        } else {
            errorLabel.isHidden = false
        }
    }
}
