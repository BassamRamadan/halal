//
//  LoginViewController.swift
//
//  Created by Hassan Ramadan on 9/21/19.
//  Copyright © 2019 Hassan Ramadan IOS/Android Developer Tamkeen CO. All rights reserved.
//

//

import UIKit
class LoginViewController: common{
    
    
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var password: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Modules()
        setupBackButtonWithDismiss()
    }
    fileprivate func Modules(){
        userName.delegate = self
        password.delegate = self
        setModules(userName)
        setModules(password)
    }
    
    @IBAction func log(_ sender: UIButton) {
        let url = AppDelegate.url + "login"
        let info = ["username": userName.text!,
                    "password": password.text!
        ]
        
        let headers = [ "Content-Type": "application/json" ,
                        "Accept" : "application/json"
        ]
        AlamofireRequests.PostMethod( methodType: "POST", url: url, info: info, headers: headers) { (error, success , jsonData) in
            do {
                let decoder = JSONDecoder()
                if error == nil{
                    if success{
                        let dataRecived = try decoder.decode(Login.self, from: jsonData)
                        CashedData.saveAdminID(name: dataRecived.data?.id ?? 0)
                        CashedData.saveAdminName(name: dataRecived.data?.username ?? "")
                        CashedData.saveAdminImage(name: dataRecived.data?.image_path ?? "")
                        CashedData.saveAdminPassword(name: self.password.text ?? "")
                        CashedData.saveAdminApiKey(token: dataRecived.data?.access_token ?? "")
                        CashedData.saveAdminCityId(token: dataRecived.data?.city_id ?? "")
                        common.OpenSetting()
                        
                        self.stopAnimating()
                    }else{
                        let dataRecived = try decoder.decode(ErrorHandle.self, from: jsonData)
                        self.present(common.makeAlert(message: dataRecived.message ?? ""), animated: true, completion: nil)
                        self.stopAnimating()
                    }
                }else{
                    let dataRecived = try decoder.decode(ErrorHandle.self, from: jsonData)
                    self.present(common.makeAlert(message: dataRecived.message ?? ""), animated: true, completion: nil)
                    self.stopAnimating()
                }
            }catch {
                self.present(common.makeAlert(message: error.localizedDescription), animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func check(_ sender: UIButton) {
        if sender.imageView?.image == #imageLiteral(resourceName: "ic_check_box"){
            sender.setImage(#imageLiteral(resourceName: "ic_check_box_checked"), for: .normal)
        }else{
            sender.setImage(#imageLiteral(resourceName: "ic_check_box"), for: .normal)
        }
    }
    
    
    
    func initialize(application: UIApplication, launchOptions: [UIApplication.LaunchOptionsKey : Any]?) {
        print("initialize analatics service ")
    }
    
    fileprivate func setModules(_ textField : UIView){
        textField.backgroundColor = UIColor(named: "textFieldBackground")
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.borderWidth = 0.0
    }
}
extension LoginViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        textField.backgroundColor = .white
        textField.layer.borderWidth = 1.0
        textField.layer.borderColor = UIColor(named: "light blue")?.cgColor
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        setModules(textField)
    }
}
