//
//  Message.swift
//  Information
//
//  Created by Ilya Aleshin on 14.09.2018.
//  Copyright © 2018 Bakh. All rights reserved.
//

import UIKit

class Message {
    
    public var name: String
    public var text: String
    public var creationTime: String
    
    init(data d: [String:Any]) {
        self.name = d["user_name"] as! String
        self.text = d["text"] as! String
        
        let secondsSince1970: Int = Int(d["creation_time"] as! String)!
        let creationDate = Date(timeIntervalSince1970: TimeInterval(secondsSince1970))
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        self.creationTime = formatter.string(from: creationDate)
    }
    
}
