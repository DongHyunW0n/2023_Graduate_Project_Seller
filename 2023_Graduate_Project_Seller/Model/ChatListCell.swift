//
//  ChatListCell.swift
//  2023_Graduate_Project_Seller
//
//  Created by WonDongHyun on 2023/06/03.
//


import UIKit

class ChatListCell: UITableViewCell {

    @IBOutlet weak var companyLabel: UILabel!
    
    @IBOutlet weak var detailLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
