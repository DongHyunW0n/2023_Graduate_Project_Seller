//
//  ChatCell.swift
//  2023_Graduate_Project_Seller
//
//  Created by WonDongHyun on 2023/06/03.
//

import UIKit

class ChatCell: UITableViewCell {

    @IBOutlet weak var bubbleStackView: UIStackView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var yourLogo: UIImageView!
    @IBOutlet weak var myLogo: UIImageView!
    @IBOutlet weak var detailLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
