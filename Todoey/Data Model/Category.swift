//
//  Category.swift
//  Todoey
//
//  Created by 67621177 on 08/10/2018.
//  Copyright © 2018 67621177. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    //relationship toMany => list
    let items = List<Item>()
    
    
}
