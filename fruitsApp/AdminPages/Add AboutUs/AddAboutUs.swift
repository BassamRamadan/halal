//
//  AddAboutUs.swift
//  ezhelhaa
//
//  Created by Bassam Ramadan on 4/3/20.
//  Copyright © 2020 Bassam Ramadan. All rights reserved.
//

import UIKit

class AddAboutUs: common {

     var data: Content?
    @IBOutlet var AboutUs: UITextView!
    @IBOutlet var OurWay: UITextView!
    @IBOutlet var WorkTime: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "إضافة من نحن"
        getAboutUs()
        setupBackButtonWithDismiss()
    }
    
    @IBAction func Save(sender: UIButton){
        Submit()
    }
    
    func setupData(){
        if self.data?.about?.content != "Dummy Content"{
            self.AboutUs.text = self.data?.about?.content ?? ""
        }
        self.OurWay.text = self.data?.ourway?.content ?? "طريقتنا"
        self.WorkTime.text = self.data?.workTimes?.content ?? "أوقات العمل"
        self.stopAnimating()
    }
    
    func Submit(){
        let  url = AppDelegate.url+"add-content"
        let headers = [ "Content-Type": "application/json" ,
                        "Accept" : "application/json",
                        "Authorization": "Bearer " + (CashedData.getAdminApiKey() ?? "")
        ]
        let info:[String : Any] = [
            "about": self.AboutUs.text ?? "",
            "ourway": self.OurWay.text ?? "",
            "worktimes": self.WorkTime.text ?? ""
        ]
        AlamofireRequests.PostMethod(methodType: "POST", url: url, info: info, headers: headers){
            (error, success , jsonData) in
            do {
                let decoder = JSONDecoder()
                let dataRecived = try decoder.decode(ErrorHandle.self, from: jsonData)
                if error == nil{
                    if success{
                        self.present(common.makeAlert(message: "تم الإضافة بنجاح"), animated: true, completion: nil)
                        self.stopAnimating()
                    }else{
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

    func getAboutUs(){
        loading()
        let url = AppDelegate.url+"contents/\(CashedData.getAdminCityId() ?? "")"
        let headers = [
            "Accept" : "application/json",
            "Content-Type": "application/json",
            "Authorization": "Bearer " + (CashedData.getAdminApiKey() ?? "")
        ]
        AlamofireRequests.getMethod(url: url, headers:headers) { (error, success , jsonData) in
            do {
                let decoder = JSONDecoder()
                let dataRecived = try decoder.decode(contents.self, from: jsonData)
                if error == nil{
                    if success{
                        self.data = dataRecived.data
                        self.setupData()
                    }
                    else  {
                        self.present(common.makeAlert(message: dataRecived.message ?? "" ), animated: true, completion: nil)
                        self.stopAnimating()
                    }
                }else{
                    let dataRecived = try decoder.decode(ErrorHandle.self, from: jsonData)
                    self.present(common.makeAlert(message: dataRecived.message ?? ""), animated: true, completion: nil)
                    self.stopAnimating()
                }
            } catch {
                self.present(common.makeAlert(message: "حدث خطأ بالرجاء التاكد من تسجيل الدخول "), animated: true, completion: nil)
                self.stopAnimating()
            }
        }
    }
}
