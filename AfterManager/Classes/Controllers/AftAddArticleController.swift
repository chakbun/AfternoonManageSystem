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
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
}