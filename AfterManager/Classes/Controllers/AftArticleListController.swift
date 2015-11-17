//
//  AftArticleListController.swift
//  AfterManager
//
//  Created by Jaben on 15/11/17.
//  Copyright © 2015年 After. All rights reserved.
//

import UIKit


class AftArticleListController: UITableViewController {
    
    var articleList: NSMutableArray?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        articleList = NSMutableArray.init(array: [])
        
        let bmobQuery: BmobQuery = BmobQuery(className: "table_article")
        
        let loadArticleList: (results: NSArray)->() = {
            [weak self](results) -> () in
            if let strongSelf = self {
                strongSelf.articleList?.addObjectsFromArray(results as! [AftArticle])
                strongSelf.tableView.reloadData()
            }
        }
        
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
            loadArticleList(results: tempArticleLists)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    deinit {
        print("--------------deinit")
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articleList!.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let itemsReUserID: String = "articleListReUserID"
        var itemCell: UITableViewCell! = tableView.dequeueReusableCellWithIdentifier(itemsReUserID)
        if itemCell == nil {
            itemCell = UITableViewCell.init(style: UITableViewCellStyle.Default, reuseIdentifier: itemsReUserID)
        }
        let article: AftArticle = self.articleList?[indexPath.row] as! AftArticle
        itemCell.textLabel?.text = article.title
        return itemCell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
}
