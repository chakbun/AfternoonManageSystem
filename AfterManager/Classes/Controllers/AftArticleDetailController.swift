//
//  AftArticleDetailController.swift
//  AfterManager
//
//  Created by Jaben on 15/11/17.
//  Copyright © 2015年 After. All rights reserved.
//

import UIKit

class AftArticleDetailController: UIViewController {
    
    @IBOutlet weak var contentWebView: UIWebView!
    
    var article: AftArticle?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let editButtonItem: UIBarButtonItem = UIBarButtonItem.init(title: "操作", style: UIBarButtonItemStyle.Plain, target: self, action: "editBarButtonAction:")
        self.navigationItem.rightBarButtonItem = editButtonItem
        
        if let tempArticle = article {
            contentWebView.loadHTMLString(tempArticle.content, baseURL: nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    deinit {
        print("--------------deinit\( NSStringFromClass(self.classForCoder))")
    }
    
    func editBarButtonAction(sender: AnyObject) {
        let editActionSheet: UIAlertController = UIAlertController.init(title: "选择操作", message: "", preferredStyle: UIAlertControllerStyle.ActionSheet)
        editActionSheet.addAction(UIAlertAction.init(title: "修改", style: UIAlertActionStyle.Destructive, handler: { (alertAction) -> Void in
            
        }))
        
        editActionSheet.addAction(UIAlertAction.init(title: "删除", style: UIAlertActionStyle.Default, handler: { (alertAction) -> Void in
            
        }))
        
        editActionSheet.addAction(UIAlertAction.init(title: "取消", style: UIAlertActionStyle.Cancel, handler: { (alertAction) -> Void in
            
        }))
        
        self .presentViewController(editActionSheet, animated: true, completion: nil)
        
    }
    
    
}