//
//  SacrificeDetails.swift
//  ezhelhaa
//
//  Created by Bassam Ramadan on 3/29/20.
//  Copyright © 2020 Bassam Ramadan. All rights reserved.
//

import UIKit
import DropDown
class SacrificeDetailsController: common {
    
    // MARK:- Outlets
    @IBOutlet var CartItemsNumber : UILabel!
    @IBOutlet var SacName : UILabel!
    
    @IBOutlet var cocking: UIButton!
    @IBOutlet var slices: UIButton!
    @IBOutlet var sizes: UIButton!
    @IBOutlet var Packaging: UIButton!
    @IBOutlet var SacrificeName: UILabel!
    @IBOutlet var SacrificeBio: UILabel!
    @IBOutlet var SacrificeImage: UIImageView!
    @IBOutlet var quantity: UILabel!
    @IBOutlet var mincementQuantity: UILabel! // الفورم
    @IBOutlet var head: UIButton! // رقبه
    @IBOutlet var shin: UIButton! // كوارع
    @IBOutlet var bowels: UIButton! // أمعاء
    @IBOutlet var Notes: UITextView!
    @IBOutlet var Price: UILabel!
    @IBOutlet var mincementPrice: UILabel!
    @IBOutlet var FullPrice: UILabel!
    
    @IBOutlet var SizeStack: UIStackView!
    @IBOutlet var CockingStack: UIStackView!
    @IBOutlet var PackageStack: UIStackView!
    @IBOutlet var SliceStack: UIStackView!
    @IBOutlet var BottomView: UIView!
    
    var SacrificeInfo : SacrificesDetails?
    var sizesObject: cockingDetails?
    var packagesObject: cockingDetails?
    var slicesObject: cockingDetails?
    var cockingObject: cockingDetails?
    
    var Option1 = false
    var Option2 = false
    var Option3 = false
    var Option4 = false
    
