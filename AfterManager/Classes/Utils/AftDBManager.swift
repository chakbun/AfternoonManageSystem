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
    
    fileprivate var dbQueue: DispatchQueue = DispatchQueue(label: QUEUE_LABEL, attributes: DispatchQueue.Attributes.concurrent)
    fileprivate var fmDatabaseQueue: FMDatabaseQueue?
    fileprivate var fmDataBase: FMDatabase?
    fileprivate var dateFormatter: DateFormatter?

    override init() {
        
        super.init()
        
        let documentPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0]
        let databasePath = documentPath + "/" + NAME_DATABASE
        
        self.dateFormatter = DateFormatter.init()
        
        dbQueue.async { [weak self] () -> Void in
            
            if let strongSelf = self {
                strongSelf.fmDatabaseQueue = FMDatabaseQueue.init(path: databasePath)
                assert(strongSelf.fmDatabaseQueue != nil, "初始化 fmDatabaseQueue 失败")
                self?.createTableWithSQLs([SQL_CREATE_ARTICLE])
            }
        }

    }
    
    func createTableWithSQLs(_ sqls: NSArray) -> Void {
        dbQueue.async { [weak self] () -> Void in
            if let strongSelf = self {
                strongSelf.fmDatabaseQueue?.inDatabase({ (dataBase) -> Void in
                    for sql in sqls {
                        dataBase?.executeStatements(sql as! String)
                    }
                })
            }
        }
    }
    
    func addArticles(_ articles: [AftArticle]) -> Void {
        dbQueue.async { [weak self] () -> Void in
            if let strongSelf = self {
                strongSelf.fmDatabaseQueue?.inDatabase({ (dataBase) -> Void in
                    
                    let sqlHead: String = "insert into tbARTICLE (objectId,title,content,author,refer,authorIntro,createAt,updateAt) values"
                    
                    for article in articles {
                        
                        let createDateString = strongSelf.dateFormatter?.string(from: article.createAt as Date)
                        let updateDateString = strongSelf.dateFormatter?.string(from: article.updateAt as Date)
                        let sqlParams: String = "('\(article.articleID)','\(article.title)','\(article.content)','\(article.author)','\(article.refer)','\(article.authorIntro)','\(createDateString)','\(updateDateString)');"
                        
                        
                        let addArticlesResult:Bool = dataBase!.executeUpdate(sqlHead + sqlParams, withArgumentsIn: nil)
                        print("addArticlesResult: \(addArticlesResult)")
                        if addArticlesResult == false {
                            print("last error: \(dataBase?.lastErrorMessage())")
                        }

                        
                    }
                })
            }
        }
    }
    
    func loadArticles(_ completed :@escaping ([AftArticle]) -> Void) -> Void {
        
        dbQueue.async { [weak self] () -> Void in
            
            if let strongSelf = self {
                strongSelf.fmDatabaseQueue?.inDatabase({ (dataBase) -> Void in
                    let querySQL: String = "select * from tbARTICLE"
                    let articleSet = dataBase?.executeQuery(querySQL, withArgumentsIn: nil)
                    
                    var modelArray = [AftArticle]()
                    
                    while(articleSet?.next())! {
                        let tempModel: AftArticle = AftArticle()
                        tempModel.articleID = articleSet?.object(forColumnName: "objectId") as! String
                        tempModel.title = articleSet?.object(forColumnName: "title") as! String
                        tempModel.content = articleSet?.object(forColumnName: "content") as! String
                        tempModel.author = articleSet?.object(forColumnName: "author") as! String
                        tempModel.refer = articleSet?.object(forColumnName: "refer") as! String
                        tempModel.authorIntro = articleSet?.object(forColumnName: "authorIntro") as! String
                        
                        if let createAtMsg: String = articleSet?.object(forColumnName: "createAt") as? String  {
                            let createDate: Date? = strongSelf.dateFormatter?.date(from: createAtMsg)
                            tempModel.createAt = createDate
                        }
                        
                        if let updateAtMsg: String = articleSet?.object(forColumnName: "updateAt") as? String {
                            
                            let updateDate: Date? = strongSelf.dateFormatter?.date(from: updateAtMsg)
                            tempModel.updateAt = updateDate
                        }
                        
                        modelArray.append(tempModel)
                    }
                    
                    DispatchQueue.main.async(execute: { () -> Void in
                        completed(modelArray)
                    })
                })
            }
        }
    }
}
