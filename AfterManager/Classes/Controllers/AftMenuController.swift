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
    
    func aftLocalizedString(_ key: String)->(String) {
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
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemsTitle!.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let itemsReUserID: String = "menuReUserID"
        var itemCell: UITableViewCell! = tableView.dequeueReusableCell(withIdentifier: itemsReUserID)
        if itemCell == nil {
            itemCell = UITableViewCell.init(style: UITableViewCellStyle.default, reuseIdentifier: itemsReUserID)
        }
        itemCell.textLabel?.text = itemsTitle![(indexPath as NSIndexPath).row] as? String
        itemCell.selectionStyle = UITableViewCellSelectionStyle.none
        return itemCell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let SEGUE_NAMES: NSArray = ["articleVcSegueID","imageVcSegueID"];
        
        self.performSegue(withIdentifier: SEGUE_NAMES[(indexPath as NSIndexPath).row] as! String, sender: self)
    }
    
}
