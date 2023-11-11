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
    
    @IBOutlet weak var loadingLabel: UILabel!
    @IBOutlet weak var thumbNailImage: UIImageView!
    
    var bidPostList: BidPostEntity?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var mediaURL = bidPostList?.MediaURL

        
        if let mediaURL = bidPostList?.MediaURL {
                    loadVideoThumbnail(from: URL(string: mediaURL)!)
                }
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
    
    func loadVideoThumbnail(from videoURL: URL) {
           DispatchQueue.global().async { [weak self] in
               guard let self = self else { return }

               let asset = AVAsset(url: videoURL)
               let assetGenerator = AVAssetImageGenerator(asset: asset)

               assetGenerator.appliesPreferredTrackTransform = true

               do {
                   let thumbnailCGImage = try assetGenerator.copyCGImage(at: CMTimeMake(value: 1, timescale: 60), actualTime: nil)
                   let thumbnailImage = UIImage(cgImage: thumbnailCGImage)

                   DispatchQueue.main.async {
                       // 비동기적으로 이미지 로딩 후 UI 업데이트
                       self.thumbNailImage.image = thumbnailImage
                       self.loadingLabel.isHidden = true
                   }
               } catch let error {
                   print("동영상 섬네일을 가져오는 데 실패했습니다: \(error.localizedDescription)")
                   // (optional) 실패 시 추가적인 처리 가능
               }
           }
       }
    
    func playVideo(from videoURL: URL) {
           let player = AVPlayer(url: videoURL)
           let playerViewController = AVPlayerViewController()

           playerViewController.player = player

           present(playerViewController, animated: true) {
               playerViewController.player?.play()
           }
       }

    @IBAction func playButton(_ sender: UIButton) {
        if let mediaURL = bidPostList?.MediaURL {
                    playVideo(from: URL(string: mediaURL)!)
                }
        
        
    }
}

