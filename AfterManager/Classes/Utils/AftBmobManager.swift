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
    
    //MARK: Public 
    
    func loadArticleLists(parseResultMethod: ([AftArticle]) -> Void ) -> Void {
        let bmobQuery: BmobQuery = BmobQuery(className: "table_article")
        
        bmobQuery.findObjectsInBackgroundWithBlock { (results, error) -> Void in
            
            var tempArticleLists: [AftArticle] = [AftArticle]()
            
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
                    tempArticleLists.append(tempArticle)
                }
            }
            parseResultMethod(tempArticleLists)
        }
    }
    
    func deleteArticles(articleIDs: NSArray, completed:(NSError?,Bool) -> Void) -> Void {
        let bmobQuery: BmobQuery = BmobQuery(className: "table_article")
        for articleID in articleIDs {
            bmobQuery.getObjectInBackgroundWithId(articleID as! String, block: { (responseObject, queryError) -> Void in
                if let requestQueryError = queryError {
                    print("找不到要删除的数据：\(requestQueryError)")
                    completed(queryError,false)
                }else {
                    if let deletedObject: BmobObject = responseObject {
                        deletedObject.deleteInBackgroundWithBlock({ (success, deletedError) -> Void in
                            if let requestDeletedError = deletedError {
                                print("删除的数据异常：\(requestDeletedError)")
                                completed(deletedError,false)
                            }else {
                                completed(nil,true)
                            }
                        })
                    }
                }
            })
        }
    }
    
}