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
        
        (user_settings.language ==  "English") ?
                    (self.title = "Edit") : (self.title = "Éditer")
        view.backgroundColor = UIColor(named: user_settings.color)
        
        errorLabel.isHidden = true
        fieldFirstname.delegate = self
        fieldLastname.delegate = self
        fieldCompany.delegate = self
        fieldPhone.delegate = self
        fieldEmail.delegate = self
        
        var saveText: String
        (user_settings.language ==  "English") ?
                    ( saveText = "Save") : ( saveText = "Sauvegarder")
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: saveText, style: .done, target: self, action: #selector(saveTask))
        
        NotificationCenter.default.addObserver(self, selector:
            #selector(applicationDidBecomeActive),
            name: UIApplication.didBecomeActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector:
            #selector(applicationDidEnterBackground),
            name: UIApplication.didEnterBackgroundNotification, object: nil)
    }
    
    @objc func applicationDidBecomeActive(notification: NSNotification) {
            let message = getUser().1["last_connected"]!
            self.showToast(message: message, font: .systemFont(ofSize: 12.0))
    }
    
    @objc func applicationDidEnterBackground(notification: NSNotification) {
        updateUserLastConnected(user_id: getUser().1["id"]! as NSString)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.viewDidLoad()
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
