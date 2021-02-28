//
//  Cart.swift
//  ezhelhaa
//
//  Created by Bassam Ramadan on 3/30/20.
//  Copyright © 2020 Bassam Ramadan. All rights reserved.
//

import UIKit

class Cart: common {

    @IBOutlet var TotalPrice: UILabel!
    @IBOutlet var SacNumber: UILabel!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var BottomView: UIView!
    
    var taxValue:Double? = 0.0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "العربة"
        getTax()
        setupBackButtonWithDismiss()
        common.addcrafs(view, topAnchor: BottomView.topAnchor)
        self.setupTotal()
    }
    
    func setupTotal(){
        var Summation = 0.0
        for x in AppDelegate.CartItems{
            Summation += x.totalPrice ?? 0.0
        }
        Summation = Summation + ((taxValue ?? 0.0) * Summation)
        TotalPrice.text = "\(Summation)"
        SacNumber.text = "( \(AppDelegate.CartItems.count) )"
    }
    @IBAction func DeletItem(sender: UIButton){
        let alert = UIAlertController(title: "Alert", message: "هل تريد الحذف بالفعل" , preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "لا أوافق", style: .default, handler: { action in
        }))
        alert.addAction(UIAlertAction(title: "موافق", style: .default, handler: { action in
            
            AppDelegate.CartItems.remove(at: sender.tag)
            AppDelegate.updateCartItems()
            self.setupTotal()
            self.tableView.reloadData()
            
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func Plus(_ sender: UIButton) {
        let indx = IndexPath(row: sender.tag, section: 0)
        let cell = tableView.cellForRow(at: indx) as! CartCell
        if let p = AppDelegate.CartItems[indx.row].price{
            AppDelegate.CartItems[indx.row].totalPrice = Double(AppDelegate.CartItems[indx.row].totalPrice ?? 0.0) + p
            AppDelegate.CartItems[indx.row].quantity = Int(AppDelegate.CartItems[indx.row].quantity ?? 0) + 1
            AppDelegate.updateCartItems()
            cell.totalPrice.text = "\(AppDelegate.CartItems[indx.row].totalPrice ?? 0.0)"
            cell.quantity.text = "\(AppDelegate.CartItems[indx.row].quantity ?? 0) ذبيحة"
            cell.SacNumber.text = "\(AppDelegate.CartItems[indx.row].quantity ?? 0) ذبيحة"
            self.setupTotal()
        }
    }
    @IBAction func Minus(_ sender: UIButton) {
        let indx = IndexPath(row: sender.tag, section: 0)
        let cell = tableView.cellForRow(at: indx) as! CartCell
        if AppDelegate.CartItems[indx.row].quantity ?? 1 > 1{
            if let p = AppDelegate.CartItems[indx.row].price{
                AppDelegate.CartItems[indx.row].totalPrice = Double(AppDelegate.CartItems[indx.row].totalPrice ?? 0.0) - p
                AppDelegate.CartItems[indx.row].quantity = Int(AppDelegate.CartItems[indx.row].quantity ?? 0) - 1
                AppDelegate.updateCartItems()
                cell.totalPrice.text = "\(AppDelegate.CartItems[indx.row].totalPrice ?? 0.0)"
                cell.quantity.text = "\(AppDelegate.CartItems[indx.row].quantity ?? 0) ذبيحة"
                cell.SacNumber.text = "\(AppDelegate.CartItems[indx.row].quantity ?? 0) ذبيحة"
                self.setupTotal()
            }
        }
    }
    @IBAction func MoveToCompletOrder(_ sender: UIButton) {
        if AppDelegate.CartItems.count > 0{
            let storyboard = UIStoryboard(name: "Cart", bundle: nil)
            let linkingVC = storyboard.instantiateViewController(withIdentifier: "CompletOrder") as! UINavigationController
            linkingVC.modalPresentationStyle = .fullScreen
            self.present(linkingVC,animated: true,completion: nil)
        }else{
            self.present(common.makeAlert(message: "لا يوجد ذبائح بالعربة"), animated: true, completion: nil)
        }
    }
    func getTax(){
        loading()
        let url = AppDelegate.url+"tax"
        let headers = [
            "Accept" : "application/json",
            "Content-Type": "application/json"
        ]
        AlamofireRequests.getMethod(url: url, headers:headers) {
            (error, success , jsonData) in
            do {
                let decoder = JSONDecoder()
                let dataRecived = try decoder.decode(tax.self, from: jsonData)
                if error == nil{
                    if success{
                        if let tax = dataRecived.data.tax{
                            self.taxValue = Double(tax)
                        }
                        self.setupTotal()
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
                self.stopAnimating()
            }
        }
    }
}
extension Cart: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AppDelegate.CartItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cart", for: indexPath) as! CartCell
        
        cell.SacrificeImage.sd_setImage(with: URL(string: AppDelegate.CartItems[indexPath.row].imagePath ?? ""))
        cell.SacrificeName.text = AppDelegate.CartItems[indexPath.row].name ?? ""
        cell.totalPrice.text = "\(AppDelegate.CartItems[indexPath.row].totalPrice ?? 0.0)"
        
        cell.PackagingName.text = AppDelegate.CartItems[indexPath.row].packages?.name ?? ""
        cell.PackagingPrice.text = AppDelegate.CartItems[indexPath.row].packages?.price ?? ""
        cell.PackageStack.isHidden = AppDelegate.CartItems[indexPath.row].packages?.name == nil
        
        cell.cockingName.text = AppDelegate.CartItems[indexPath.row].cocking?.name ?? ""
        cell.cockingPrice.text = AppDelegate.CartItems[indexPath.row].cocking?.price ?? ""
        cell.CockingStack.isHidden = AppDelegate.CartItems[indexPath.row].cocking?.name == nil
        
        cell.sizesName.text = AppDelegate.CartItems[indexPath.row].sizes?.name ?? ""
        cell.sizesPrice.text = AppDelegate.CartItems[indexPath.row].sizes?.price ?? ""
        cell.SizeStack.isHidden = AppDelegate.CartItems[indexPath.row].sizes?.name == nil
        
        cell.slicesName.text = AppDelegate.CartItems[indexPath.row].slices?.name ?? ""
        cell.slicesPrice.text = AppDelegate.CartItems[indexPath.row].slices?.price ?? ""
        cell.SliceStack.isHidden = AppDelegate.CartItems[indexPath.row].slices?.name == nil
        
        cell.head.isHidden = !(AppDelegate.CartItems[indexPath.row].head ?? false)
        cell.headSeperator.isHidden = !(AppDelegate.CartItems[indexPath.row].head ?? false)
        cell.shin.isHidden = !(AppDelegate.CartItems[indexPath.row].shin ?? false)
        cell.shinSeperator.isHidden = !(AppDelegate.CartItems[indexPath.row].shin ?? false)
        cell.bowels.isHidden = !(AppDelegate.CartItems[indexPath.row].bowels ?? false)
        cell.bowelsSeperator.isHidden = !(AppDelegate.CartItems[indexPath.row].bowels ?? false)
        
        cell.quantity.text = "\(AppDelegate.CartItems[indexPath.row].quantity ?? 0) ذبيحة"
        cell.minQuantity.text = "\(AppDelegate.CartItems[indexPath.row].minQuantity ?? 0) كيلو"
        cell.minPrice.text = "\(AppDelegate.CartItems[indexPath.row].mincementPrice ?? 0.0)"
        cell.SacNumber.text = "\(AppDelegate.CartItems[indexPath.row].quantity ?? 0) ذبيحة"
        cell.notes.text = AppDelegate.CartItems[indexPath.row].notes ?? "....."
        
        cell.increment.isHidden = (AppDelegate.CartItems[indexPath.row].minQuantity ?? 0 == 0)
        cell.delet.tag = indexPath.row
        cell.plus.tag = indexPath.row
        cell.minus.tag = indexPath.row
        return cell
    }
    
}
