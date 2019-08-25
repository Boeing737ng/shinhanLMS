//
//  User.swift
//  userApp
//
//  Created by Kihyun Choi on 25/08/2019.
//  Copyright © 2019 sfo. All rights reserved.
//

import UIKit

var userNo: String = ""
var userCompanyCode: String = ""

class User {
    func getCurrentUserNo() -> String {
        return userNo
    }
    func getCurrentUserCompanyCode() -> String {
        return userCompanyCode
    }
}
