//
//  database.swift
//  ft_hangouts
//
//  Created by Arthur Tainmont on 27/01/2023.
//

import Foundation
import SQLite3

class database {
    var db_access: OpaquePointer?
    var db_path: String
    let create_user_table: String = """
CREATE TABLE user (
    id INTEGER PRIMARY KEY,
    language varchar(20),
    header_color varchar(20),
    last_connected default NULL
);
"""
    let create_contact_table: String = """
CREATE TABLE contact (
    id INTEGER PRIMARY KEY,
    firstname varchar(40),
    lastname varchar(40),
    user_id INTEGER REFERENCES user(id),
    company varchar(100),
    phone varchar(20) UNIQUE,
    email varchar(100) UNIQUE,
    picture_base64 text default '',
    UNIQUE (firstname, lastname)
);
"""
    let create_message_table: String = """
CREATE TABLE message (
    id INTEGER PRIMARY KEY,
    send_by_me INTEGER,
    contact_id INTEGER REFERENCES contact(id),
    content varchar(500),
    time DATETIME default current_timestamp
);
"""

    init() {
        db_path = NSSearchPathForDirectoriesInDomains(
                    .documentDirectory, .userDomainMask, true).first!
        db_path += "/db.sqlite3";
        if sqlite3_open(db_path, &db_access) == SQLITE_OK {
            print("Database creation/connection success at \(db_path).")
        } else {
            print("Error: Unable to open database.")
            return
        }
        database_call(sql_request: create_user_table)
        database_call(sql_request: create_contact_table)
        database_call(sql_request: create_message_table)
    }

    deinit {
        sqlite3_close(db_access)
    }


    func kill_database() {
        do {
            try FileManager.default.removeItem(atPath: db_path)
            print("Database killed.")
        } catch {
            print("Database could not be killed error: \(error).")
        }
    }

    @discardableResult func database_call(sql_request: String, params: [NSString] = [],
                                          ret_labels: [String] = [])
                                            -> (Bool, [[String: String]]) {
        var prepared_statement: OpaquePointer?
        var error_message: String? = nil
        var ret: [[String: String]] = []
        var row = 0
        var status: Int32 = 0

        if sqlite3_prepare_v2(db_access, sql_request, -1, &prepared_statement, nil)
            == SQLITE_OK {
            for (index, param) in params.enumerated() {
                sqlite3_bind_text(prepared_statement, Int32(index + 1),
                                  param.utf8String, -1, nil)
            }
            while true {
                status = sqlite3_step(prepared_statement)
                if status != SQLITE_ROW {
                    break
                }
                ret.append([:])
                for (i, key) in ret_labels.enumerated() {
                    if let val = sqlite3_column_text(prepared_statement,
                                                     Int32(i)) {
                        ret[row][key] = String(cString: val)
                    } else {
                        ret[row][key] = ""
                    }
                    
                }
                row += 1
            }
            if status == SQLITE_DONE {
                print("SQL request success.")
            } else {
                error_message = String(cString: sqlite3_errmsg(db_access))
                print("ERROR MESSAGE: \(error_message!)")
                print("Error: SQL request failed.")
            }

        } else {
            error_message = String(cString: sqlite3_errmsg(db_access))
            if error_message != "table user already exists" &&
                error_message != "table contact already exists" &&
                error_message != "table message already exists" {
                print("ERROR MESSAGE: \(error_message!)")
                print("Error: SQL request is not prepared.")
            } else {
                print("Database tables already created.")
            }
        }
        sqlite3_finalize(prepared_statement)
        if error_message != nil {
            return (false, [["error":error_message!]])
        } else {
            return (true, ret)
        }

    }

}

//var test = database()
//test.kill_database()

//func createUser() {
//    let db = database()
//    let default_language: NSString = "English"
//    let default_header_color: NSString = "black"
//    let params = [default_language, default_header_color]

//    print("Creating the user.")
//    let sql_request = "INSERT INTO user (language, header_color) VALUES (?, ?);"
//    db.database_call(sql_request: sql_request, params: params)
//}

//createUser()

//func createContact(firstname: NSString, lastname: NSString, company: NSString,
//                   phone: NSString, email: NSString) -> Bool {
//    let db = database()

//    print("Creating a contact.")
//    var sql_request = "INSERT INTO contact (firstname, lastname, user_id,"
//    sql_request += " company, phone, email) VALUES (?, ?, ?, ?, ?, ?);"
//    let params = [firstname, lastname, "1", company, phone, email]
//    let ret = db.database_call(sql_request: sql_request, params: params)
//    return ret.0
//}

//createContact(firstname: "Harry", lastname: "Tainmont", company: "OLV", phone: "0473359749", email: "harry@mail.com")
//createContact(firstname: "Antoine", lastname: "Brandt", company: "SV", phone: "0473859749", email: "antoine@mail.com")
//createContact(firstname: "Thibault", lastname: "Courtois", company: "FC-GENT", phone: "0473879749", email: "Tibo@mail.com")

//func getContacts() -> (Bool, [[String: String]]) {
//    let db = database()
//
//    print("Get all contacts.")
//    let sql_request = "SELECT * FROM contact;"
//    let ret_labels = ["id", "firstname", "lastname", "user_id", "company",
//                      "phone", "email", "picture_storage_path"]
//    let ret = db.database_call(sql_request: sql_request, ret_labels: ret_labels)
//    if ret.1.isEmpty {
//        return (false, ret.1)
//    }
//    return ret
//}

//print(getContacts().1)
