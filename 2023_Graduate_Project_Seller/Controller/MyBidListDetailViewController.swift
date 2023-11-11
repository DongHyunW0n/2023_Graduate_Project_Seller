//
//  MyBidListDetailViewController.swift
//  2023_Graduate_Project_Seller
//
//  Created by WonDongHyun on 2023/05/30.
//

import UIKit
import AVKit
import AVFoundation

class MyBidListDetailViewController: UIViewController {

    @IBOutlet weak var placeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    
    @IBOutlet weak var thumbNailImage: UIImageView!
    
    var bidPostList: BidPostEntity?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        if let imageURL = bidPostList?.imageURL {
//            imageView.loadImageFromURL(imageURL)
//        }
        updateUI()

    }
    

    func updateUI() {
            if let bidPost = bidPostList {
                placeLabel.text = bidPost.address // 주소 설정
                dateLabel.text = bidPost.date // 날짜 설정
                detailLabel.text = bidPost.title // 상세 설명 설정
                numberLabel.text = bidPost.number // 연락처 설정
            }
        }

    @IBAction func playButton(_ sender: UIButton) {
        
        
        
    }
}


extension UIImageView {
    func loadImageFromURL1(_ urlString: String) {
        guard let url = URL(string: urlString) else {
            // 유효하지 않은 URL 처리
            return
        }
        
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
