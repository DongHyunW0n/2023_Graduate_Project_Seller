//
//  ViewController.swift
//  2023_Graduate_Project_Seller
//
//  Created by WonDongHyun on 2023/05/20.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

var email = Auth.auth().currentUser?.email

struct companyEntity {
    
    var contact : String
    var name : String
    
}


class MainViewController: UIViewController {
    
    
    
   
    let uid = Auth.auth().currentUser?.uid

    @IBOutlet weak var logoutButton: UIBarButtonItem!
    
    
    @IBOutlet weak var welcomeLabel: UILabel!
    
    @IBOutlet weak var loginEmailLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("로그인 이메일 : \(email)")
        let ref = Database.database().reference()
        
        print(uid ?? "UID ERROR")
        
        
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        
        self.navigationItem.setHidesBackButton(true, animated: false) // 네비게이션 백버튼 숨기기 ~
        
        
        ref.child("Users").child(uid ?? "UID ERROR").child("name").observeSingleEvent(of: .value) { (snapshot) in //옵셔빙 싱글 이벤트는 한번만 받아옴.
            if let name = snapshot.value as? String {
                print("name: \(name)")
                self.welcomeLabel.text = "\(name) 사장님 반갑습니다 !"
            }
            else{
                self.welcomeLabel.text = "인가되지 않는 사용자입니다."
            }
        }
        
       
        
    }
    
    @IBAction func logoutButtonTabbed(_ sender: UIBarButtonItem) {
        
        let firebaseAuth = Auth.auth()
        
        
        do{
            try firebaseAuth.signOut()
            self.navigationController?.popToRootViewController(animated: true)
            
            
        }catch let sighOutError as NSError{
            
            print("ERROR : SIGNOUT \(sighOutError.localizedDescription)")
            
        }
    }
    
}

