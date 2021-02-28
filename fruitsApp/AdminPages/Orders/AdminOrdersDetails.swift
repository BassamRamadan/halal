//
//  AdminOrdersDetails.swift
//  ezhelhaa
//
//  Created by Bassam Ramadan on 4/4/20.
//  Copyright © 2020 Bassam Ramadan. All rights reserved.
//

import UIKit
import DropDown
class AdminOrdersDetails: common {

    let datePicker = UIDatePicker()
    var StatusString = ""
    let StatusDrop = DropDown()
    var OrderDetails = [OrdersDetails]()
    var SuperOrder: OrdersData?
    var SummationPrices: Double? = 0.0
    let statusData = ["new","confirmed","completed","rejected"]
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var tableHeight: NSLayoutConstraint!
    
    @IBOutlet var orderNumber: UILabel!
    @IBOutlet var orderDate: UILabel!
    @IBOutlet var orderTotalPrice: UILabel!
    
    @IBOutlet var userName: UILabel!
    @IBOutlet var userPhone: UILabel!
    @IBOutlet var UserCity: UILabel!
    @IBOutlet var userAddress: UILabel!
    
    @IBOutlet var orderStatus: UIButton!
    @IBOutlet var deliveryDate: UITextField!
    @IBOutlet var providerNotes: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getOrderDetails()
        setupBackButtonWithPOP()
        showDatePicker()
    }
    @IBAction func StatusButton(_ sender: UIButton) {
        StatusDrop.anchorView = (sender as AnchorView)
        StatusDrop.dataSource = ["طلب جديد","طلب مؤكد","طلب تم تسليمه","طلب مرفوض"]
        StatusDrop.bottomOffset = CGPoint(x: 0, y:(StatusDrop.anchorView?.plainView.bounds.height)!)
        StatusDrop.selectionAction = { [unowned self](index : Int , item : String)in
            sender.setTitle(item, for: .normal)
            self.StatusString = self.statusData[index]
        }
        StatusDrop.show()
    }
    
    func setupData(){
        orderDate.text = SuperOrder?.createdAt ?? "...."
        orderNumber.text = "\(OrderDetails[0].id ?? 0)"
        orderStatus.setTitle(Status(SuperOrder?.status ?? ""), for: .normal)
        self.StatusString = SuperOrder?.status ?? ""
        deliveryDate.text = SuperOrder?.deliveryDate ?? "لم يحدد بعد"
        if let notes = SuperOrder?.providerNotes{
            providerNotes.text =  notes
        }
        userName.text = OrderDetails[0].userName ?? "لم يضف أسم"
        userPhone.text = OrderDetails[0].userPhone ?? "لم يضف رقم الجوال"
        UserCity.text = OrderDetails[0].city?.name ?? "لم يحدد مدينة"
        userAddress.text = OrderDetails[0].address ?? "لم يضف عنوان"
        
        
    }
    func setupOrderTotalPrice(){
        for Sac in OrderDetails{
            if let p = Double(Sac.totalCost ?? "0.0"){
                SummationPrices =  p + Double(SummationPrices ?? 0.0)
            }
        }
        orderTotalPrice.text = "\(SummationPrices ?? 0.0)"
    }
    func UpdateConstraints() {
        tableView.layoutIfNeeded()
        tableHeight.constant = tableView.contentSize.height
    }
    func getOrderDetails() {
        loading()
        let url = AppDelegate.url+"orders/\(SuperOrder?.identifier ?? "")"
        let headers = ["Content-Type": "application/json",
                       "Accept": "application/json",
                       "Authorization": "Bearer " + (CashedData.getAdminApiKey() ?? "")
        ]
        AlamofireRequests.getMethod(url: url, headers: headers){
            (error, success , jsonData) in
            do {
                let decoder = JSONDecoder()
                let dataRecived = try decoder.decode(OrdersInfo.self, from: jsonData)
                if error == nil{
                    if success{
                        self.OrderDetails.removeAll()
                        self.OrderDetails.append(contentsOf: dataRecived.data)
                        self.tableView.reloadData()
                        self.UpdateConstraints()
                        self.setupData()
                        self.setupOrderTotalPrice()
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
    @IBAction func Save(sender: UIButton) {
        loading()
        let url = AppDelegate.url+"edit-order/\(SuperOrder?.identifier ?? "")"
        let headers = ["Content-Type": "application/json",
                       "Accept": "application/json",
                       "Authorization": "Bearer " + (CashedData.getAdminApiKey() ?? "")
        ]
        let info = ["status": self.StatusString,
                    "notes" : self.providerNotes.text ?? "",
                    "delivery_date": self.deliveryDate.text ?? ""
        ]
        AlamofireRequests.PostMethod(methodType: "POST", url: url, info: info, headers: headers){
            (error, success , jsonData) in
            do {
                let decoder = JSONDecoder()
                let dataRecived = try decoder.decode(ErrorHandle.self, from: jsonData)
                if error == nil{
                    if success{
                        self.present(common.makeAlert(message:  "تم حفظ التعديلات"), animated: true, completion: nil)
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
    func Status(_ str: String)-> String{
        switch str {
        case "new":
            return "طلب جديد"
        case "rejected":
            return "طلب مرفوض"
        case "completed":
            return "طلب تم تسليمه"
        case "confirmed":
            return "طلب مؤكد"
        default:
            return ""
        }
    }
    @IBAction func Map(){
        let myAddress = "\(OrderDetails[0].lat ?? ""),\(OrderDetails[0].lon ?? "")"
        if let url = URL(string:"http://maps.apple.com/?ll=\(myAddress)") {
            UIApplication.shared.open(url)
        }
    }
    
    func showDatePicker(){
        //Formate Date
        datePicker.datePickerMode = .date
        
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
        
        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
        
        deliveryDate.inputAccessoryView = toolbar
        deliveryDate.inputView = datePicker
        
    }
    
    @objc func donedatePicker(){
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        deliveryDate.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    @objc func cancelDatePicker(){
        self.view.endEditing(true)
    }
}
extension AdminOrdersDetails: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return OrderDetails.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cart", for: indexPath) as! CartCell
        
        cell.SacrificeImage.sd_setImage(with: URL(string: OrderDetails[indexPath.row].sacrifice?.imagePath ?? ""))
        cell.SacrificeName.text = OrderDetails[indexPath.row].sacrifice?.name ?? ""
        cell.totalPrice.text =  OrderDetails[indexPath.row].totalCost ?? ""
        
        cell.PackagingName.text = OrderDetails[indexPath.row].sacrificePackageName ?? ""
        cell.PackagingPrice.text = OrderDetails[indexPath.row].sacrificePackagePrice ?? ""
        cell.PackageStack.isHidden = AppDelegate.CartItems[indexPath.row].packages?.name == nil
        
        cell.cockingName.text = OrderDetails[indexPath.row].sacrificeCockingName ?? ""
        cell.cockingPrice.text = OrderDetails[indexPath.row].sacrificeCockingPrice ?? ""
        cell.CockingStack.isHidden = AppDelegate.CartItems[indexPath.row].cocking?.name == nil
        
        cell.sizesName.text = OrderDetails[indexPath.row].sacrificeSizeName ?? ""
        cell.sizesPrice.text = OrderDetails[indexPath.row].sacrificeSizePrice ?? ""
        cell.SizeStack.isHidden = AppDelegate.CartItems[indexPath.row].sizes?.name == nil
        
        cell.slicesName.text = OrderDetails[indexPath.row].sacrificeSliceName ?? ""
        cell.slicesPrice.text = OrderDetails[indexPath.row].sacrificeSlicePrice ?? ""
        cell.SliceStack.isHidden = AppDelegate.CartItems[indexPath.row].slices?.name == nil
        
        cell.head.isHidden = ((OrderDetails[indexPath.row].wantsHead ?? "0") == "0")
        cell.headSeperator.isHidden = cell.head.isHidden
        
        cell.shin.isHidden = ((OrderDetails[indexPath.row].wantsShin ?? "0") == "0")
        cell.shinSeperator.isHidden = cell.shin.isHidden
        
        cell.bowels.isHidden = ((OrderDetails[indexPath.row].wantsBowels ?? "0") == "0")
        cell.bowelsSeperator.isHidden = cell.bowels.isHidden
        
        cell.quantity.text = "\(OrderDetails[indexPath.row].quantity ?? "0") ذبيحة"
        cell.minQuantity.text = "\(OrderDetails[indexPath.row].mincementQuantity ?? "0") كيلو"
        cell.minPrice.text = "\(OrderDetails[indexPath.row].mincementPrice ?? "0")"
        
        cell.notes.text = OrderDetails[indexPath.row].notes ?? "....."
        
        
        return cell
    }
    
}
