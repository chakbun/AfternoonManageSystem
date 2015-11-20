//
//  AftMenuController.swift
//  AfterManager
//
//  Created by Jaben on 15/11/17.
//  Copyright © 2015年 After. All rights reserved.
//

import Foundation
import UIKit

class AftMenuContrller: UITableViewController {
    
    var itemsTitle: NSArray?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "午后Afternoon后台";
        itemsTitle = ["文章","图片"]
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()   
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemsTitle!.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let itemsReUserID: String = "menuReUserID"
        var itemCell: UITableViewCell! = tableView.dequeueReusableCellWithIdentifier(itemsReUserID)
        if itemCell == nil {
            itemCell = UITableViewCell.init(style: UITableViewCellStyle.Default, reuseIdentifier: itemsReUserID)
        }
        itemCell.textLabel?.text = itemsTitle![indexPath.row] as? String
        itemCell.selectionStyle = UITableViewCellSelectionStyle.None
        return itemCell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let SEGUE_NAMES: NSArray = ["articleVcSegueID","imageVcSegueID"];
        
        self.performSegueWithIdentifier(SEGUE_NAMES[indexPath.row] as! String, sender: self)
    }
    
}