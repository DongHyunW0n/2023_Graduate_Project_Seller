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
    var title: String
    var address: String
    var MediaURL: String
    var date: String
    var number: String
}

struct FinishedEntity {
    var bidId: String
    var postID: String
    var detail: String
}

struct BidPostEntity {
    var title: String
    var address: String
    var MediaURL: String
    var date: String
    var number: String
}

class MyBidListViewController: UIViewController {
    var myBidList: [FinishedEntity] = []
    var bidPostList: [BidPostEntity] = []

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
        ref.child("Users").child(self.uid ?? "UID ERROR").child("name").observeSingleEvent(of: .value) { (snapshot) in
            if let name = snapshot.value as? String {
                print("name: \(name)") // 회사이름

                companyName = name
                self.titleLabel.text = "\(name) 사장님께서 낙찰받으신 내역입니다."

                self.fetchFinishedBids(for: companyName)
            }
        }
    }

    func fetchFinishedBids(for companyName: String) {
        ref.child("FinishedBid").child("\(companyName)").observe(.value) { snapshot in
            var finishedBids: [FinishedEntity] = []
            var bidPosts: [BidPostEntity] = []

            for child in snapshot.children {
                guard let childSnapshot = child as? DataSnapshot else { return }
                let value = childSnapshot.value as? NSDictionary
                let title = value?["상세 설명"] as? String ?? ""
                let bidID = value?["bidID"] as? String ?? ""
                let postID = value?["postID"] as? String ?? ""

                let fetchedBid = FinishedEntity(bidId: bidID, postID: postID, detail: title)
                finishedBids.append(fetchedBid)
                print(fetchedBid)

                self.ref.child("ServiceRequest").child(postID).observeSingleEvent(of: .value) { postSnapshot in
                    if let postValue = postSnapshot.value as? NSDictionary {
                        let postTitle = postValue["상세 설명"] as? String ?? ""
                        let postAddress = postValue["요청 위치"] as? String ?? ""
                        let postImageURL = postValue["MediaURL"] as? String ?? ""
                        let postDate = postValue["요청 일시"] as? String ?? ""
                        let postNumber = postValue["연락처"] as? String ?? ""

                        let bidPost = BidPostEntity(title: postTitle, address: postAddress, MediaURL: postImageURL, date: postDate, number: postNumber)
                        bidPosts.append(bidPost)
                        print(bidPosts)

                        if bidPosts.count == finishedBids.count {
                            self.bidPostList = bidPosts
                            self.tableView.reloadData()
                        }
                    }
                }
            }

            self.myBidList = finishedBids
        }
    }
}

extension MyBidListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myBidList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! MyBidListCell

        let bid = myBidList[indexPath.row]
        let bidPost = bidPostList[indexPath.row]

        cell.titleLabel.text = "\(bidPost.title)"
        cell.addressLabel.text = bidPost.address
        cell.timeLabel.text = "방문 :\(bidPost.date)"
        cell.numberLabel.text = "\(bidPost.number)"
        

        cell.selectionStyle = .none

        // 다른 셀 속성 설정

        return cell
    }
}

extension MyBidListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        

        
        let selectedBid = bidPostList[indexPath.row]
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let bidDetailVC = storyboard.instantiateViewController(withIdentifier: "MyBidListDetailViewController") as? MyBidListDetailViewController {
            bidDetailVC.bidPostList = selectedBid
            
           
            navigationController?.pushViewController(bidDetailVC, animated: true)
            
            
            
        }
        
    }
}
