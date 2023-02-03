//
//  ContactPageVC.swift
//  ft_hangouts
//
//  Created by Arthur Tainmont on 30/01/2023.
//

import UIKit
import MessageUI

class ContactPageVC: UIViewController {
    
    var contact: [String:String] = [:]
    var updateContacts: (() -> Void)?
    
    @IBOutlet var phoneLabel: UILabel!
    @IBOutlet var companyLabel: UILabel!
    @IBOutlet var emailLabel: UILabel!
    
    @IBOutlet var imageView: UIImageView!
    
    @IBOutlet var messageButton: UIButton!
    @IBOutlet var callButton: UIButton!
    @IBOutlet var mailButton: UIButton!
    @IBOutlet var deleteButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = contact["firstname"]! + " " + contact["lastname"]!
        view.backgroundColor = UIColor(named: user_settings.color)
        
        if user_settings.language == "English" {
            phoneLabel.text = "Phone number: " + contact["phone"]!
            companyLabel.text = "Company: " + contact["company"]!
            emailLabel.text = "Email: " + contact["email"]!
            mailButton.setTitle("Mail", for: .normal)
            callButton.setTitle("Call", for: .normal)
            messageButton.setTitle("Message", for: .normal)
            deleteButton.setTitle("DELETE", for: .normal)
        } else {
            phoneLabel.text = "Numéro de téléphone: " + contact["phone"]!
            companyLabel.text = "Entreprise: " + contact["company"]!
            emailLabel.text = "Email: " + contact["email"]!
            mailButton.setTitle("Mail", for: .normal)
            callButton.setTitle("Téléphoner", for: .normal)
            messageButton.setTitle("Message", for: .normal)
            deleteButton.setTitle("SUPPRIMER", for: .normal)
        }
        imageView.image = base64ToUIImage(base64: contact["picture_base64"]!)
        
        var editText: String
        (user_settings.language ==  "English") ?
                    ( editText = "Edit") : ( editText = "Éditer")
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: editText,
                  style: .done, target: self, action: #selector(editContact))
        
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

extension ContactPageVC: MFMessageComposeViewControllerDelegate {
    
    @IBAction func send_message() {
        if !MFMessageComposeViewController.canSendText() {
            print("Device not able to send messages.")
            return
        }
        let composer = MFMessageComposeViewController()
        composer.messageComposeDelegate = self
        composer.recipients = [contact["phone"]!]
        //composer.subject = contact["firstname"]! + " " +
        //          contact["lastname"]!
        self.present(composer, animated: true)
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        switch result {
        case .cancelled:
            print("Cancelled")
            controller.dismiss(animated: true)
        case .failed:
            print("failed")
        case .sent:
            print("send")
        default:
            print("Message unknown result")
        }
        //controller.dismiss(animated: true)
    }
    
    @IBAction func phone_call() {
        if let url = URL(string: "tel://\(contact["phone"]!)"),
                            UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        } else {
            print("Unable to call.")
        }
    }
    
}

extension ContactPageVC: MFMailComposeViewControllerDelegate {
    
    @IBAction func send_mail() {
        if !MFMailComposeViewController.canSendMail() {
            print("Device not able to send mails.")
            return
        }
        let composer = MFMailComposeViewController()
        composer.mailComposeDelegate = self
        composer.setToRecipients([contact["email"]!])
        present(composer, animated: true)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        if let e = error {
            print(e)
            controller.dismiss(animated: true)
            return
        }
        switch result {
        case .cancelled:
            print("Cancelled")
        case .failed:
            print("Failed to send")
        case .saved:
            print("Saved")
        case .sent:
            print("Email sent")
        @unknown default:
            print("Unknown")
        }
        controller.dismiss(animated: true)
    }
}
