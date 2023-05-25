//
//  MyBidListViewController.swift
//  2023_Graduate_Project_Seller
//
//  Created by WonDongHyun on 2023/05/25.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth


class MyBidListViewController: UIViewController {
    
    
    @IBOutlet weak var titleLabel: UILabel!
    
    let ref = Database.database().reference()
    let uid = Auth.auth().currentUser?.uid
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        ref.child("Users").child(self.uid ?? "UID ERROR").child("name").observeSingleEvent(of: .value) { (snapshot) in //옵셔빙 싱글 이벤트는 한번만 받아옴.
            if let name = snapshot.value as? String {
                print("name: \(name)") //회사이름
                
                
            }
            
            
            
            
            
        }
    }
}
