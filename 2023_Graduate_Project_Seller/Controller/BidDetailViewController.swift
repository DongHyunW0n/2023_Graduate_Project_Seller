//
//  BidDetailViewController.swift
//  2023_Graduate_Project_Seller
//
//  Created by WonDongHyun on 2023/05/23.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth
import AVKit
import AVFoundation

class BidDetailViewController: UIViewController {
    @IBOutlet weak var BidWritetextField: UITextView!
    @IBOutlet weak var addButton: UIButton!
    
    @IBOutlet weak var dateStackView: UIStackView!
    @IBOutlet weak var placeStackView: UIStackView!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var detailStackView: UIStackView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var placeLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    var bidListEntity: BidListEntity? // 이전 화면에서 전달된 데이터를 저장할 변수
    var bidID: String? // 선택된 셀의 ID
    var uid = Auth.auth().currentUser?.uid
    var bidSelected : String = "0" //견적이 선택되었는지 0과 1로 표시
    var companyName : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
     setUI()
        
        timeLabel.text = bidListEntity?.date
        
        
        
        
        let address = bidListEntity?.address ?? "address ERROR"
        
        func replaceNumbersWithAsterisks(in string: String) -> String {
            let numberCharacterSet = CharacterSet.decimalDigits
            let asterisk = "*"

            var result = ""
            var numberString = ""
            
            for char in string {
                if char.unicodeScalars.allSatisfy(numberCharacterSet.contains) {
                    // 숫자일 경우
                    numberString.append(char)
                } else {
                    // 숫자가 아닐 경우
                    if !numberString.isEmpty {
                        // 숫자가 있는 경우 대치
                        result.append(asterisk)
                        numberString = ""
                    }
                    result.append(char)
                }
            }
            
            if !numberString.isEmpty {
                // 문자열이 끝났는데 숫자가 있는 경우 대치
                result.append(asterisk)
            }
            
            return result
        }

        let replacedAddress = replaceNumbersWithAsterisks(in: address)
        print(replacedAddress)
        
        placeLabel.text = replacedAddress
        
        detailLabel.text = bidListEntity?.title
        
        if let mediaURL = bidListEntity?.mediaURL {
               loadVideoThumbnail(from: URL(string: mediaURL)!)
           }
        
    }
    
    @IBAction func addButtonTapped(_ sender: UIButton) {
        guard let newData = BidWritetextField.text,
              let bidID = bidID else {
            return
        }
        
        
        
        let bidRef = ref.child(bidID)
        let bidColumnRef = bidRef.child("받은 견적")
        
        // 특정 사업자의 견적 내용이 있는지 확인
        bidColumnRef.queryOrdered(byChild: "사업자UID").queryEqual(toValue: uid).observeSingleEvent(of: .value) { snapshot in
            if snapshot.exists() {
                // 이미 견적 내용이 있는 경우
                print("이미 견적을 작성했습니다.")
                
                let alertController = UIAlertController(title: "견적 보내기 실패", message: "이미 견적을 작성했습니다.", preferredStyle: .alert)
                            let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
                            alertController.addAction(okAction)
                            self.present(alertController, animated: true, completion: nil)
            } else {
                
                let ref1 = Database.database().reference()
                
                var companyName : String?
                
                ref1.child("Users").child(self.uid ?? "UID ERROR").child("name").observeSingleEvent(of: .value) { (snapshot, _) in //옵셔빙 싱글 이벤트는 한번만 받아옴.
                    if let name = snapshot.value as? String {
                        print("name: \(name)")
                        companyName = name
                        
                        bidColumnRef.childByAutoId().setValue(["사업자UID": self.uid, "견적내용": newData , "선택여부": self.bidSelected ,"회사명" : "\(companyName ?? "회사명 에러")"]) { error, _ in
                            if let error = error {
                                // 작업 실패 처리
                                print("Failed to add bid data: \(error.localizedDescription)")
                            } else {
                                // 작업 성공 처리
                                self.presentAlert()

                                print("견적 추가 완료")
                                
                                
                            }
                            
                        }
                    }
                    else{
                        print("회사명 읽어오는거 에러")
                    }
                }
              
            }
        }
    }
    
    @IBAction func playVideoButton(_ sender: UIButton) {
        
        if let mediaURL = bidListEntity?.mediaURL {
               playVideo(from: URL(string: mediaURL)!)
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
                      self.imageView.image = thumbnailImage
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
    
    fileprivate func presentAlert () {
        
        let alert = UIAlertController(title: "완료", message: "등록 완료 되었습니다." , preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
            self.navigationController?.popViewController(animated: true)
        }))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func setUI(){
        
      
    }
}





