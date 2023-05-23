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
        
    
        tableView.dataSource = self
        tableView.delegate = self
        
        ref.observe(.value) {snapshot in
            
            
            self.BidList = []
            
            for child in snapshot.children {
                
                guard let childSnapshot = child as? DataSnapshot else{return}
                let value = childSnapshot.value as? NSDictionary
                let title = value?["상세 설명"] as? String ?? ""
                let address = value?["요청 위치"]as? String ?? ""
                let URL = value?["사진 URL"]as? String ?? ""
                let date = value?["요청 일시"]as? String ?? ""
                
                let fetchedBidList = BidListEntity(id: childSnapshot.key, title: title, address: address, imageURL: URL, date: date)
                
                self.BidList.append(fetchedBidList)
            
                print(title)
//                print(fetchedBidList)
            }
            
            self.tableView.reloadData()
            
        }
    }
}

public func somefunc(){
    
    
}



extension BidViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return BidList.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as? BidListCell else {
            return UITableViewCell()
        }
        
        let celldata : BidListEntity = BidList[indexPath.row]
        cell.titleLabel.text = celldata.title
        cell.addressLabel.text = celldata.address
        cell.selectionStyle = .none
        return cell
    }

    
    
}

extension BidViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print(BidList[indexPath.row])
        
        let selectedBid = BidList[indexPath.row]
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let bidDetailVC = storyboard.instantiateViewController(withIdentifier: "BidDetailViewController") as? BidDetailViewController {
            bidDetailVC.bidListEntity = selectedBid
            bidDetailVC.bidID = selectedBid.id
            navigationController?.pushViewController(bidDetailVC, animated: true)
            
            
            
        }
    }
}
    
    
