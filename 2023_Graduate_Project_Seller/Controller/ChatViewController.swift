//
//  ChatViewController.swift
//  2023_Graduate_Project
//
//  Created by WonDongHyun on 2023/06/01.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

struct ChatMessageEntity {
    
    var sender : String
    var receiver : String
    var message : String
    var timeStamp : String
    
    
}



class ChatViewController: UIViewController {
    
    var chatList: [ChatMessageEntity] = []

    
    @IBOutlet weak var tableView: UITableView!
    var postID : String?
    
    let ref = Database.database().reference()
    
    let uid = Auth.auth().currentUser?.uid

    @IBOutlet weak var chatTableView: UITableView!
    
    @IBOutlet weak var messageTextField: UITextField!
    
    @IBOutlet weak var messageSendButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        print(postID ?? "postID ERROR")
        
        chatTableView.dataSource = self
       
        let nibName1 = UINib(nibName: "ChatCell", bundle: nil)
        chatTableView.register(nibName1, forCellReuseIdentifier: "Cell1")

        let nibName2 = UINib(nibName: "ChatCellSender", bundle: nil)
        chatTableView.register(nibName2, forCellReuseIdentifier: "Cell2")

        
        
        let chatRoomRef = ref.child("Chat").child(postID ?? "postID ERROR").child("ChatDetail")
        
        
        chatRoomRef.observe(.value) { [weak self] snapshot in
            guard let self = self else { return }
            
            self.chatList.removeAll() // 기존의 채팅 내용을 모두 제거

            
            for child in snapshot.children {
                guard let childSnapshot = child as? DataSnapshot else { continue }
                let chatDetail = childSnapshot.value as? [String: Any]
                
                let timestampString = childSnapshot.key
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                let timestampDate = dateFormatter.date(from: timestampString)
                                
                let timestamp = dateFormatter.string(from: timestampDate ?? Date())

                let sender = chatDetail?["Sender"] as? String ?? ""
                let detail = chatDetail?["detail"] as? String ?? ""
                let receiver = chatDetail?["Receiver"] as? String ?? ""
                
                let chat = ChatMessageEntity(sender: sender, receiver: receiver, message: detail, timeStamp: timestamp)
                chatList.append(chat)
            }
            
            self.chatTableView.reloadData()
            print(chatList)
        }
    
        
        
        

        
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        scrollToBottom() // 뷰가 나타난 후에도 스크롤을 최하단으로 이동
    }
    
    
    func getCurrentTimestamp() -> String {
          let currentDate = Date()
          let formatter = DateFormatter()
          formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
          let timestamp = formatter.string(from: currentDate)
          return timestamp
      }

    
    func scrollToBottom() {
        DispatchQueue.main.async {
            let lastRow = self.chatList.count - 1
            if lastRow >= 0 {
                let indexPath = IndexPath(row: lastRow, section: 0)
                self.chatTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
            }
        }
    }

    
    
    
    
    @IBAction func sendButtonTabbed(_ sender: UIButton) {
        
        //기존에 있는 chatroom 에 내용 추가
        
        guard let messageText = messageTextField.text, !messageText.isEmpty else {
              showAlert(message: "메시지를 입력해주세요.")
              return
          }
          
          // 기존에 있는 chatroom에 내용 추가
          let chatRoomRef = ref.child("Chat").child(postID ?? "postID ERROR").child("ChatDetail")
        chatRoomRef.child(getCurrentTimestamp()).setValue(["Sender": uid ?? "unknown sender", "detail": messageText, "Receiver": ""] as [String: Any])
          
          messageTextField.text = ""
        scrollToBottom() // 메시지 전송 후 스크롤을 최하단으로 이동
      }

      func showAlert(message: String) {
          
          let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
          let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
          alertController.addAction(okAction)
          present(alertController, animated: true, completion: nil)
  
    }
    
    
    
    

}

extension ChatViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let celldata: ChatMessageEntity = chatList[indexPath.row]

        
        let cellIdentifier: String
            
            if celldata.sender == uid {
                cellIdentifier = "Cell1"
            } else {
                cellIdentifier = "Cell2"
            }
        
        let cell = chatTableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! ChatCell
        cell.selectionStyle = .none
        
       
        
        if celldata.sender == uid {
           

            cell.detailLabel.text = "\(celldata.message)"
            cell.timeLabel.text = celldata.timeStamp
            
        }else{

            cell.detailLabel.text = "\(celldata.message)"
            cell.timeLabel.text = celldata.timeStamp
        }
        
        return cell
        
    }
    
    
    
    
    
}

