//
//  BidViewController.swift
//  2023_Graduate_Project_Seller
//
//  Created by WonDongHyun on 2023/05/21.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

struct BidListEntity {
    
    var id : String
    var title : String
    var address : String
    var imageURL : String
    var date : String
    
    
}

let ref = Database.database().reference().child("ServiceRequest")

class BidViewController: UIViewController {
    
    var BidList : [BidListEntity] = []

    @IBOutlet weak var tableView: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        ref.observeSingleEvent(of: .value, with: { (snapshot) in
//
//            for child in snapshot.children {
//
//                let snap = child as! DataSnapshot
//                if Dictionary["서비스 요청자 uid"] as! String ==
//            }
            
            
            
            
            
            
        })
        ref.observe(.value) {snapshot in
            
            
            self.BidList = []
            
            for child in snapshot.children {
                
                guard let childSnapshot = child as? DataSnapshot else{return}
                let value = childSnapshot.value as? NSDictionary
                let title = value?["상세 설명"] as? String ?? ""
                let address = value?["주소"]as? String ?? ""
                let URL = value?["사진 URL"]as? String ?? ""
                let date = value?["요청 일시"]as? String ?? ""
                
                let fetchedBidList = BidListEntity(id: childSnapshot.key, title: title, address: address, imageURL: URL, date: date)
                
                self.BidList.append(fetchedBidList)
                print(fetchedBidList)
            }
            
            self.tableView.reloadData()
            
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
