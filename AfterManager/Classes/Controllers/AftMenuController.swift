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
    
    func aftLocalizedString(key: String)->(String) {
        let value: String = NSLocalizedString(key, comment: "没有对应的键值")
        return value
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = aftLocalizedString("TITLE_MENU_VC")
        itemsTitle = [aftLocalizedString("TITLE_ARTICLE_MENU_VC"),aftLocalizedString("TITLE_ALBUM_MENU_VC")]
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