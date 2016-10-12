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
        
        let editButtonItem: UIBarButtonItem = UIBarButtonItem.init(title: "操作", style: UIBarButtonItemStyle.plain, target: self, action: #selector(AftArticleDetailController.editBarButtonAction(_:)))
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
    
    func editBarButtonAction(_ sender: AnyObject) {
        let editActionSheet: UIAlertController = UIAlertController.init(title: "选择操作", message: "", preferredStyle: UIAlertControllerStyle.actionSheet)
        editActionSheet.addAction(UIAlertAction.init(title: "修改", style: UIAlertActionStyle.destructive, handler: { (alertAction) -> Void in
            
        }))
        
        editActionSheet.addAction(UIAlertAction.init(title: "删除", style: UIAlertActionStyle.default, handler: { (alertAction) -> Void in
            
        }))
        
        editActionSheet.addAction(UIAlertAction.init(title: "取消", style: UIAlertActionStyle.cancel, handler: { (alertAction) -> Void in
            
        }))
        
        self .present(editActionSheet, animated: true, completion: nil)
        
    }
    
    
}
