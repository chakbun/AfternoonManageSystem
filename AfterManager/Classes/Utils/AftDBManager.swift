//
//  AftDBManager.swift
//  AfterManager
//
//  Created by Jaben on 15/11/24.
//  Copyright © 2015年 After. All rights reserved.
//

import Foundation

let QUEUE_LABEL = "com.AftManager.AftDBManager.dbQueue"
let NAME_DATABASE = "AftNoon.sqlite"
let SQL_CREATE_ARTICLE = "create table if not exists tbARTICLE ( id integer primary key autoincrement,objectId text,title text,content text,author text,refer text,authorIntro text,createAt text,updateAt text);"

class AftDBManager: NSObject {
    
    
    static let shareInstance = AftDBManager()
    
    private var dbQueue: dispatch_queue_t = dispatch_queue_create(QUEUE_LABEL, DISPATCH_QUEUE_CONCURRENT)
    private var fmDatabaseQueue: FMDatabaseQueue?
    private var fmDataBase: FMDatabase?
    private var dateFormatter: NSDateFormatter?

    override init() {
        
        super.init()
        
        let documentPath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0]
        let databasePath = documentPath + "/" + NAME_DATABASE
        
        self.dateFormatter = NSDateFormatter.init()
        self.dateFormatter?.dateFromString("yyyy-MM-dd HH:mm:ss")
        
        dispatch_async(dbQueue) { [weak self] () -> Void in
            
            if let strongSelf = self {
                strongSelf.fmDatabaseQueue = FMDatabaseQueue.init(path: databasePath)
                assert(strongSelf.fmDatabaseQueue != nil, "初始化 fmDatabaseQueue 失败")
                self?.createTableWithSQLs([SQL_CREATE_ARTICLE])
            }
        }

    }
    
    func createTableWithSQLs(sqls: NSArray) -> Void {
        dispatch_async(dbQueue) { [weak self] () -> Void in
            if let strongSelf = self {
                strongSelf.fmDatabaseQueue?.inDatabase({ (dataBase) -> Void in
                    for sql in sqls {
                        dataBase.executeStatements(sql as! String)
                    }
                })
            }
        }
    }
    
    func addArticles(articles: [AftArticle]) -> Void {
        dispatch_async(dbQueue) { [weak self] () -> Void in
            if let strongSelf = self {
                strongSelf.fmDatabaseQueue?.inDatabase({ (dataBase) -> Void in
                    
                    let sqlHead: String = "insert into tbARTICLE (objectId,title,content,author,refer,authorIntro,createAt,updateAt) values"
                    
                    for article in articles {
                        
                        let createDateString = strongSelf.dateFormatter?.stringFromDate(article.createAt)
                        let updateDateString = strongSelf.dateFormatter?.stringFromDate(article.updateAt)
                        let sqlParams: String = "('\(article.articleID)','\(article.title)','\(article.content)','\(article.author)','\(article.refer)','\(article.authorIntro)','\(createDateString)','\(updateDateString)');"
                        
                        
                        dataBase.executeUpdate(sqlHead + sqlParams, withArgumentsInArray: nil)
                        
                    }
                })
            }
        }
    }
    
    func loadArticles(completed :([AftArticle]) -> Void) -> Void {
        
        dispatch_async(dbQueue) { [weak self] () -> Void in
            
            if let strongSelf = self {
                strongSelf.fmDatabaseQueue?.inDatabase({ (dataBase) -> Void in
                    let querySQL: String = "select * from tbARTICLE"
                    let articleSet = dataBase.executeQuery(querySQL, withArgumentsInArray: nil)
                    
                    var modelArray = [AftArticle]()
                    
                    while(articleSet.next()) {
                        let tempModel: AftArticle = AftArticle()
                        tempModel.articleID = articleSet.objectForColumnName("objectId") as! String
                        tempModel.title = articleSet.objectForColumnName("title") as! String
                        tempModel.content = articleSet.objectForColumnName("content") as! String
                        tempModel.author = articleSet.objectForColumnName("author") as! String
                        tempModel.refer = articleSet.objectForColumnName("refer") as! String
                        tempModel.authorIntro = articleSet.objectForColumnName("authorIntro") as! String
                        
                        NSLog("－－》 %@", articleSet.objectForColumnName("createAt") as! String)
                        if let createAtMsg: String = articleSet.objectForColumnName("createAt") as? String  {
                            let createDate: NSDate = (strongSelf.dateFormatter?.dateFromString(createAtMsg))!
                            tempModel.createAt = createDate
                        }
                        
                        if let updateAtMsg: String = articleSet.objectForColumnName("updateAt") as? String {
                            
                            let updateDate: NSDate = (strongSelf.dateFormatter?.dateFromString(updateAtMsg))!
                            tempModel.updateAt = updateDate
                        }
                        
                        modelArray.append(tempModel)
                    }
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        completed(modelArray)
                    })
                })
            }
        }
    }
}