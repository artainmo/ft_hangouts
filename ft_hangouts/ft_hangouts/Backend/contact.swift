//
//  contact.swift
//  ft_hangouts
//
//  Created by Arthur Tainmont on 27/01/2023.
//

import Foundation

func createContact(firstname: NSString, lastname: NSString, company: NSString,
                   phone: NSString, email: NSString) -> Bool {
    let db = database()
    
    print("Creating a contact.")
    var sql_request = "INSERT INTO contact (firstname, lastname, user_id,"
    sql_request += " company, phone, email) VALUES (?, ?, ?, ?, ?, ?);"
    let params = [firstname, lastname, "1", company, phone, email]
    let ret = db.database_call(sql_request: sql_request, params: params)
    return ret.0
}

func getContacts() -> (Bool, [[String: String]]) {
    let db = database()
    
    print("Get all contacts.")
    let sql_request = "SELECT * FROM contact;"
    let ret_labels = ["id", "firstname", "lastname", "user_id", "company",
                      "phone", "email", "picture_storage_path"]
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
                      "phone", "email", "picture_storage_path"]
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

func deleteContact(id: NSString) -> Bool {
    let db = database()
    
    print("Delete a specific contact.")
    let sql_request = "DELETE FROM contact WHERE id = ?;"
    let ret = db.database_call(sql_request: sql_request, params: [id])
    return ret.0
}

