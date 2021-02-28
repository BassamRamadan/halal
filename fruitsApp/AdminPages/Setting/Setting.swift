//
//  Setting.swift
//  ezhelhaa
//
//  Created by Bassam Ramadan on 3/31/20.
//  Copyright © 2020 Bassam Ramadan. All rights reserved.
//

import UIKit

class Setting: UIViewController {

    @IBOutlet var OrdersNumber: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
       
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getOrdersData()
    }
    @IBAction func logoutUser(_ sender: Any){
        common.AdminLogout(currentController: self)
    }
    @IBAction func Sacrifices(_ sender: Any){
        let storyboard = UIStoryboard(name: "sacrifices", bundle: nil)
        let linkingVC = storyboard.instantiateViewController(withIdentifier: "SacNav") as! UINavigationController
        let des = linkingVC.viewControllers[0] as! Sacrifices
        des.isAdmin = true
        linkingVC.modalPresentationStyle = .fullScreen
        self.present(linkingVC,animated: true,completion: nil)
    }
    @IBAction func Orders(_ sender: Any){
        let storyboard = UIStoryboard(name: "Orders", bundle: nil)
        let linkingVC = storyboard.instantiateViewController(withIdentifier: "OrdersNav") as! UINavigationController
         linkingVC.modalPresentationStyle = .fullScreen
        self.present(linkingVC,animated: true,completion: nil)
    }
    @IBAction func AddSacrifices(_ sender: Any){
        let storyboard = UIStoryboard(name: "AddSacrifices", bundle: nil)
        let linkingVC = storyboard.instantiateViewController(withIdentifier: "AddSacrifices") as! UINavigationController
         linkingVC.modalPresentationStyle = .fullScreen
        self.present(linkingVC,animated: true,completion: nil)
    }
    @IBAction func AddAboutUs(_ sender: Any){
        let storyboard = UIStoryboard(name: "AddAboutUs", bundle: nil)
        let linkingVC = storyboard.instantiateViewController(withIdentifier: "AddAboutUs") as! UINavigationController
        linkingVC.modalPresentationStyle = .fullScreen
        self.present(linkingVC,animated: true,completion: nil)
    }
    @IBAction func AddBankAccounts(_ sender: Any){
        let storyboard = UIStoryboard(name: "AddBankAccounts", bundle: nil)
        let linkingVC = storyboard.instantiateViewController(withIdentifier: "AddBankAccounts") as! UINavigationController
         linkingVC.modalPresentationStyle = .fullScreen
        self.present(linkingVC,animated: true,completion: nil)
    }
    @IBAction func AddContactUs(_ sender: Any){
        let storyboard = UIStoryboard(name: "AddContactUs", bundle: nil)
        let linkingVC = storyboard.instantiateViewController(withIdentifier: "AddContactUs") as! UINavigationController
         linkingVC.modalPresentationStyle = .fullScreen
        self.present(linkingVC,animated: true,completion: nil)
    }
    
    
    
    func getOrdersData(){
        let url = AppDelegate.url+"orders?status=new"
        let headers = [
            "Authorization": "Bearer " + CashedData.getAdminApiKey()!
        ]
        AlamofireRequests.getMethod(url: url, headers:headers) { (error, success , jsonData) in
            do {
                let decoder = JSONDecoder()
                if error == nil{
                    let dataRecived = try decoder.decode(AdminOrders.self, from: jsonData)
                    if success{
                        self.OrdersNumber.text = "\(dataRecived.data.count)"
                       
                        self.OrdersNumber.isHidden = dataRecived.data.count == 0
                      
                    }
                    else  {
                        self.present(common.makeAlert(message: dataRecived.message ?? "" ), animated: true, completion: nil)
                    }
                }else{
                    let dataRecived = try decoder.decode(ErrorHandle.self, from: jsonData)
                    self.present(common.makeAlert(message: dataRecived.message ?? ""), animated: true, completion: nil)
                }
            } catch {
                self.present(common.makeAlert(), animated: true, completion: nil)
            }
        }
        
    }
}
