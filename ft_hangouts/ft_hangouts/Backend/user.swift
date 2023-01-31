//
//  user.swift
//  ft_hangouts
//
//  Created by Arthur Tainmont on 27/01/2023.
//

import Foundation

func createUser() {
    let db = database()
    let default_language: NSString = "English"
    let default_header_color: NSString = "black"
    let params = [default_language, default_header_color]
    
    print("Creating the user.")
    let sql_request = "INSERT INTO user (language, header_color) VALUES (?, ?);"
    db.database_call(sql_request: sql_request, params: params)
}

func getUser() -> (Bool, [String: String]) {
    let db = database()
    
    print("Get the user.")
    let ret = db.database_call(sql_request:
                                "SELECT * FROM user LIMIT 1;",
                               ret_labels: ["id", "language", "header_color", "creation_time"])
    if ret.1.isEmpty {
        return (false, [:])
    }
    let r = (ret.0, ret.1[0])
    return r
}

func updateUser(user_id: NSString, columnToUpdate: String, newValue: NSString) {
    let db = database()
    
    print("Update the user.")
    let sql_request = "UPDATE user SET \(columnToUpdate) = ? WHERE id = ?;"
    db.database_call(sql_request: sql_request, params: [newValue, user_id])
}
