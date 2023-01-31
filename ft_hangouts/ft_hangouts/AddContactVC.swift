//
//  AddContactVC.swift
//  ft_hangouts
//
//  Created by Arthur Tainmont on 31/01/2023.
//

import UIKit

class AddContactVC: UIViewController, UITextFieldDelegate {

    @IBOutlet var fieldFirstname: UITextField!
    @IBOutlet var fieldLastname: UITextField!
    @IBOutlet var fieldCompany: UITextField!
    @IBOutlet var fieldPhone: UITextField!
    @IBOutlet var fieldEmail: UITextField!
    
    var updateContacts: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fieldFirstname.delegate = self
        fieldLastname.delegate = self
        fieldCompany.delegate = self
        fieldPhone.delegate = self
        fieldEmail.delegate = self
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(saveTask))
    }
    
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        saveTask()
//        return true
//    }
    
    @objc func saveTask() {
        let firstname = fieldFirstname.text! as NSString
        let lastname = fieldLastname.text! as NSString
        let company = fieldCompany.text! as NSString
        let phone = fieldPhone.text! as NSString
        let email = fieldEmail.text! as NSString
        
        let success = createContact(firstname: firstname,
                lastname: lastname, company: company, phone: phone, email: email)
        if success {
            self.updateContacts?()
            navigationController?.popViewController(animated: true)
        }
    }

}
