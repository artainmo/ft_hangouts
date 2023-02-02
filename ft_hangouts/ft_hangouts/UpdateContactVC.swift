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
    
    @IBOutlet var imageView: UIImageView!
    
    @IBOutlet weak var photoButton: UIButton!
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
        if user_settings.language == "English" {
            fieldFirstname.placeholder = "First name"
            fieldLastname.placeholder = "Last name"
            fieldCompany.placeholder = "Company"
            fieldPhone.placeholder = "Phone number"
            fieldEmail.placeholder = "Email"
        } else {
            fieldFirstname.placeholder = "Prénom"
            fieldLastname.placeholder = "Nom de famille"
            fieldCompany.placeholder = "Entreprise"
            fieldPhone.placeholder = "Numéro de téléphone"
            fieldEmail.placeholder = "Email"
        }
        if user_settings.language == "English" {
            photoButton.setTitle("Pick Photo", for: .normal)
        } else {
            photoButton.setTitle("Choisir Photo", for: .normal)
        }
        if user_settings.language == "English" {
            errorLabel.text = "Not possible to update contact."
        } else {
            errorLabel.text = "Pas possible de mettre à jour."
        }
        
        self.hideKeyboardWhenTappedAround() 
        
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
        if let image = imageView.image {
            if image.ciImage != nil || image.cgImage != nil {
                if !updateContact(id: contact["id"]! as NSString,
                                  newValue: image) {
                    error = true
                }
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

extension UpdateContactVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBAction func pickImage() {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print("Image picked")
        if let im = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            print("Image unwrapped")
            imageView.image = im
        } else {
            print("Error unwrapping image")
        }
        picker.dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}
