//
//  Sacrifices.swift
//  ezhelhaa
//
//  Created by Bassam Ramadan on 3/27/20.
//  Copyright © 2020 Bassam Ramadan. All rights reserved.
//

import UIKit
import SDWebImage
class Sacrifices: common {
    @IBOutlet var SacrificesTable: UITableView!
    @IBOutlet var noData: UILabel!
    var SacrificesArr = [SacrificesDetails]()
    var isAdmin = false
    var url = ""
    let overlay: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 110.0, height: 120))
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if isAdmin{
            self.navigationItem.title = "الذبائح المضافة"
            self.setupBackButtonWithDismiss()
            url = AppDelegate.url+"sacrifices/\(CashedData.getAdminCityId() ?? "")"
            getSacrifices()
        }else{
            self.navigationItem.title = "الذبائح"
            setupBackButtonWithDismiss()
            self.setupCartButton(number: AppDelegate.CartItems.count)
            url = AppDelegate.url+"sacrifices/\(CashedData.getUserCityId() ?? 0)"
            getSacrifices()
        }
        
        overlay.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.2)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if isAdmin == false{
            self.setupCartButton(number: AppDelegate.CartItems.count)
        }
        if isAdmin{
            self.navigationItem.title = "الذبائح المضافة"
            self.setupBackButtonWithDismiss()
            url = AppDelegate.url+"sacrifices/\(CashedData.getAdminCityId() ?? "")"
            getSacrifices()
        }
    }
   
    
    func getSacrifices(){
        loading()
       
        let headers = [
            "Accept" : "application/json",
            "Content-Type": "application/json"
        ]
        AlamofireRequests.getMethod(url: url, headers:headers) { (error, success , jsonData) in
            do {
                let decoder = JSONDecoder()
                let dataRecived = try decoder.decode(SacrificesData.self, from: jsonData)
                if error == nil{
                    if success{
                        self.SacrificesArr.removeAll()
                        if dataRecived.data.count > 0{
                            self.SacrificesArr.append(contentsOf: dataRecived.data)
                            self.SacrificesTable.reloadData()
                            self.noData.isHidden = true
                            self.SacrificesTable.isHidden = false
                        }else{
                            self.noData.isHidden = false
                            self.SacrificesTable.isHidden = true
                        }
                        self.stopAnimating()
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
    func DeleteSacrifices(_ indx: Int){
        loading()
        let url = AppDelegate.url+"delete-sacrifice/\(self.SacrificesArr[indx].id)"
        let headers = [
            "Accept" : "application/json",
            "Content-Type": "application/json",
            "Authorization": "Bearer \(CashedData.getAdminApiKey() ?? "")"
        ]
        AlamofireRequests.PostMethod(methodType: "DELETE", url: url, info: [:], headers: headers){ (error, success , jsonData) in
            do {
                let decoder = JSONDecoder()
                let dataRecived = try decoder.decode(SacrificesData.self, from: jsonData)
                if error == nil{
                    if success{
                        self.SacrificesArr.remove(at: indx)
                        self.SacrificesTable.reloadData()
                        self.stopAnimating()
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
    
    @IBAction func EditSacrifices(_ sender: UIButton){
        let storyboard = UIStoryboard(name: "AddSacrifices", bundle: nil)
        let linkingVC = storyboard.instantiateViewController(withIdentifier: "AddSacrifices") as! UINavigationController
        let Edit = linkingVC.viewControllers[0] as! AddSacrifices
        Edit.isSacrificeEdit = true
        Edit.SacrificeInfo = self.SacrificesArr[sender.tag]
        self.present(linkingVC,animated: true,completion: nil)
    }
    
    @IBAction func DeletItem(sender: UIButton){
        let alert = UIAlertController(title: "Alert", message: "هل تريد الحذف بالفعل" , preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "لا أوافق", style: .default, handler: { action in
        }))
        alert.addAction(UIAlertAction(title: "موافق", style: .default, handler: { action in
            self.DeleteSacrifices(sender.tag)
            
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SacrificeDetails"{
            if let destination = segue.destination as? UINavigationController{
                if let dest = destination.viewControllers[0] as? SacrificeDetailsController{
                    dest.SacrificeInfo = self.SacrificesArr[sender as! Int]
                }
            }
        }
    }
}
extension Sacrifices: UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.SacrificesArr.count
    }
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "sacrifice", for: indexPath) as! sacrificeCell
        cell.sacrificeImage.sd_setImage(with: URL(string: self.SacrificesArr[indexPath.row].imagePath ?? ""))
        cell.name.text = self.SacrificesArr[indexPath.row].name ?? ""
        cell.bio.text = self.SacrificesArr[indexPath.row].description ?? ""
      
        
        
        cell.sacrificeImage.addSubview(overlay)
        cell.AdminEditAndDelet.isHidden = !(isAdmin)
        cell.edit.tag = indexPath.row
        cell.delet.tag = indexPath.row
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if isAdmin == false{
            performSegue(withIdentifier: "SacrificeDetails", sender: indexPath.row)
        }
    }
}
