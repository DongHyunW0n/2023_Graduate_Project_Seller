//
//  EnterEmailViewController.swift
//  2023_Graduate_Project_Seller
//
//  Created by WonDongHyun on 2023/05/23.
//

import UIKit
import FirebaseAuth



class EnterEmailViewController: UIViewController{
    
    
    
    @IBOutlet weak var emailTextField : UITextField!
    @IBOutlet weak var passwordTextField : UITextField!
    @IBOutlet weak var errorLabel : UILabel!
    @IBOutlet weak var nextButton : UIButton!

    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        nextButton.layer.cornerRadius = 20
        
        nextButton.isEnabled = false // 다 입력 전에는 넘어가면 안되니까 ~~
        
        emailTextField.delegate  = self
        passwordTextField.delegate = self
        
        emailTextField.becomeFirstResponder() // 화면이 켜졌을때 처음으로 커서가 이쪽으로 가게 설정

        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.isHidden = false // 앞에서 숨긴거 다시 보여줘야죠 ?
    }
    
    
    @IBAction func nextButtonTabbed(_ sender: UIButton) {
        
        
        //firebase 이메일 비밀번호 인증
        
        let email = emailTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        
        //신규 사용자 생성
        
        Auth.auth().createUser(withEmail: email, password: password) {[weak self] authResult, error in
            
            guard let self = self else{return}
            
            if let error = error{
                let code = (error as NSError).code
                switch code {
                    
                case 17007 : // 이미 아이디가 있는데?
                    let alertController = UIAlertController(title: "이미 존재하는 계정입니다", message: "확인해주세요.", preferredStyle: UIAlertController.Style.alert)

                    let okButton = UIAlertAction(title: "확인", style: UIAlertAction.Style.cancel, handler: nil)

                    alertController.addAction(okButton)
                present(alertController, animated: true)
                        loginUser(withEmail: email, password: password)
                default :
                    
                    let alertController = UIAlertController(title: "오류", message: "오류 메시지를 확인해 주세요", preferredStyle: UIAlertController.Style.alert)

                    let okButton = UIAlertAction(title: "ㅠㅠ", style: UIAlertAction.Style.cancel, handler: nil)

                    alertController.addAction(okButton)
                present(alertController, animated: true)
                    
                    self.errorLabel.text = error.localizedDescription
                }
            }else{
                
            
                let alertController = UIAlertController(title: "계정 생성 완료", message: "계정이 성공적으로 생성되었습니다", preferredStyle: UIAlertController.Style.alert)

                let okButton = UIAlertAction(title: "확인", style: UIAlertAction.Style.cancel, handler: nil)

                alertController.addAction(okButton)
                present(alertController, animated: true)
                loginUser(withEmail: email, password: password)
//                showMainViewController()

            }
            
            
            
        }
        
    }
    
    private func showMainViewController(){
        
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let mainVC = storyboard.instantiateViewController(identifier: "MainViewController")
        navigationController?.show(mainVC, sender: nil)
    }
    
    private func loginUser(withEmail email: String, password : String){
        
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] _, error in
            guard let self = self else{return}
            
            if let error = error{
                
                
                errorLabel.text = error.localizedDescription
            }
            else{
                self.showMainViewController()
            }
        }
    }
}




extension EnterEmailViewController : UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let isEmailEmpty = emailTextField.text == "" // 불형
        let isPassworkEmpty = passwordTextField.text == "" // 불형
        
        nextButton.isEnabled = !isEmailEmpty && !isPassworkEmpty  //둘다 false 일때 같아지면 true
    }
    
}
