//
//  Category.swift
//  TodoList
//
//  Created by Akash Pawar on 7/14/19.
//  Copyright © 2019 Akash Pawar. All rights reserved.
//

import Foundation
import RealmSwift

class Category : Object{
    
    @objc dynamic var name : String = ""
    let items = List<Item>()
}
