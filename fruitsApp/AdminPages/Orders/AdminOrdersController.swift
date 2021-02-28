//
//  UserOrdersController.swift
//  Joumla
//
//  Created by Bassam Ramadan on 2/13/20.
//  Copyright © 2020 Bassam Ramadan. All rights reserved.
//

import UIKit

class AdminOrdersController: common {
    var myOrders = [OrdersData]()
    var CurrentStatus: UIButton?
    @IBOutlet var tableView : UITableView!
    @IBOutlet var rejected : UIButton!
    @IBOutlet var completed : UIButton!
    @IBOutlet var confirmed : UIButton!
    @IBOutlet var new : UIButton!
    @IBAction func FilterStatus(_ sender: UIButton) {
        new.setTitleColor(UIColor(named: "LightText"), for: .normal)
        confirmed.setTitleColor(UIColor(named: "LightText"), for: .normal)
        rejected.setTitleColor(UIColor(named: "LightText"), for: .normal)
        completed.setTitleColor(UIColor(named: "LightText"), for: .normal)
        
        var status = ""
        switch sender.tag {
        case 1:
            new.setTitleColor(.white, for: .normal)
            CurrentStatus = new
            status = "new"
        case 2:
            confirmed.setTitleColor(.white, for: .normal)
            CurrentStatus = confirmed
            status = "confirmed"
        case 3:
            rejected.setTitleColor(.white, for: .normal)
            CurrentStatus = rejected
            status = "rejected"
        case 4:
             completed.setTitleColor(.white, for: .normal)
             CurrentStatus = completed
             status = "completed"
        default:
            break
        }
        getOrdersData(url: getUrl(status: status))
    }
    func getUrl(status: String) -> String {
        return AppDelegate.url+"orders?status=\(status)"
    }
    func getApiToken() -> String {
        return CashedData.getAdminApiKey()!
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if CurrentStatus != nil{
            FilterStatus(CurrentStatus ?? new)
        }else{
            FilterStatus(new)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackButtonWithDismiss()
        navigationItem.title = "طلبات الشراء"
    }
    
    func getOrdersData(url: String){
        loading()
        let headers = [
            "Authorization": "Bearer " + getApiToken()
        ]
        AlamofireRequests.getMethod(url: url, headers:headers) { (error, success , jsonData) in
            do {
                let decoder = JSONDecoder()
                if error == nil{
                    let dataRecived = try decoder.decode(AdminOrders.self, from: jsonData)
                    if success{
                        self.myOrders.removeAll()
                        self.myOrders.append(contentsOf: dataRecived.data)
                        self.tableView.reloadData()
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
                self.present(common.makeAlert(), animated: true, completion: nil)
                self.stopAnimating()
            }
        }
        
    }
    
    func deleteCell(index: Int) {
        loading()
        if myOrders.count > index {
            let url = AppDelegate.url+"delete-order/\(myOrders[index].identifier ?? "")"
            let headers = ["Content-Type": "application/json",
                           "Accept": "application/json",
                           "Authorization": "Bearer " + (CashedData.getAdminApiKey() ?? "")]
            AlamofireRequests.PostMethod(methodType: "DELETE", url: url, info: [:], headers: headers) {
                (error, success , jsonData) in
                do {
                    let decoder = JSONDecoder()
                    let dataRecived = try decoder.decode(ErrorHandle.self, from: jsonData)
                    if error == nil{
                        if success{
                            self.myOrders.remove(at: index)
                            self.tableView.reloadData()
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
                    self.present(common.makeAlert(), animated: true, completion: nil)
                    self.stopAnimating()
                }
            }
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "orderDetails" {
            if let destination = segue.destination as? AdminOrdersDetails{
                destination.SuperOrder = sender as? OrdersData
            }
        }
    }
    fileprivate func setBeforeSwipe(_ cell: UITableViewCell) {
        cell.contentView.layer.cornerRadius = 15
        cell.contentView.clipsToBounds = true
        cell.backgroundColor = UIColor.white
    }
}
extension AdminOrdersController : UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.myOrders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserOrders", for: indexPath) as! OrdersCell
        cell.createAt.text = self.myOrders[indexPath.row].createdAt ?? ""
        cell.userName.text = self.myOrders[indexPath.row].userName ?? ""
        cell.status.text = Status(ApiStatus: self.myOrders[indexPath.row].status ?? "")
        cell.statusColor.backgroundColor = StatusIcon(ApiStatus: self.myOrders[indexPath.row].status ?? "")
        return cell
    }
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let cell = tableView.cellForRow(at: indexPath)
        setBeforeSwipe(cell!)
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { _, _, complete in
            self.deleteCell(index: indexPath.row)
            complete(true)
        }
        deleteAction.image = UIImage(named: "ic_delete")
        deleteAction.backgroundColor = .red
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        configuration.performsFirstActionWithFullSwipe = true
         return configuration
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "orderDetails", sender: self.myOrders[indexPath.row])
    }
    func Status(ApiStatus : String)-> String{
        switch ApiStatus {
        case "new":
            return "طلب جديد"
        case "confirmed":
            return "طلب مؤكد"
        case "completed":
            return "طلب تم تسليمه"
        default:
            return "طلب مرفوض"
        }
    }
    func StatusIcon(ApiStatus : String)-> UIColor{
        switch ApiStatus {
        case "new":
            return UIColor(named: "VividOrange") ?? UIColor.orange
        case "confirmed":
            return UIColor(named: "green") ?? UIColor.green
        case "completed":
            return UIColor(named: "green") ?? UIColor.green
        default:
            return UIColor.red
        }
    }
}
