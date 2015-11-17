//
//  AftArticle.swift
//  AfterManager
//
//  Created by Jaben on 15/11/17.
//  Copyright © 2015年 After. All rights reserved.
//

import Foundation

class AftArticle: NSObject {
    var articleID : String!
    var title : String!
    var content : String!
    var refer : String!
    var author : String!
    var authorIntro : String!
    var createAt : NSDate!
    var updateAt : NSDate!
    
    override init() {
        super.init()
    }
}