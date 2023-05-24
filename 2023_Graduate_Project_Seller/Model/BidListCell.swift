//
//  Cell.swift
//  2023_Graduate_Project_Seller
//
//  Created by WonDongHyun on 2023/05/20.
//

import Foundation
import UIKit

class BidListCell : UITableViewCell {
    
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    
    override func awakeFromNib() {
            super.awakeFromNib()
            
            // 셀 간격 설정
        let spacing: CGFloat = 30.0
            let margins = contentView.layoutMarginsGuide
            NSLayoutConstraint.activate([
                contentView.topAnchor.constraint(equalTo: margins.topAnchor, constant: spacing),
                contentView.bottomAnchor.constraint(equalTo: margins.bottomAnchor, constant: -spacing)
            ])
        }
    }
