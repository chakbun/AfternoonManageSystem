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
    
    func aftLocalizedString(_ key: String)->(String) {
        let value: String = NSLocalizedString(key, comment: "没有对应的键值")
        return value
    }
    
    //MARK: Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = aftLocalizedString("TITLE_ARTICLE_MENU_VC")

        let addArticleItem: UIBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonSystemItem.add, target: self, action:#selector(AftArticleListController.addArticleAction(_:)))
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
    
    func addArticleAction(_ sender: AnyObject) -> Void {
        self.performSegue(withIdentifier: "addArticleSegueID", sender: self)
//        var demoViewController: ZSSDemoViewController = ZSSDemoViewController.init()
//        self.navigationController?.pushViewController(demoViewController, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "articleDetailSegueID" {
            let destinationController = segue.destination as! AftArticleDetailController
            destinationController.title = self.selectedArticle?.title
            destinationController.article = self.selectedArticle
        }
    }
    
    //MARK: TableView Delegate
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            let deletedArticle: AftArticle = (self.articleList?[(indexPath as NSIndexPath).row])!
            
            AftBmobManager.sharedInstance.deleteArticles(articleIDs: [deletedArticle.articleID], completed: { (error, success) -> Void in
                if success {
                    self.articleList?.remove(at: (indexPath as NSIndexPath).row)
                    self.tableView.reloadData()
                }
            })

        }
    }
    
    //MARK: TableView DataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articleList!.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let itemsReUserID: String = "articleListReUserID"
        var itemCell: UITableViewCell! = tableView.dequeueReusableCell(withIdentifier: itemsReUserID)
        if itemCell == nil {
            itemCell = UITableViewCell.init(style: UITableViewCellStyle.default, reuseIdentifier: itemsReUserID)
        }
        let article: AftArticle = (self.articleList?[(indexPath as NSIndexPath).row])!
        itemCell.textLabel?.text = article.title
        return itemCell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedArticle = (self.articleList?[(indexPath as NSIndexPath).row])!
        self.performSegue(withIdentifier: "articleDetailSegueID", sender: self)
    }
}
