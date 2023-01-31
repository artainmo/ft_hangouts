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
        super.viewDidLoad()
        self.title = "Contacts"
        updateContacts()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func prepareUserAccount() {
        if getUser().0 == false {
            createUser()
            //Fill empty database with contacts for test purposes
            print(createContact(firstname: "Harry", lastname: "Tainmont", company: "OLV", phone: "0473359749", email: "harry@mail.com"))  //test
            print(createContact(firstname: "Antoine", lastname: "Brandt", company: "SV", phone: "0473859749", email: "antoine@mail.com")) //test
            print(createContact(firstname: "Thibault", lastname: "Courtois", company: "FC-GENT", phone: "0473879749", email: "Tibo@mail.com")) //test
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ContactPageVC
        destinationVC.contact = sender as! [String: String]
    }
    
    func updateContacts() {
        contacts.removeAll()
        contacts = getContacts().1
        tableView.reloadData()
    }
    
    @IBAction func addContact() {
        let vc = storyboard?.instantiateViewController(identifier: "add") as! AddContactVC
        vc.title = "Add Contact"
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
            performSegue(withIdentifier: "contactAccount", sender: nil)
            return
        }
        let contact = contacts[indexPath.row]
        performSegue(withIdentifier: "contactAccount", sender: contact)
    }
}
