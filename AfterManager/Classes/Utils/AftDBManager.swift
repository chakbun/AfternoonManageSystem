//
//  AftDBManager.swift
//  AfterManager
//
//  Created by Jaben on 15/11/24.
//  Copyright © 2015年 After. All rights reserved.
//

import Foundation

let QUEUE_LABEL = "com.AftManager.AftDBManager.dbQueue"

class AftDBManager: NSObject {
    
    private var dbQueue: dispatch_queue_t = dispatch_queue_create(QUEUE_LABEL, DISPATCH_QUEUE_CONCURRENT)
    
    private var fmDatabaseQueue: FMDatabaseQueue?
    
    class var  shareInstance: AftDBManager {
        struct Static {
            static let instance: AftDBManager = AftDBManager()
        }
        
        
        
        return Static.instance
    }
    
}