//
//  AftAddArticleController.swift
//  AfterManager
//
//  Created by Jaben on 15/11/17.
//  Copyright © 2015年 After. All rights reserved.
//

import UIKit

class AftAddArticleController: ZSSRichTextEditor {
    
    func aftLocalizedString(key: String)->(String) {
        let value: String = NSLocalizedString(key, comment: "没有对应的键值")
        return value
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.title = aftLocalizedString("TITLE_ADD_ARTICLE_VC")
        self.edgesForExtendedLayout = UIRectEdge.Bottom

        let htmlHead: String = "<!-- This is an HTML comment --><p>This is a test of the <strong>ZSSRichTextEditor</strong> by <a title=\"Zed Said\" href=\"http://www.zedsaid.com\">Zed Said Studio</a></p>"
        self.setHTML(htmlHead)
        
        let postArticleItem: UIBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action:"postArticleAction:")
        self.navigationItem.rightBarButtonItem = postArticleItem

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    //MARK: Button Action
    func postArticleAction(sender: AnyObject) -> Void {
        let title = "测试"
        let content = self.getHTML();
        let author = "是你吗"
        let authorInfo = "一个写嘢嘅人"
        let refer = "none link"
        
        AftBmobManager.sharedInstance.postArticleWithInfo(["title":title, "content":content, "author":author, "authorInfo":authorInfo, "refer":refer]) { (error, isSuccess) -> Void in
            
        }
    }
    
    
}