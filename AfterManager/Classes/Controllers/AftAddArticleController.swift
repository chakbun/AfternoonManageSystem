//
//  AftAddArticleController.swift
//  AfterManager
//
//  Created by Jaben on 15/11/17.
//  Copyright © 2015年 After. All rights reserved.
//

import UIKit

class AftAddArticleController: ZSSRichTextEditor {
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.title = "添加文章"
        self.edgesForExtendedLayout = UIRectEdge.Bottom
        
        let htmlHead: String = "<!-- This is an HTML comment --><p>This is a test of the <strong>ZSSRichTextEditor</strong> by <a title=\"Zed Said\" href=\"http://www.zedsaid.com\">Zed Said Studio</a></p>"
        self.setHTML(htmlHead)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
}