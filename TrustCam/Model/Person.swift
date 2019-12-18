//
//  Person.swift
//  TrustCam
//
//  Created by Caner Ates on 2019/10/28.
//  Copyright © 2019 Caner Ates All rights reserved.
//

import UIKit

class Person {
    
    // MARK: - Properties
    
    var username: String
    var email: String
    var password: String
    
    // MARK: - Methods
    
    init(username: String, email: String, password: String) {
        self.username = username
        self.email = email
        self.password = password
    }
}
