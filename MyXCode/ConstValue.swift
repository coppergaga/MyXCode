//
//  ConstValue.swift
//  MyXCode
//
//  Created by GaoXudong on 2023/11/27.
//

import Foundation

struct ConstValue {
    static var groupUrl: URL? {
        FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "S5KT549QVB.com.coppergaga.MyXCode.group")
    }
    
    static let swiftFormatConfigName = "swift-format-config.json"
}
