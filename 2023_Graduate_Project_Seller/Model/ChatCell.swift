//
//  ChatCell.swift
//  2023_Graduate_Project_Seller
//
//  Created by WonDongHyun on 2023/06/03.
//

import UIKit

class ChatCell: UITableViewCell {

    
    
    @IBOutlet weak var chatBubble: UIView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()

        self.selectionStyle = .none
        self.chatBubble.backgroundColor = UIColor.systemYellow.withAlphaComponent(0.2)
        self.chatBubble.layer.cornerRadius = 8
        

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
