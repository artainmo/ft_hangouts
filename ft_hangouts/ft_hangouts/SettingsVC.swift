//
//  SettingsVC.swift
//  ft_hangouts
//
//  Created by Arthur Tainmont on 31/01/2023.
//

import UIKit

class SettingsVC: UIViewController {

    @IBOutlet weak var languageSC: UISegmentedControl!
    @IBOutlet weak var colorSC: UISegmentedControl!
    @IBOutlet weak var deleteButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        (user_settings.language ==  "English") ?
                    (self.title = "Settings") : (self.title = "Paramètres")
        view.backgroundColor = UIColor(named: user_settings.color)
        if user_settings.language ==  "English" {
            languageSC.selectedSegmentIndex = 0
            languageSC.setTitle("English", forSegmentAt: 0)
            languageSC.setTitle("French", forSegmentAt: 1)
            colorSC.setTitle("Green", forSegmentAt: 0)
            colorSC.setTitle("Blue", forSegmentAt: 1)
        } else {
            languageSC.selectedSegmentIndex = 1
            languageSC.setTitle("Anglais", forSegmentAt: 0)
            languageSC.setTitle("Français", forSegmentAt: 1)
            colorSC.setTitle("Vert", forSegmentAt: 0)
            colorSC.setTitle("Bleu", forSegmentAt: 1)
        }
        if user_settings.color ==  "background-color1" {
            colorSC.selectedSegmentIndex = 0
        } else {
            colorSC.selectedSegmentIndex = 1
        }
        if user_settings.language == "English" {
            deleteButton.setTitle("DELETE ACCOUNT", for: .normal)
        } else {
            deleteButton.setTitle("SUPPRIMER COMPTE", for: .normal)
        }
        
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
    
    @IBAction func languageChanged(_ sender: UISegmentedControl) {
        let user = getUser().1
        
        if sender.selectedSegmentIndex == 0 {
            updateUser(user_id: user["id"]! as NSString,
                       columnToUpdate: "language", newValue: "English")
            user_settings.language = "English"
            self.viewDidLoad()
        } else {
            updateUser(user_id: user["id"]! as NSString,
                       columnToUpdate: "language", newValue: "French")
            user_settings.language = "French"
            self.viewDidLoad()
        }
    }
    
    @IBAction func colorChanged(_ sender: UISegmentedControl) {
        let user = getUser().1
        
        if sender.selectedSegmentIndex == 0 {
            updateUser(user_id: user["id"]! as NSString,
                       columnToUpdate: "header_color",
                       newValue: "background-color1")
            user_settings.color = "background-color1"
            self.viewDidLoad()
        } else {
            updateUser(user_id: user["id"]! as NSString,
                       columnToUpdate: "header_color",
                       newValue: "background-color2")
            user_settings.color = "background-color2"
            self.viewDidLoad()
        }
    }
    
    @IBAction func deleteAccountButtonPressed() {
        deleteAccount()
        exit(0)
    }
}

struct Settings {
    var language: String
    var color: String
    
    init() {
        self.language = "English"
        self.color = "background-color1"
    }
}

func getSettings() {
    let user = getUser().1
    
    user_settings.language = user["language"]!
    user_settings.color = user["header_color"]!
}

var user_settings: Settings = Settings()
