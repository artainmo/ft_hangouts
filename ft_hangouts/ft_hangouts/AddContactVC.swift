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
    
    @IBOutlet var imageView: UIImageView!
    
    @IBOutlet var errorLabel: UILabel!
    
    var updateContacts: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        (user_settings.language ==  "English") ?
                    (self.title = "Add") : (self.title = "Ajouter")
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
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: saveText, style: .done, target: self, action: #selector(saveContact))
        
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
    
    @objc func saveContact() {
        let firstname = fieldFirstname.text! as NSString
        let lastname = fieldLastname.text! as NSString
        let company = fieldCompany.text! as NSString
        let phone = fieldPhone.text! as NSString
        let email = fieldEmail.text! as NSString
        
        let success = createContact(firstname: firstname,
                lastname: lastname, company: company, phone: phone,
                email: email, picture: imageView.image!)
        if success {
            self.updateContacts?()
            navigationController?.popViewController(animated: true)
        } else {
            errorLabel.isHidden = false
        }
    }
}

extension AddContactVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
