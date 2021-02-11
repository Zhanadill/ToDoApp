//
//  Item.swift
//  toDoApp
//
//  Created by Жанадил on 2/11/21.
//  Copyright © 2021 Жанадил. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object{
    @objc dynamic var text:String = ""
    @objc dynamic var done:Bool = false
    //@objc dynamic var date:Date
}
