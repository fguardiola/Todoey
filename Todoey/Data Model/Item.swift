//
//  Item.swift
//  Todoey
//
//  Created by 67621177 on 08/10/2018.
//  Copyright © 2018 67621177. All rights reserved.
//

import Foundation
import RealmSwift


class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated : Date?
    //toOne relationdhip
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
