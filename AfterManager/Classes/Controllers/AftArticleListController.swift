//
//  AftArticleListController.swift
//  AfterManager
//
//  Created by Jaben on 15/11/17.
//  Copyright © 2015年 After. All rights reserved.
//

import UIKit


class AftArticleListController: UITableViewController {
    
    var articleList:  [AftArticle]?
    var selectedArticle: AftArticle?
    
    func aftLocalizedString(key: String)->(String) {
        let value: String = NSLocalizedString(key, comment: "没有对应的键值")
        return value
    }
    
    //MARK: Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = aftLocalizedString("TITLE_ARTICLE_MENU_VC")

        let addArticleItem: UIBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action:"addArticleAction:")
        self.navigationItem.rightBarButtonItem = addArticleItem
        
        articleList = [AftArticle]();
        
        AftDBManager.shareInstance.loadArticles { [weak self] (localArticles) -> Void in
            if let strongSelf = self {
                if localArticles.count > 0 {
                    strongSelf.articleList = localArticles
                    strongSelf.tableView.reloadData()
                }else {
                    AftBmobManager.sharedInstance.loadArticleLists { [weak self] (articles) -> Void in
                        if let strongSelf = self {
                            strongSelf.articleList = strongSelf.articleList! + articles
                            AftDBManager.shareInstance.addArticles(strongSelf.articleList!)
                            strongSelf.tableView.reloadData()
                        }
                    }
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: Public
    
    func addArticleAction(sender: AnyObject) -> Void {
        self.performSegueWithIdentifier("addArticleSegueID", sender: self)
//        var demoViewController: ZSSDemoViewController = ZSSDemoViewController.init()
//        self.navigationController?.pushViewController(demoViewController, animated: true)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "articleDetailSegueID" {
            let destinationController = segue.destinationViewController as! AftArticleDetailController
            destinationController.title = self.selectedArticle?.title
            destinationController.article = self.selectedArticle
        }
    }
    
    //MARK: TableView Delegate
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            let deletedArticle: AftArticle = (self.articleList?[indexPath.row])!
            
            AftBmobManager.sharedInstance.deleteArticles([deletedArticle.articleID], completed: { (error, success) -> Void in
                if success {
                    self.articleList?.removeAtIndex(indexPath.row)
                    self.tableView.reloadData()
                }
            })

        }
    }
    
    //MARK: TableView DataSource
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articleList!.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let itemsReUserID: String = "articleListReUserID"
        var itemCell: UITableViewCell! = tableView.dequeueReusableCellWithIdentifier(itemsReUserID)
        if itemCell == nil {
            itemCell = UITableViewCell.init(style: UITableViewCellStyle.Default, reuseIdentifier: itemsReUserID)
        }
        let article: AftArticle = (self.articleList?[indexPath.row])!
        itemCell.textLabel?.text = article.title
        return itemCell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.selectedArticle = (self.articleList?[indexPath.row])!
        self.performSegueWithIdentifier("articleDetailSegueID", sender: self)
    }
}
