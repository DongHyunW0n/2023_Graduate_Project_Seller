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
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setView()

        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 6, bottom: 10, right: 6))
    }
    
    func setView() {
           // Cell 둥근 모서리 적용(값이 커질수록 완만)
       contentView.layer.cornerRadius = 10
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.black.cgColor
     }
    

    }
