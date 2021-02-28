//
//  BankAccounts.swift
//  ezhelhaa
//
//  Created by Bassam Ramadan on 3/27/20.
//  Copyright © 2020 Bassam Ramadan. All rights reserved.
//

import UIKit

class BankAccounts: common {

    @IBOutlet var tableView: UITableView!
    @IBOutlet var noData: UILabel!

    var BankAccounts = [Account]()
    override func viewDidLoad() {
        super.viewDidLoad()

        setupBackButtonWithDismiss()
        getAccounts()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupCartButton(number: AppDelegate.CartItems.count)
    }
    
    func getAccounts(){
        loading()
        let url = AppDelegate.url+"bank-accounts/\(CashedData.getUserCityId() ?? 0)"
        let headers = [
            "Accept" : "application/json",
            "Content-Type": "application/json"
        ]
        AlamofireRequests.getMethod(url: url, headers:headers) { (error, success , jsonData) in
            do {
                let decoder = JSONDecoder()
                let dataRecived = try decoder.decode(Banks.self, from: jsonData)
                if error == nil{
                    if success{
                        self.BankAccounts.removeAll()
                        if dataRecived.data.count > 0 {
                            self.BankAccounts.append(contentsOf: dataRecived.data)
                            self.tableView.reloadData()
                            self.tableView.isHidden = false
                            self.noData.isHidden = true
                        }else{
                            self.tableView.isHidden = true
                            self.noData.isHidden = false
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

}
extension BankAccounts: UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.BankAccounts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "BankAccountCell", for: indexPath) as! BankAccountCell
            cell.accountNumber.text = self.BankAccounts[indexPath.row].bankNumber ?? ""
            cell.iban.text = self.BankAccounts[indexPath.row].bankIban ?? ""
            cell.username.text = self.BankAccounts[indexPath.row].bankUsername ?? ""
            cell.name.text = self.BankAccounts[indexPath.row].bankName ?? ""
            cell.logo.sd_setImage(with: URL(string: self.BankAccounts[indexPath.row].bankLogo ?? ""))
            return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
