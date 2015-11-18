//
//  AftBmobManager.swift
//  AfterManager
//
//  Created by Jaben on 15/11/18.
//  Copyright © 2015年 After. All rights reserved.
//

import Foundation

class AftBmobManager: NSObject {
    class var sharedInstance: AftBmobManager {
        struct Static {
            static let instance: AftBmobManager = AftBmobManager()
        }
        return Static.instance
    }
    
    func loadArticleLists() -> () {
        let bmobQuery: BmobQuery = BmobQuery(className: "table_article")
        
        bmobQuery.findObjectsInBackgroundWithBlock { (results, error) -> Void in
            
            let tempArticleLists: NSMutableArray = NSMutableArray.init(array: [])
            
            for bmobObject in results {
                
                if bmobObject is BmobObject {
                    let tempArticle: AftArticle = AftArticle.init()
                    tempArticle.articleID = bmobObject.objectId
                    tempArticle.createAt = bmobObject.createdAt
                    tempArticle.updateAt = bmobObject.updatedAt
                    tempArticle.title = bmobObject.objectForKey("title") as! String
                    tempArticle.content = bmobObject.objectForKey("content") as! String
                    tempArticle.author = bmobObject.objectForKey("author") as? String
                    tempArticle.authorIntro = bmobObject.objectForKey("authorIntro") as? String
                    tempArticle.refer = bmobObject.objectForKey("refer") as? String
                    tempArticleLists.addObject(tempArticle)
                }
            }
        }
    }
    
}