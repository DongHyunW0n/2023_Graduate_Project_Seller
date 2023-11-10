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
        
        ref.observe(.value) { snapshot in
            self.BidList = []
            
            for child in snapshot.children {
                guard let childSnapshot = child as? DataSnapshot else { return }
                let value = childSnapshot.value as? NSDictionary
                let isFinished = value?["끝남 여부"] as? String ?? ""
                
                if isFinished == "1" {
                    continue // 끝남 여부가 1인 경우, 리스트에 추가하지 않고 다음 데이터로 넘어감
                }
                
                let title = value?["상세 설명"] as? String ?? ""
                let address = value?["요청 위치"] as? String ?? ""
                let URL = value?["사진 URL"] as? String ?? ""
                let date = value?["요청 일시"] as? String ?? ""
                
                let fetchedBidList = BidListEntity(id: childSnapshot.key, title: title, address: address, imageURL: URL, date: date)
                self.BidList.append(fetchedBidList)
                
                print(title)
            }
            
            self.tableView.reloadData()
        }
    }
}

public func somefunc(){
    
    
}



extension BidViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return BidList.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as? BidListCell else {
            return UITableViewCell()
        }
        cell.layer.cornerRadius = 10
        
        let celldata : BidListEntity = BidList[indexPath.row]
        cell.titleLabel.text = celldata.title
        
        let address = celldata.address
        
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

        cell.addressLabel.text = replacedAddress
        cell.dateLabel.text = "희망 : \(celldata.date)"
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
    
    

