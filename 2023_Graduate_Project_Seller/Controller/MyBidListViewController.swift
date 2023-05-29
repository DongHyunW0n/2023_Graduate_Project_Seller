//
//  MyBidListViewController.swift
//  2023_Graduate_Project_Seller
//
//  Created by WonDongHyun on 2023/05/25.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

struct MyBidListEntity {
    
    var title : String
    var address : String
    var imageURL : String
    var date : String
    var number : String
    
    
}

struct FinishedEntity {
    
    var bidId : String
    var postID : String
    var detail : String
    
}



class MyBidListViewController: UIViewController {
    
    var myBidList : [MyBidListEntity] = []
    var myFinishedListEntity : [FinishedEntity] = []
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleLabel: UILabel!
    
    
    
    let ref = Database.database().reference()
    let uid = Auth.auth().currentUser?.uid
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        
        titleLabel.layer.cornerRadius = 20
        
        var companyName = "동서철물"
        ref.child("Users").child(self.uid ?? "UID ERROR").child("name").observeSingleEvent(of: .value) { (snapshot) in //옵셔빙 싱글 이벤트는 한번만 받아옴.
            if let name = snapshot.value as? String {
                print("name: \(name)") //회사이름
                
                companyName = name
                self.titleLabel.text = "\(name) 사장님께서 낙찰받으신 내역은 다음과 같습니다."
                
                
            }
            
        }
        
        print("회사의 이름은 \(companyName)")
        
        
        
        
        
        
        
        
        ref.child("FinishedBid").child("\(companyName)").observe(.value) {snapshot in
            
            
            
            
            self.myFinishedListEntity = []
            
            for child in snapshot.children {
                
                guard let childSnapshot = child as? DataSnapshot else{return}
                let value = childSnapshot.value as? NSDictionary
                let bidID = value?["bidID"] as? String ?? ""
                let postID = value?["postID"]as? String ?? ""
                let detail = value?["상세 설명"]as? String ?? ""
                
                let fetchedBidList = FinishedEntity(bidId: bidID, postID: postID, detail: detail)
                self.myFinishedListEntity.append(fetchedBidList)
            
                print("내가 확정받은 견적의 개수 : \(self.myFinishedListEntity.count)")
                
                print("확정된 견적들에 대한 딕셔너리 값들 :  \(self.myFinishedListEntity)")
                
                


                
//                self.ref.child("ServiceRequest").child("\(mypostID)").observe(.value) {snapshot in
//
//
//                    self.myBidList = []
//
//                    for child in snapshot.children {
//
//                        guard let childSnapshot = child as? DataSnapshot else{return}
//                        let value = childSnapshot.value as? NSDictionary
//                        let title = value?["상세 설명"] as? String ?? ""
//                        let address = value?["요청 위치"]as? String ?? ""
//                        let imageURL = value?["사진 URL"]as? String ?? ""
//                        let date = value?["요청 일시"]as? String ?? ""
//                        let number = value?["연락처"]as? String ?? ""
//
//                        let fetchedMyBidList = MyBidListEntity(title: title, address: address, imageURL: imageURL, date: date, number: number)
//
//                        self.myBidList.append(fetchedMyBidList)
//
//                        print("확정된 견적에 대한 데이터는 \(fetchedMyBidList)")
//        //                print(fetchedBidList)
//                    }
//
////                    self.tableView.reloadData()
//
//                }
                
                
                
                
                
                
            }
            
            
        }
        
        
        
        
    }
}


extension MyBidListViewController : UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return
    }
    
    
}

extension MyBidListViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
