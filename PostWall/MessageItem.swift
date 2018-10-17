//
//  MessageItem.swift
//  Information
//
//  Created by Ilya Aleshin on 14.09.2018.
//  Copyright © 2018 Bakh. All rights reserved.
//

import UIKit

class MessageItem: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var messageTextLabel: UILabel!
    
    public func setMessage(m: Message) {
        nameLabel.text = m.name
        dateLabel.text = m.creationTime
        messageTextLabel.text = m.text
    }
    
}
