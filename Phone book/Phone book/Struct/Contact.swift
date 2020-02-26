//
//  StructContact.swift
//  Phone book
//
//  Created by user on 14.02.2020.
//  Copyright © 2020 user. All rights reserved.
//

import UIKit

struct Contact
{
    var name: String = ""
    var sername: String = ""
    var company: String = ""
    var telephoneNumber: [String] = [""]
    var email: [String] = [""]
    var photo: UIImage? = #imageLiteral(resourceName: "userContact")
    var section: Int = 0
    var cellInSection: Int = 0
    var id: Int = 0
}
