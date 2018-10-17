//
//  ChatViewController.swift
//  ViewControllersAndLogs
//
//  Created by Ilya Aleshin on 21.06.2018.
//  Copyright © 2018 Bakh. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var messageField: UITextView!
    @IBOutlet weak var sendButton: UIButton!
    
    private var messages: [Message] = []
    
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(reload), for: UIControlEvents.valueChanged)
        return refreshControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.addSubview(refreshControl)
        reload()
        NotificationCenter.default.addObserver(self, selector: #selector(scrollToBot), name: NSNotification.Name.UIKeyboardDidChangeFrame, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    
    @objc func reload() {
        DispatchQueue.main.async {
            self.refreshControl.beginRefreshing()
        }
        let url = URL(string: "http://triangleye.com/bakh/lessons/swift/s9/messages/")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        URLSession.shared.dataTask(with: request) {data, response, error in
            DispatchQueue.main.async {
                self.refreshControl.endRefreshing()
            }
            if (error != nil) {
                print("Server error is", error ?? "unknow")
                return
            }
            print("Server returns: ", String(data: data!, encoding: String.Encoding.utf8) ?? "")
            let responseJSON = try? JSONSerialization.jsonObject(with: data!, options: [])
            if let responseJSON = responseJSON as? [Any] {
                print(responseJSON)
                self.messages.removeAll()
                for f in responseJSON {
                    self.messages.append(Message(data: f as! [String:Any]))
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.tableView.scrollToRow(at: IndexPath(row: self.messages.count-1, section: 0), at: .bottom, animated: true)
                }
            } else {
                print("json error")
                // TODO: if server not json format response return standrd error json
            }
        }.resume()
    }
    
    @IBAction func send(_ sender: Any) {
        view.endEditing(true)
        if (nameField.text?.isEmpty)! {
            return
        }
        if messageField.text.isEmpty {
            return
        }
        sendButton.isEnabled = false
        let url = URL(string: "http://triangleye.com/bakh/lessons/swift/s9/sendMessage/")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let postString = "name=" + nameField.text! + "&message=" + messageField.text
        request.httpBody = postString.data(using: String.Encoding.utf8)
        URLSession.shared.dataTask(with: request) {data, response, error in
            DispatchQueue.main.async {
                self.messageField.text = ""
                self.sendButton.isEnabled = true
            }
            self.reload()
        }.resume()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let nibs : Array = Bundle.main.loadNibNamed("MessageItem", owner: self, options: nil)!
        let cell:MessageItem = nibs[0] as! MessageItem
        cell.setMessage(m: messages[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        view.endEditing(true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    @objc func scrollToBot(sender: NSNotification) {
        self.tableView.scrollToRow(at: IndexPath(row: self.messages.count-1, section: 0), at: .bottom, animated: true)
    }
    
    @objc func keyboardWillShow(sender: NSNotification) {
        let info = sender.userInfo!
        let keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        self.view.frame.size.height = UIScreen.main.bounds.height - keyboardFrame.height + 44
    }
    
    @objc func keyboardWillHide(sender: NSNotification) {
        self.view.frame.size.height = UIScreen.main.bounds.height
    }
}
