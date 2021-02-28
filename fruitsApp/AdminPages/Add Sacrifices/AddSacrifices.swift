//
//  AddSacrifices.swift
//  ezhelhaa
//
//  Created by Bassam Ramadan on 4/2/20.
//  Copyright © 2020 Bassam Ramadan. All rights reserved.
//

import UIKit
import Photos
class AddSacrifices: common,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    let myPicController = UIImagePickerController()
    var images : UIImage?
    @IBOutlet var ImageLabel: UILabel!
    @IBOutlet var image: UIImageView!
    @IBOutlet var SacrificeName: UITextField!
    @IBOutlet var bio: UITextView!
    @IBOutlet var minPrice: UITextField!
    @IBOutlet var head: UISwitch!
    @IBOutlet var shin: UISwitch!
    @IBOutlet var bowels: UISwitch!
    
    @IBOutlet var sizeTable: UITableView!
    @IBOutlet var sizeTableHeight: NSLayoutConstraint!
    @IBOutlet var sizeStack: UIStackView!
    
    @IBOutlet var packageTable: UITableView!
    @IBOutlet var packageTableHeight: NSLayoutConstraint!
    @IBOutlet var packageStack: UIStackView!
    
    @IBOutlet var sliceTable: UITableView!
    @IBOutlet var sliceTableHeight: NSLayoutConstraint!
    @IBOutlet var sliceStack: UIStackView!
    
    @IBOutlet var cockTable: UITableView!
    @IBOutlet var cockTableHeight: NSLayoutConstraint!
    @IBOutlet var cockStack: UIStackView!
    
    
    @IBOutlet var submit: UIButton!
    
    
    var SacrificeInfo : SacrificesDetails?
    var isSacrificeEdit = false
    var sizeArr = 1
    var packageArr = 1
    var sliceArr = 1
    var cockArr = 1
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        navigationItem.title = "إضافة الذبائح"
        bio.clipsToBounds = true
        myPicController.delegate = self
        if isSacrificeEdit{
            navigationItem.title = "تعديل الذبائح"
            submit.setTitle("حفظ التعديلات", for: .normal)
            setupDataToEdit()
        }
        setupBackButtonWithDismiss()
        checkExistImage()
    }
    func updateConstraints() {
        sizeTableHeight.constant = CGFloat(sizeArr * 70)
        sliceTableHeight.constant = CGFloat(sliceArr * 70)
        packageTableHeight.constant = CGFloat(packageArr * 70)
        cockTableHeight.constant = CGFloat(cockArr * 70)
    }
    
    func setupDataToEdit(){
       
        sizeArr = SacrificeInfo?.sizes?.count ?? 0
        packageArr = SacrificeInfo?.packages?.count ?? 0
        sliceArr = SacrificeInfo?.slices?.count ?? 0
        cockArr = SacrificeInfo?.cocking?.count ?? 0
      
        SacrificeName.text = SacrificeInfo?.name ?? ""
        bio.text = SacrificeInfo?.description ?? ""
        if let imageUrl = SacrificeInfo?.imagePath{
             image.sd_setImage(with: URL(string: imageUrl))
        }
        minPrice.text = SacrificeInfo?.mincementPrice ?? ""
        head.isOn = SacrificeInfo?.head ?? false
        shin.isOn = SacrificeInfo?.shin ?? false
        bowels.isOn = SacrificeInfo?.bowels ?? false
        
        updateConstraints()
    }
    
    @IBAction func SwitchControl(_ sender: UISwitch) {
        switch sender.tag {
        case 1:
          //  sizeArr = 1
            if sender.isOn{
                sizeStack.isHidden = false
            }else{
                sizeStack.isHidden = true
            }
        case 2:
          //  sliceArr = 1
            if sender.isOn{
                sliceStack.isHidden = false
            }else{
                sliceStack.isHidden = true
            }
        case 3:
           // packageArr = 1
            if sender.isOn{
                packageStack.isHidden = false
            }else{
                packageStack.isHidden = true
            }
        case 4:
           // cockArr = 1
            if sender.isOn{
                cockStack.isHidden = false
            }else{
                cockStack.isHidden = true
            }
        default:
            break
        }
       
    }

    
    @IBAction func AddMore(sender: UIButton){
        switch sender.tag {
        case 1:
            sizeArr += 1
            sizeTable.beginUpdates()
            sizeTable.insertRows(at: [IndexPath(row: sizeArr-1, section: 0)], with: .automatic)
            sizeTable.endUpdates()
        case 2:
            sliceArr += 1
            sliceTable.beginUpdates()
            sliceTable.insertRows(at: [IndexPath(row: sliceArr-1, section: 0)], with: .automatic)
            sliceTable.endUpdates()
        case 3:
            packageArr += 1
            packageTable.beginUpdates()
            packageTable.insertRows(at: [IndexPath(row: packageArr-1, section: 0)], with: .automatic)
            packageTable.endUpdates()
        case 4:
            cockArr += 1
            cockTable.beginUpdates()
            cockTable.insertRows(at: [IndexPath(row: cockArr-1, section: 0)], with: .automatic)
            cockTable.endUpdates()
        default:
            break
        }
       
        updateConstraints()
    }
    func checkExistImage(){
        if image.image != #imageLiteral(resourceName: "ic_upload_img"){
            self.ImageLabel.isHidden = true
            self.image.contentMode = .scaleToFill
        }else{
            self.ImageLabel.isHidden = false
            self.image.contentMode = .scaleAspectFit
        }
    }
    @IBAction func pickImages(_ sender: UIButton) {
            checkPermission()
    }
        
    @objc  func imagePickerController(_ picker: UIImagePickerController,didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        self.image.image = image
        checkExistImage()
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
        
    
    @IBAction func AddNewSac(_ sender: UIButton) {
        loading()
        
        
        var url = AppDelegate.url+"add-sacrifice"
        if isSacrificeEdit{
            url = AppDelegate.url+"edit-sacrifice/\(SacrificeInfo?.id ?? 0)"
        }
        let headers = [ "Content-Type": "application/json" ,
                        "Accept" : "application/json",
                        "Authorization": "Bearer " + (CashedData.getAdminApiKey() ?? "")
                        
        ]
        var shinInt:Int = 0
        var headInt:Int = 0
        var bowelsInt:Int = 0
        if self.shin.isOn{
            shinInt = 1
        }
        if self.head.isOn{
            headInt = 1
        }
        if self.bowels.isOn{
            bowelsInt = 1
        }
        
        var info:[String : Any] = [
            "name": self.SacrificeName.text ?? "",
            "description": self.bio.text ?? "",
            "price": "1",
            "mincement_price": self.minPrice.text ?? "",
            "shin": "\(shinInt)",
            "head": "\(headInt)",
            "bowels": "\(bowelsInt)",
        ]
        if sizeStack.isHidden == false{
            for index in 0..<self.sizeArr{
                let cell = self.sizeTable.cellForRow(at: IndexPath(row: index, section: 0))  as! AddSacCell
                    info["sizes[\(index)][name]"] = cell.name.text
                    info["sizes[\(index)][price]"] = cell.price.text
                if self.sizeArr == 1 && cell.name.text == "" && cell.price.text == ""{
                    self.stopAnimating()
                     self.present(common.makeAlert(message: "يجب عليك إضافة حجم الذبيحة اولا"), animated: true,completion: nil)
                
                    return
                }
            }
        }else{
            self.stopAnimating()
            self.present(common.makeAlert(message: "يجب عليك إضافة حجم الذبيحة اولا"), animated: true,completion: nil)
            return
        }
        
        if sliceStack.isHidden == false{
            for index in 0..<self.sliceArr{
                let cell = self.sliceTable.cellForRow(at: IndexPath(row: index, section: 0))  as! AddSacCell
                info["slices[\(index)][name]"] = cell.name.text
                info["slices[\(index)][price]"] = cell.price.text
            }
        }
        
        if packageStack.isHidden == false{
            for index in 0..<self.packageArr{
                let cell = self.packageTable.cellForRow(at: IndexPath(row: index, section: 0))  as! AddSacCell
                info["packages[\(index)][name]"] = cell.name.text
                info["packages[\(index)][price]"] = cell.price.text
            }
        }
        
        if cockStack.isHidden == false{
            for index in 0..<self.cockArr{
                let cell = self.cockTable.cellForRow(at: IndexPath(row: index, section: 0))  as! AddSacCell
                info["cockings[\(index)][name]"] = cell.name.text
                info["cockings[\(index)][price]"] = cell.price.text
            }
        }
        
        AlamofireRequests.UserSignUp(url: url, info: info, images: [], CompanyImage: self.image.image, coverImage: nil, idImage: nil, licenseImage: nil, headers: headers) {
            (error, success , jsonData) in
            do {
                let decoder = JSONDecoder()
                let dataRecived = try decoder.decode(ErrorHandle.self, from: jsonData)
                if error == nil{
                    if success{
                        if self.isSacrificeEdit{
                           self.present(common.makeAlert(message: "تم تعديل الذبيحة"), animated: true, completion: nil)
                        }else{
                            self.present(common.makeAlert(message: "تم إضافة الذبيحة"), animated: true, completion: nil)
                        }
                        
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
                 self.stopAnimating()
            }
        }
    }
    
    
}



extension AddSacrifices: UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case sizeTable:
           return sizeArr
        case sliceTable:
            return sliceArr
        case packageTable :
           return packageArr
        default:
            return cockArr
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableView {
        case sizeTable:
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddSize", for: indexPath) as!
            AddSacCell
            if isSacrificeEdit && indexPath.row < (SacrificeInfo?.sizes?.count ?? 0){
                cell.name.text = SacrificeInfo?.sizes?[indexPath.row].name ?? ""
                cell.price.text = SacrificeInfo?.sizes?[indexPath.row].price ?? ""
            }else{
                cell.name.text = ""
                cell.price.text = ""
            }
            return cell
        case packageTable:
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddPackage", for: indexPath) as!
            AddSacCell
            if isSacrificeEdit && indexPath.row < (SacrificeInfo?.packages?.count ?? 0){
                cell.name.text = SacrificeInfo?.packages?[indexPath.row].name ?? ""
                cell.price.text = SacrificeInfo?.packages?[indexPath.row].price ?? ""
            }else{
                cell.name.text = ""
                cell.price.text = ""
            }
            return cell
        case sliceTable:
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddSlice", for: indexPath) as!
            AddSacCell
            if isSacrificeEdit && indexPath.row < (SacrificeInfo?.slices?.count ?? 0){
                cell.name.text = SacrificeInfo?.slices?[indexPath.row].name ?? ""
                cell.price.text = SacrificeInfo?.slices?[indexPath.row].price ?? ""
            }else{
                cell.name.text = ""
                cell.price.text = ""
            }
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddCock", for: indexPath) as!
            AddSacCell
            if isSacrificeEdit && indexPath.row < (SacrificeInfo?.cocking?.count ?? 0){
                cell.name.text = SacrificeInfo?.cocking?[indexPath.row].name ?? ""
                cell.price.text = SacrificeInfo?.cocking?[indexPath.row].price ?? ""
            }else{
                cell.name.text = ""
                cell.price.text = ""
            }
            return cell
        }
    }
}

