//
//  ContactPageVC.swift
//  ft_hangouts
//
//  Created by Arthur Tainmont on 30/01/2023.
//

import UIKit

class ContactPageVC: UIViewController {
    
    var contact: [String:String] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = contact["firstname"]! + " " + contact["lastname"]!
    }

}
