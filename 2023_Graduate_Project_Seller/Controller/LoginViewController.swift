//
//  LoginViewController.swift
//  2023_Graduate_Project_Seller
//
//  Created by WonDongHyun on 2023/05/23.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var emailLoginButton: UIButton!
    
    @IBOutlet weak var googleLoginButton: UIButton!
    
    @IBOutlet weak var appleLoginButton: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
      
        
        
        

        
        
     
       
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        self.navigationController?.navigationBar.isHidden = true
        //네비바 숨기기
    }
    

    @IBAction func googleLoginButtonTabbed(_ sender: UIButton) {
        
        //Firabase
        
    }
    
    @IBAction func appleLoginButtonTabbed(_ sender: UIButton) {
    }
    
    //Firebase
}

