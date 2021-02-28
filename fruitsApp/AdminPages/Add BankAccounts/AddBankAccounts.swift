//
//  AddBankAccounts.swift
//  ezhelhaa
//
//  Created by Bassam Ramadan on 4/3/20.
//  Copyright © 2020 Bassam Ramadan. All rights reserved.
//

import UIKit
import SDWebImage
import Photos
class AddBankAccounts: common ,UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    let myPicController = UIImagePickerController()
    var rowSelected: Int?
    
    @IBOutlet var MoreButton: UIButton!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var tableHeight: NSLayoutConstraint!
    var BankAccounts = [Account]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myPicController.delegate = self
        navigationItem.title = "إضافة الحسابات البنكية"
        setupBackButtonWithDismiss()
        getAccounts()
    }
    @IBAction func AddMore(sender: UIButton){
        self.MoreButton.setTitle("المزيد", for: .normal)
        BankAccounts.append(Account(bankName: "", bankUsername: "", bankNumber: "", bankIban: "", bankLogo: nil))
        tableView.beginUpdates()
        tableView.insertRows(at: [IndexPath(row: BankAccounts.count-1, section: 0)], with: .automatic)
        tableView.endUpdates()
        UpdateConstraints()
    }
    @IBAction func DeleteItem(sender: UIButton){
        BankAccounts.remove(at: sender.tag)
        tableView.beginUpdates()
        tableView.deleteRows(at: [IndexPath(row: sender.tag, section: 0)], with: .automatic)
        tableView.endUpdates()
        UpdateConstraints()
    }
    func UpdateConstraints() {
        tableView.layoutIfNeeded()
      //  let height = tableView.contentSize.height
        tableHeight.constant = CGFloat(390 * BankAccounts.count)
    }
    
    func getAccounts(){
        loading()
        let url = AppDelegate.url+"bank-accounts/\(CashedData.getAdminCityId() ?? "")"
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
                        self.BankAccounts.append(contentsOf: dataRecived.data)
                        
                        if self.BankAccounts.count == 0{
                            self.MoreButton.setTitle("إضافة بنك", for: .normal)
                        }
                        self.tableView.reloadData()
                        self.UpdateConstraints()
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
    @IBAction func AddNewBankAccounts(_ sender: UIButton) {
        loading()
        let url = AppDelegate.url+"add-bank-account"
        let headers = [ "Content-Type": "application/json" ,
                        "Accept" : "application/json",
                        "Authorization": "Bearer " + (CashedData.getAdminApiKey() ?? "")
            
        ]
        var info:[String : Any] = [:]
        var images = [UIImage?]()
        for index in 0..<self.BankAccounts.count{
        
            let cell = self.tableView.cellForRow(at: IndexPath(row: index, section: 0))  as! AddBankAccountCell
            info["accounts[\(index)][bank_name]"] = cell.name.text
            info["accounts[\(index)][bank_username]"] = cell.username.text
            info["accounts[\(index)][bank_account_number]"] = cell.accountNumber.text
            info["accounts[\(index)][bank_iban]"] = cell.iban.text
            if cell.logo.image == #imageLiteral(resourceName: "ic_upload_img"){
                images.append((nil))
            }else{
                images.append(cell.logo.image)
            }
        }
        
        AlamofireRequests.UserSignUp(url: url, info: info, images: images, CompanyImage: nil, coverImage: nil, idImage: nil, licenseImage: nil, headers: headers) {
            (error, success , jsonData) in
            do {
                let decoder = JSONDecoder()
                let dataRecived = try decoder.decode(ErrorHandle.self, from: jsonData)
                if error == nil{
                    if success{
                        self.present(common.makeAlert(message: "تم إضافة البنوك"), animated: true, completion: nil)
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
    func checkExistImage(_ cell: AddBankAccountCell){
        if cell.logo.image != #imageLiteral(resourceName: "ic_upload_img"){
            cell.logoLabel.isHidden = true
        }else{
            cell.logoLabel.isHidden = false
        }
    }
    @IBAction func pickImages(_ sender: UIButton) {
        rowSelected = sender.tag
        checkPermission()
    }
    
    @objc  func imagePickerController(_ picker: UIImagePickerController,didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        if rowSelected != nil{
            let cell = tableView.cellForRow(at: IndexPath(row: rowSelected ?? 0, section: 0)) as! AddBankAccountCell
            cell.logo.image = image
            checkExistImage(cell)
        }
        self.dismiss(animated: true, completion: nil)
        
    }
    
    func checkPermission() {
        let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        switch photoAuthorizationStatus {
        case .authorized:
            myPicController.sourceType = UIImagePickerController.SourceType.photoLibrary
            myPicController.allowsEditing = true
            self.present(myPicController , animated: true, completion: nil)
            print("Access is granted by user")
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization({
                (newStatus) in
                print("status is \(newStatus)")
                if newStatus ==  PHAuthorizationStatus.authorized {
                    /* do stuff here */
                    print("success")
                }
            })
            print("It is not determined until now")
        case .restricted:
            // same same
            print("User do not have access to photo album.")
        case .denied:
            // same same
            print("User has denied the permission.")
        @unknown default:
            print("User has denied the permission.")
        }
    }
}
extension AddBankAccounts: UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.BankAccounts.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddBankAccountCell", for: indexPath) as! AddBankAccountCell
        cell.accountNumber.text = self.BankAccounts[indexPath.row].bankNumber ?? ""
        cell.iban.text = self.BankAccounts[indexPath.row].bankIban ?? ""
        cell.username.text = self.BankAccounts[indexPath.row].bankUsername ?? ""
        cell.name.text = self.BankAccounts[indexPath.row].bankName ?? ""
        if let img = self.BankAccounts[indexPath.row].bankLogo{
             cell.logo.sd_setImage(with: URL(string: img))
        }else{
            cell.logo.image = #imageLiteral(resourceName: "ic_upload_img")
        }
        self.checkExistImage(cell)
        
        cell.Delete.tag = indexPath.row
        cell.editImage.tag = indexPath.row
        return cell
    }
}
