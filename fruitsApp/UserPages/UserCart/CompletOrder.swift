//
//  CompletOrder.swift
//  ezhelhaa
//
//  Created by Bassam Ramadan on 3/31/20.
//  Copyright © 2020 Bassam Ramadan. All rights reserved.
//

import UIKit
import DropDown
import GoogleMaps
import GooglePlaces
class CompletOrder: common , CLLocationManagerDelegate{

    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var phone: UITextField!
    @IBOutlet weak var addressOnMap: UILabel!
    @IBOutlet var BottomView: UIView!
    
    var position = CLLocationCoordinate2D(latitude: 24.662499, longitude: 46.676857)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "إتمام الشراء"
        setupBackButtonWithDismiss()
        common.addcrafs(view, topAnchor: BottomView.topAnchor)
    }
    fileprivate func Modules(){
        name.delegate = self
        phone.delegate = self
        setModules(name)
        setModules(phone)
    }
    fileprivate func setModules(_ textField : UIView){
        textField.backgroundColor = UIColor(named: "textFieldBackground")
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.borderWidth = 0.0
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MapController"{
            if let map = segue.destination as? MapController{
                map.Link = self
            }
        }
    }
    @IBAction func Submit(sender: UIButton){
        UploadCart()
    }
    func UploadCart(){
        loading()
        let url = AppDelegate.url+"add-to-cart/\(CashedData.getUserCityId() ?? 0)"
        let headers = [
            "Accept" : "application/json",
            "Content-Type": "application/json"
        ]
        var notes = ""
        var Cartitems = [itemDetails]()
        for item in AppDelegate.CartItems{
            var shin = 0
            if item.shin == true{
                shin = 1
            }
            var head = 0
            if item.head == true{
                head = 1
            }
            var bowels = 0
            if item.bowels == true{
                bowels = 1
            }
            notes += item.notes ?? ""
            Cartitems.append(itemDetails(quantity: item.quantity, mincement_quantity: item.minQuantity, wants_shin: shin, wants_head: head, wants_bowels: bowels, sacrifice_id: item.id, sacrifice_size_id: item.sizes?.id, sacrifice_slice_id: item.slices?.id, sacrifice_package_id: item.packages?.id, sacrifice_cocking_id: item.cocking?.id))
        }
        
        let x = SendCartData(user_name: name.text ?? "", user_phone: phone.text ?? "", address: addressOnMap.text ?? "" , lat: "\(position.latitude)", lon: "\(position.longitude)", notes: notes, area_id: CashedData.getUserRegionId() ?? 0, city_id: CashedData.getUserCityId() ?? 0, items: Cartitems)
        
        let data = try! JSONEncoder.init().encode(x)
        let dictionaryy = try! JSONSerialization.jsonObject(with: data) as! [String: Any]
        
        AlamofireRequests.PostMethod(methodType: "POST", url: url, info: dictionaryy, headers: headers){ (error, success , jsonData) in
            do {
                let decoder = JSONDecoder()
                let dataRecived = try decoder.decode(ErrorHandle.self, from: jsonData)
                if error == nil{
                    if success{
                        AppDelegate.CartItems.removeAll()
                        AppDelegate.updateCartItems()
                        
                        let storyboard = UIStoryboard(name: "sendSuccessfully", bundle: nil)
                        let linkingVC = storyboard.instantiateViewController(withIdentifier: "sendSuccessfully") as! UINavigationController
                        let appDelegate = UIApplication.shared.delegate
                        appDelegate?.window??.rootViewController = linkingVC
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
extension CompletOrder : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        textField.backgroundColor = .white
        textField.layer.borderWidth = 1.0
        textField.layer.borderColor = UIColor(named: "light blue")?.cgColor
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        setModules(textField)
    }
}
struct SendCartData: Codable{
    init(user_name: String?, user_phone: String?,address: String?,lat: String?,lon: String?,notes: String?,area_id: Int?,city_id: Int?,items: [itemDetails]?) {
        self.user_name = user_name
        self.user_phone = user_phone
        self.address = address
        self.lat = lat
        self.lon = lon
        self.notes = notes
        self.area_id = area_id
        self.city_id = city_id
        self.items = items
    }
    
    var user_name: String?
    var user_phone: String?
    var address: String?
    var lat: String?
    var lon: String?
    var notes: String?
    var city_id: Int?
    var area_id: Int?
    let items: [itemDetails]?
}
struct itemDetails: Codable{
    internal init(quantity: Int?, mincement_quantity: Int?, wants_shin: Int?, wants_head: Int?, wants_bowels: Int?, sacrifice_id: Int?, sacrifice_size_id: Int?, sacrifice_slice_id: Int?, sacrifice_package_id: Int?, sacrifice_cocking_id: Int?) {
        self.quantity = quantity
        self.mincement_quantity = mincement_quantity
        self.wants_shin = wants_shin
        self.wants_head = wants_head
        self.wants_bowels = wants_bowels
        self.sacrifice_id = sacrifice_id
        self.sacrifice_size_id = sacrifice_size_id
        self.sacrifice_slice_id = sacrifice_slice_id
        self.sacrifice_package_id = sacrifice_package_id
        self.sacrifice_cocking_id = sacrifice_cocking_id
    }
    
    var quantity: Int?
    var mincement_quantity: Int?
    var wants_shin: Int?
    var wants_head: Int?
    var wants_bowels: Int?
    var sacrifice_id: Int?
    var sacrifice_size_id: Int?
    var sacrifice_slice_id: Int?
    var sacrifice_package_id: Int?
    var sacrifice_cocking_id: Int?
}
