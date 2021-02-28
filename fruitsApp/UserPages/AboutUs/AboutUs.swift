//
//  AboutUs.swift
//  ezhelhaa
//
//  Created by Bassam Ramadan on 3/27/20.
//  Copyright © 2020 Bassam Ramadan. All rights reserved.
//

import UIKit

class AboutUs: common {

    var data: Content?
    @IBOutlet var ourWay: UILabel!
    @IBOutlet var workTimes: UILabel!
    @IBOutlet var about: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        setupBackButtonWithDismiss()
        getAboutUs()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         self.setupCartButton(number: AppDelegate.CartItems.count)
    }
    
    func setupData(){
        if self.data?.about?.content != "Dummy Content"{
            self.about.text = self.data?.about?.content ?? ""
        }
        self.ourWay.text = self.data?.ourway?.content ?? ""
        self.workTimes.text = self.data?.workTimes?.content ?? ""
        self.stopAnimating()
    }
    func getAboutUs(){
        loading()
        let url = AppDelegate.url + "contents/\(CashedData.getUserCityId() ?? 0)"
        let headers = [
            "Accept" : "application/json",
            "Content-Type": "application/json"
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
