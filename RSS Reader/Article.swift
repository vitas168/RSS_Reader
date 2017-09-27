//
//  Article.swift
//  RSS Reader
//
//  Created by Vitaly Shpinyov on 16/05/2017.
//  Copyright © 2017 Vitaly Shpinyov. All rights reserved.
//

import UIKit

// Article class holding article attributes

class Article: NSObject {

    var title:String = ""
    var timestamp:String = ""
    var timestampAsDate:Date?
    var timestampShort = ""
    var link:String = ""
    var image:String = ""
    var text:String = ""
    
}
