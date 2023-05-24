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
    
    @IBOutlet weak var dateStackView: UIStackView!
    @IBOutlet weak var placeStackView: UIStackView!
    @IBOutlet weak var detailLabel: UITextView!
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
        
        BidWritetextField.layer.borderWidth = 1.0 // 경계선 두께 설정

        BidWritetextField.layer.borderColor = UIColor.systemGray3.cgColor
        
        placeStackView.layer.borderWidth = 0.5 // 경계선 두께 설정

        placeStackView.layer.borderColor = UIColor.systemGray3.cgColor
        placeStackView.layer.cornerRadius = 10
        
        dateStackView.layer.borderWidth = 0.5 // 경계선 두께 설정

        dateStackView.layer.borderColor = UIColor.systemGray3.cgColor
        dateStackView.layer.cornerRadius = 10
        
        detailStackView.layer.borderWidth = 0.5 // 경계선 두께 설정

        detailStackView.layer.borderColor = UIColor.systemGray3.cgColor
        detailStackView.layer.cornerRadius = 10
        
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
                    }
                    else{
                        print("회사명 읽어오는거 에러")
                    }
                }
                // 견적 추가
                bidColumnRef.childByAutoId().setValue(["사업자UID": self.uid, "견적내용": newData , "선택여부": self.bidSelected ,"회사명" : "\(companyName ?? "회사명 에러")"]) { error, _ in
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