    var headBool: Bool = false
    var shinBool: Bool = false
    var bowelsBool: Bool = false
    
   
    var dropDrop = DropDown()
    var SacrificePrice = SacrificePrices()
    let overlay: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 110.0, height: 120))
     // MARK:- ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        line.removeFromSuperview()
        common.addcrafs(view, topAnchor: BottomView.topAnchor)
        self.navigationItem.hidesBackButton = true
        setupData()
        Notes.delegate = self
        setModules(Notes)
        overlay.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.2)
        SacrificeImage.addSubview(overlay)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        CartItemsNumber.text = "\(AppDelegate.CartItems.count)"
        CartItemsNumber.isHidden = AppDelegate.CartItems.count == 0
    }
    func setupData(){
        SacName.text = self.SacrificeInfo?.name ?? "تفاصيل الذبيحة"
        SacrificeName.text = self.SacrificeInfo?.name ?? ""
        SacrificeBio.text = self.SacrificeInfo?.description ?? ""
        SacrificeImage.sd_setImage(with: URL(string: self.SacrificeInfo?.imagePath ?? ""))
        SacrificePrice.minPrice.data = Double(self.SacrificeInfo?.mincementPrice ?? "0.0") as! Double
        
        self.head.isHidden = !(self.SacrificeInfo?.head ?? false)
        self.bowels.isHidden = !(self.SacrificeInfo?.bowels ?? false)
        self.shin.isHidden = !(self.SacrificeInfo?.shin ?? false)
        
        
        SizeStack.isHidden = (self.SacrificeInfo?.sizes?.count == 0)
        CockingStack.isHidden = (self.SacrificeInfo?.cocking?.count == 0)
        SliceStack.isHidden = (self.SacrificeInfo?.slices?.count == 0)
        PackageStack.isHidden = (self.SacrificeInfo?.packages?.count == 0)
    }
    
    func setupFullPrice(){
         if Option1 || Option2 || Option3 || Option4{
            self.Price.text = "\(self.SacrificePrice.totalSelected)".replacingOccurrences(of: ".00", with: "")
            self.quantity.text = "\(Int(self.SacrificePrice.qantity.data)) ذبيحة"
            self.FullPrice.text = "\(self.SacrificePrice.totalCost)"
        }
        self.mincementQuantity.text = "\(Int(self.SacrificePrice.minQuantity.data)) كيلو"
        self.mincementPrice.text = "\(self.SacrificePrice.totalMinSelected)".replacingOccurrences(of: ".00", with: "")
    }
       
    @IBAction func dropDown(_ sender: UIButton) {
        dropDrop.anchorView = (sender as AnchorView)
        switch  sender.tag{
        case 1:
            dropDrop.dataSource = parsingData(self.SacrificeInfo?.sizes ?? [])
        case 2:
            dropDrop.dataSource = parsingData(self.SacrificeInfo?.slices ?? [])
        case 3:
            dropDrop.dataSource = parsingData(self.SacrificeInfo?.packages ?? [])
        case 4:
            dropDrop.dataSource = parsingData(self.SacrificeInfo?.cocking ?? [])
        default:
            break
        }
        
        dropDrop.bottomOffset = CGPoint(x: 0, y:(dropDrop.anchorView?.plainView.bounds.height)!)
        dropDrop.selectionAction = {
            [unowned self](index : Int , item : String) in
            sender.setTitle(item, for: .normal)
            
            switch  sender.tag{
            case 1:
                self.Option1 = true
                self.sizesObject = self.SacrificeInfo?.sizes?[index]
                if let p = self.SacrificeInfo?.sizes?[index].price{
                    self.SacrificePrice.sizePrice.data = Double(p) ?? 0.0
                }
            case 2:
                self.Option2 = true
                self.packagesObject = self.SacrificeInfo?.slices?[index]
                if let p = self.SacrificeInfo?.slices?[index].price{
                    self.SacrificePrice.slicePrice.data = Double(p) ?? 0.0
                }
            case 3:
                self.Option3 = true
                self.slicesObject = self.SacrificeInfo?.packages?[index]
                if let p = self.SacrificeInfo?.packages?[index].price{
                    self.SacrificePrice.packagePrice.data = Double(p) ?? 0.0
                }
            case 4:
                self.Option4 = true
                self.cockingObject = self.SacrificeInfo?.cocking?[index]
                if let p = self.SacrificeInfo?.cocking?[index].price{
                    self.SacrificePrice.cockPrice.data = Double(p) ?? 0.0
                }
            default:
                break
            }
            if self.SacrificePrice.qantity.data == 0{
                self.SacrificePrice.qantity.data = 1
            }
            self.setupFullPrice()
        }
        dropDrop.show()
    }
    fileprivate func parsingData(_ data : [cockingDetails])->[String]{
        var ResData = [String]()
        for x in data {
            ResData.append("\(x.name ?? "")  -  \(x.price?.replacingOccurrences(of: ".00", with: "") ?? "..") ر.س")
        }
        return ResData
    }
    @IBAction func Checked(_ sender: UIButton){
        if sender.imageView?.image ==  #imageLiteral(resourceName: "ic_check_box"){
            sender.setImage(#imageLiteral(resourceName: "ic_check_box_checked"), for: .normal)
        }else{
            sender.setImage(#imageLiteral(resourceName: "ic_check_box"), for: .normal)
        }
        switch  sender.tag{
            case 1:
                self.headBool = !self.headBool
            case 2:
                self.shinBool = !self.shinBool
            case 3:
                self.bowelsBool =  !self.bowelsBool
            default:
                break
        }
    }
    @IBAction func Plus(_ sender: UIButton) {
        switch  sender.tag{
        case 1:
            if Option1 || Option2 || Option3 || Option4{
                self.SacrificePrice.qantity.data = self.SacrificePrice.qantity.data + 1
            }else{
                self.present(common.makeAlert(message: "يجب عليك أختيار نوعية الذبيحة ومواصفاتيها اولا"), animated: true,completion: nil)
            }
        case 2:
            self.SacrificePrice.minQuantity.data = self.SacrificePrice.minQuantity.data + 1
        default:
            break
        }
        self.setupFullPrice()
    }
    
    @IBAction func Minus(_ sender: UIButton) {
        switch  sender.tag{
            case 1:
                if Option1 || Option2 || Option3 || Option4 {
                    self.SacrificePrice.qantity.data = self.SacrificePrice.qantity.data - 1
                }else{
                    self.present(common.makeAlert(message: "يجب عليك أختيار نوعية الذبيحة ومواصفاتيها ا ولا"), animated: true,completion: nil)
                }
            case 2:
                self.SacrificePrice.minQuantity.data = self.SacrificePrice.minQuantity.data - 1
            default:
                break
         }
        self.SacrificePrice.qantity.data = max(0, self.SacrificePrice.qantity.data)
        self.SacrificePrice.minQuantity.data = max(0, self.SacrificePrice.minQuantity.data)
        self.setupFullPrice()
    }
    @IBAction func addToCart(_ sender: UIButton){
         if Option1 {
            let cockingOb = CartOptionDetails(id: cockingObject?.id, name: cockingObject?.name, price: cockingObject?.price, sacrificeId: cockingObject?.sacrificeId)
            
            let packageOb = CartOptionDetails(id: packagesObject?.id, name: packagesObject?.name, price: packagesObject?.price, sacrificeId: packagesObject?.sacrificeId)
            
            let sizeOb = CartOptionDetails(id: sizesObject?.id, name: sizesObject?.name, price: sizesObject?.price, sacrificeId: sizesObject?.sacrificeId)
            
            let sliceOb = CartOptionDetails(id: slicesObject?.id, name: slicesObject?.name, price: slicesObject?.price, sacrificeId: slicesObject?.sacrificeId)
            
            let category = CartData(id: SacrificeInfo?.id, name: SacrificeInfo?.name, imagePath: SacrificeInfo?.imagePath, price: SacrificePrice.totalSelected, mincementPrice: SacrificePrice.minPrice.data, shin: shinBool, head: headBool, bowels: bowelsBool, cocking: cockingOb, packages: packageOb, sizes: sizeOb, slices: sliceOb, quantity: Int(self.SacrificePrice.qantity.data), minQuantity: Int(self.SacrificePrice.minQuantity.data), totalPrice: self.SacrificePrice.totalCost, notes: Notes.text)
            
            AppDelegate.CartItems.append(category)
            CartItemsNumber.text = "\(AppDelegate.CartItems.count)"
            CartItemsNumber.isHidden = AppDelegate.CartItems.count == 0
            let encodedData = NSKeyedArchiver.archivedData(withRootObject: AppDelegate.CartItems)
            let userDefaults = UserDefaults.standard
            userDefaults.set(encodedData, forKey: "FullCartData")
            
            self.present(common.makeAlert(message: "تمت الإضافة الى العربة"), animated: true,completion: nil)
         }else{
            self.present(common.makeAlert(message: "يجب عليك أختيار حجم الذبيحة اولا"), animated: true,completion: nil)
        }
    }
    
    @IBAction func Back(sender: UIButton){
        self.navigationController?.dismiss(animated: true)
    }
    @IBAction func MoveToCart() {
        self.OpenCart()
    }
    
}
extension SacrificeDetailsController: UITextViewDelegate{
    func setModules(_ textView : UIView){
        textView.backgroundColor = UIColor(named: "textFieldBackground")
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.layer.borderWidth = 0.0
    }
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        textView.backgroundColor = .white
        textView.layer.borderWidth = 1.0
        textView.layer.borderColor = UIColor(named: "light blue")?.cgColor
        if textView.text == "ملاحظات"{
            textView.text = ""
        }
        return true
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        setModules(textView)
    }
}
enum UserDefaultsKeys: String {
    case jobCategory
}
class SacrificePrices{
    var sizePrice = SetAndGet(),slicePrice = SetAndGet(),cockPrice = SetAndGet(),packagePrice = SetAndGet(),qantity = SetAndGet(),minPrice = SetAndGet(),minQuantity = SetAndGet()
    
    var totalCost: Double {
        get {
            return ((sizePrice.data + slicePrice.data + cockPrice.data + packagePrice.data) *               qantity.data)
                    + (minPrice.data * minQuantity.data)
        }
    }
    var totalSelected: Double{
        get{
            return ((sizePrice.data + slicePrice.data + cockPrice.data + packagePrice.data) *               qantity.data )
        }
    }
    var totalMinSelected: Double{
        get{
            return (minPrice.data * minQuantity.data)
        }
    }
}
struct SetAndGet {
    var x: Double = 0.0
    var data: Double {
        get {
            return self.x
        }
        set(value) {
            self.x = value
        }
    }
}
