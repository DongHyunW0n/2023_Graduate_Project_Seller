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

class BidDetailViewController: UIViewController {
    @IBOutlet weak var BidWritetextField: UITextView!
    @IBOutlet weak var addButton: UIButton!
    
    @IBOutlet weak var detailLabel: UITextView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var placeLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    var bidListEntity: BidListEntity? // 이전 화면에서 전달된 데이터를 저장할 변수
    var bidID: String? // 선택된 셀의 ID
    var uid = Auth.auth().currentUser?.uid
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        timeLabel.text = bidListEntity?.date
        placeLabel.text = bidListEntity?.address
        detailLabel.text = bidListEntity?.title
        
        if let imageURL = bidListEntity?.imageURL {
            imageView.loadImageFromURL(imageURL)
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
        bidColumnRef.queryOrdered(byChild: "사업자UID").queryEqual(toValue: bidID).observeSingleEvent(of: .value) { snapshot in
            if snapshot.exists() {
                // 이미 견적 내용이 있는 경우
                print("이미 견적을 작성했습니다.")
                
                let alertController = UIAlertController(title: "견적 보내기 실패", message: "이미 견적을 작성했습니다.", preferredStyle: .alert)
                            let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
                            alertController.addAction(okAction)
                            self.present(alertController, animated: true, completion: nil)
            } else {
                // 견적 추가
                bidColumnRef.childByAutoId().setValue(["사업자UID": bidID, "견적내용": newData]) { error, _ in
                    if let error = error {
                        // 작업 실패 처리
                        print("Failed to add bid data: \(error.localizedDescription)")
                    } else {
                        // 작업 성공 처리
                        print("견적 추가 완료")
                        
                        // 추가 작업 완료 후 필요한 후속 작업 수행
                    }
                    
                }
            }
        }
    }
}


extension UIImageView {
    func loadImageFromURL(_ urlString: String) {
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


