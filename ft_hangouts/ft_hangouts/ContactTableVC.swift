//
//  contactTableViewViewController.swift
//  ft_hangouts
//
//  Created by Arthur Tainmont on 30/01/2023.
//

import UIKit

class ContactTableVC: UIViewController {
    var contacts: [[String: String]] = []
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        prepareUserAccount()
        getSettings()
        super.viewDidLoad()
        
        (user_settings.language ==  "English") ?
                    (self.title = "Contacts") : (self.title = "Contacts")
        view.backgroundColor = UIColor(named: user_settings.color)
        
        updateContacts()
        tableView.delegate = self
        tableView.dataSource = self
        
        var addText: String
        (user_settings.language ==  "English") ?
                    ( addText = "Add") : ( addText = "Ajouter")
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: addText,
                  style: .done, target: self, action: #selector(addContact))
        
        NotificationCenter.default.addObserver(self, selector:
            #selector(applicationDidBecomeActive),
            name: UIApplication.didBecomeActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector:
            #selector(applicationDidEnterBackground),
            name: UIApplication.didEnterBackgroundNotification, object: nil)
    }
    
    @objc func applicationDidBecomeActive(notification: NSNotification) {
        let message = getUser().1["last_connected"]!
        if message != "" {
            self.showToast(message: message, font: .systemFont(ofSize: 12.0))
        }
    }
    
    @objc func applicationDidEnterBackground(notification: NSNotification) {
        updateUserLastConnected(user_id: getUser().1["id"]! as NSString)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.viewDidLoad()
    }
    
    func prepareUserAccount() {
        if getUser().0 == false {
            createUser()
        }
    }
    
    func updateContacts() {
        contacts.removeAll()
        contacts = getContacts().1
        tableView.reloadData()
    }
    
    @objc func addContact() {
        let vc = storyboard?.instantiateViewController(identifier: "add") as! AddContactVC
        vc.updateContacts = {
            DispatchQueue.main.async {
                self.updateContacts()
            }
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension ContactTableVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if contacts.count <= indexPath.row {
            return UITableViewCell()
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "contactCell")!
        let contact = contacts[indexPath.row]
        cell.textLabel?.text = contact["firstname"]! + " " + contact["lastname"]!
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if contacts.count <= indexPath.row {
            return
        }
        let contact = contacts[indexPath.row]
        
        let vc = storyboard?.instantiateViewController(identifier: "ContactPage") as! ContactPageVC
        vc.title = contact["firstname"]! + " " + contact["lastname"]!
        vc.contact = contact
        vc.updateContacts = {
            DispatchQueue.main.async {
                self.updateContacts()
            }
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        
    }
}

extension UIViewController {

func showToast(message : String, font: UIFont) {
    let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75, y: self.view.frame.size.height-100, width: 150, height: 35))
    toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
    toastLabel.textColor = UIColor.white
    toastLabel.font = font
    toastLabel.textAlignment = .center;
    toastLabel.text = message
    toastLabel.alpha = 1.0
    toastLabel.layer.cornerRadius = 10;
    toastLabel.clipsToBounds  =  true
    self.view.addSubview(toastLabel)
    UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
         toastLabel.alpha = 0.0
    }, completion: {(isCompleted) in
        toastLabel.removeFromSuperview()
    })
} }
