//
//  contact.swift
//  ft_hangouts
//
//  Created by Arthur Tainmont on 27/01/2023.
//

import Foundation
import UIKit

func createContact(firstname: NSString, lastname: NSString, company: NSString,
                   phone: NSString, email: NSString, picture: UIImage) -> Bool {
    let db = database()
    let picture_base64 = UIImageToBase64(image: picture) as NSString
    
    print("Creating a contact.")
    var sql_request = "INSERT INTO contact (firstname, lastname, user_id,"
    sql_request += " company, phone, email, picture_base64) "
    sql_request += "VALUES (?, ?, ?, ?, ?, ?, ?);"
    let params = [firstname, lastname, "1", company, phone, email, picture_base64]
    let ret = db.database_call(sql_request: sql_request, params: params)
    return ret.0
}

func getContacts() -> (Bool, [[String: String]]) {
    let db = database()
    
    print("Get all contacts.")
    let sql_request = "SELECT * FROM contact;"
    let ret_labels = ["id", "firstname", "lastname", "user_id", "company",
                      "phone", "email", "picture_base64"]
    let ret = db.database_call(sql_request: sql_request, ret_labels: ret_labels)
    if ret.1.isEmpty {
        return (false, ret.1)
    }
    return ret
}

func getContact(id: NSString) -> (Bool, [String: String]) {
    let db = database()
    
    print("Get one specific contact.")
    let sql_request = "SELECT * FROM contact WHERE id = ?;"
    let params = [id]
    let ret_labels = ["id", "firstname", "lastname", "user_id", "company",
                      "phone", "email", "picture_base64"]
    let ret = db.database_call(sql_request: sql_request, params: params,
                               ret_labels: ret_labels)
    if ret.1.isEmpty {
        return (false, [:])
    }
    let r = (ret.0, ret.1[0])
    return r
}

func updateContact(id: NSString, columnToUpdate: String, newValue: NSString) -> Bool {
    let db = database()
    
    print("Update a specific contact.")
    let sql_request = "UPDATE contact SET \(columnToUpdate) = ? WHERE id = ?;"
    let ret = db.database_call(sql_request: sql_request, params: [newValue, id])
    return ret.0
}

func updateContact(id: NSString, newValue: UIImage) -> Bool {
    let base64 = UIImageToBase64(image: newValue) as NSString
    return updateContact(id: id, columnToUpdate: "picture_base64", newValue: base64)
}

func deleteContact(id: NSString) -> Bool {
    let db = database()
    
    print("Delete a specific contact.")
    let sql_request = "DELETE FROM contact WHERE id = ?;"
    let ret = db.database_call(sql_request: sql_request, params: [id])
    return ret.0
}

func base64ToUIImage(base64: String) -> UIImage {
    if base64 == "" {
        return UIImage()
    }
    let dataDecoded: Data = Data(base64Encoded: base64, options:
            .ignoreUnknownCharacters)!
    return UIImage(data: dataDecoded)!
}

func UIImageToBase64(image: UIImage) -> String {
    if image.ciImage == nil && image.cgImage == nil {
        print("Image is empty")
        return ""
    }
    if let imageData = image.pngData() as? NSData {
        let strBase64 = imageData.base64EncodedString(options: .lineLength64Characters)
        return strBase64
    } else {
        print("Unable to transform image for database storage")
        return ""
    }
}
