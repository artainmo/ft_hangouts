//
//  message.swift
//  ft_hangouts
//
//  Created by Arthur Tainmont on 27/01/2023.
//

/*
 * IN THE END WE DON'T HANDLE MESSAGES OURSELVES AND THUS DON'T USE THIS FILE
 * MESSAGES ARE HANDLED BY APPLE ITSELF
 */

import Foundation

func createMessage(send_by_me: NSString, contact_id: NSString, content: NSString) -> Bool {
    let db = database()
    
    print("Creating a contact.")
    var sql_request = "INSERT INTO message (send_by_me, contact_id, content)"
    sql_request += " VALUES (?, ?, ?);"
    let params = [send_by_me, contact_id, content]
    let ret = db.database_call(sql_request: sql_request, params: params)
    return ret.0
}

func getMessages(with_id contact_id: NSString) -> (Bool, [[String: String]]) {
    let db = database()
    
    print("Get all messages with one contact.")
    let sql_request = "SELECT * FROM message WHERE contact_id = ?;"
    let params = [contact_id]
    let ret_labels = ["id", "send_by_me", "contact_id", "content", "time"]
    let ret = db.database_call(sql_request: sql_request, params: params,
                               ret_labels: ret_labels)
    if ret.1.isEmpty {
        return (false, [[:]])
    }
    return ret
}
