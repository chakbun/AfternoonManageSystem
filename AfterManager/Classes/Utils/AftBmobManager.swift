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
    
    func loadArticleLists(parseResultMethod: @escaping ([AftArticle]) -> Void ) -> Void {
        let bmobQuery: BmobQuery = BmobQuery(className: "table_article")
        
        bmobQuery.findObjectsInBackground { (results, error) in
            var tempArticleLists: [AftArticle] = [AftArticle]()
            for bmobObject in results! {
                
                if bmobObject is BmobObject {
                    let tempArticle: AftArticle = AftArticle.init()
                    tempArticle.articleID = (bmobObject as! BmobObject).objectId
                    tempArticle.createAt = (bmobObject as! BmobObject).createdAt
                    tempArticle.updateAt = (bmobObject as! BmobObject).updatedAt
                    tempArticle.title = (bmobObject as! BmobObject).object(forKey: "title") as! String
                    tempArticle.content =  (bmobObject as! BmobObject).object(forKey: "content") as! String
                    tempArticle.author =  (bmobObject as! BmobObject).object(forKey: "author") as? String
                    tempArticle.authorIntro =  (bmobObject as! BmobObject).object(forKey: "authorIntro") as? String
                    tempArticle.refer =  (bmobObject as! BmobObject).object(forKey: "refer") as? String
                    tempArticleLists.append(tempArticle)
                }
            }
            parseResultMethod(tempArticleLists)
        }
        
    }
    
    func deleteArticles(articleIDs: NSArray, completed: @escaping (NSError?,Bool) -> Void) -> Void {
        let bmobQuery: BmobQuery = BmobQuery(className: "table_article")
        for articleID in articleIDs {
            bmobQuery.getObjectInBackground(withId: articleID as! String, block: { (responseObject, queryError) -> Void in
                if let requestQueryError = queryError {
                    print("找不到要删除的数据：\(requestQueryError)")
                    completed(queryError as NSError?,false)
                }else {
                    if let deletedObject: BmobObject = responseObject {
                        deletedObject.deleteInBackground({ (success, deletedError) -> Void in
                            if let requestDeletedError = deletedError {
                                print("删除的数据异常：\(requestDeletedError)")
                                completed(deletedError as NSError?,false)
                            }else {
                                completed(nil,true)
                            }
                        })
                    }
                }
            })
        }
    }
    
    func postArticleWithInfo(info: NSDictionary, completed: @escaping (NSError?, Bool) -> Void) -> Void {
        
        let articleModel: BmobObject = BmobObject.init(className: "table_article")
        
        articleModel.setObject(info["title"], forKey: "title")
        articleModel.setObject(info["content"], forKey: "content")
        articleModel.setObject(info["author"], forKey: "author")
        articleModel.setObject(info["authorIntro"], forKey: "authorIntro")
        articleModel.setObject(info["refer"], forKey: "refer")
        
        articleModel.saveInBackground { (result, Error) in
            completed(Error as NSError?, result)
        }
    }
    
}
