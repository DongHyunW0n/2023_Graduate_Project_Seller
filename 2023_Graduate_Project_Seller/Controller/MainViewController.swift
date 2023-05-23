//
//  ViewController.swift
//  2023_Graduate_Project_Seller
//
//  Created by WonDongHyun on 2023/05/20.
//

import UIKit
import Firebase
import FirebaseAuth

var email = Auth.auth().currentUser?.email


class MainViewController: UIViewController {

    @IBOutlet weak var loginEmailLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        
        loginEmailLabel.text = "로그인한 계정 :\(email ?? "ERROR")"
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
       
        self.navigationItem.setHidesBackButton(true, animated: false) // 네비게이션 백버튼 숨기기 ~

    }


}

