//
//  Item.swift
//  MyTodoList
//
//  Created by Apple on 5/20/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import Foundation

class Item :Encodable , Decodable {
    var title: String = ""
    var done: Bool = false
    
}
