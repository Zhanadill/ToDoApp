//
//  Category.swift
//  toDoApp
//
//  Created by Жанадил on 2/12/21.
//  Copyright © 2021 Жанадил. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object{
    @objc dynamic var name:String?
    @objc dynamic var color:String?
    let items = List<Item>()
}
