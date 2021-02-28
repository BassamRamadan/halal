//
//  common.swift
//  Tourist-Guide
//
//  Created by mac on 11/28/19.
//  Copyright © 2019 Tamkeen. All rights reserved.
//
import UIKit
import NVActivityIndicatorView
import PopupDialog

class common : UIViewController , NVActivityIndicatorViewable{
    
    let line = UIView()
    class func openNotify(sender : Any){
        let storyboard = UIStoryboard(name: "MyAccount", bundle: nil)
        let linkingVC = storyboard.instantiateViewController(withIdentifier: "MyAccountViewController")
        (sender as AnyObject).show(linkingVC, sender: sender)
    }
    fileprivate func addLineOnTopAsShadow() {
        line.backgroundColor = UIColor(named: "AddBackground")
        view.addSubview(line)
        line.translatesAutoresizingMaskIntoConstraints = false
        line.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        line.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        line.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        line.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        
        addLineOnTopAsShadow()
    }
    static func addcrafs(_ view: UIView,topAnchor: NSLayoutAnchor<NSLayoutYAxisAnchor>) {
        let containerView = UIImageView(image: #imageLiteral(resourceName: "ic_grass").withRenderingMode(.alwaysOriginal))
        view.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        containerView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        // anchor your view right above the tabBar
        containerView.bottomAnchor.constraint(equalTo: topAnchor).isActive = true
        
        containerView.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    class func drowbackButton()->UIButton {
        let notifBtn: UIButton = UIButton(type: UIButton.ButtonType.custom)
        notifBtn.setImage(UIImage(named: "ic_back"), for: [])
        notifBtn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        return notifBtn
        // Do any additional setup after loading the view
    }
    class func drowCartButton()->UIButton {
        let notifBtn: UIButton = UIButton(type: UIButton.ButtonType.custom)
        notifBtn.setImage(UIImage(named: "ic_cart"), for: [])
        notifBtn.frame = CGRect(x: 0, y: 0, width: 35, height: 35)
        notifBtn.backgroundColor = UIColor(named: "green")
        notifBtn.layer.cornerRadius = 5
        return notifBtn
        // Do any additional setup after loading the view
    }
    class func drowCartNumber()->UIButton {
        let notifBtn: UIButton = UIButton(type: UIButton.ButtonType.custom)
        notifBtn.backgroundColor = UIColor(named: "VividOrange")
        notifBtn.frame = CGRect(x: 45, y: 0, width: 30, height: 30)
        notifBtn.layer.cornerRadius = 15
        notifBtn.layer.masksToBounds = false
        return notifBtn
        // Do any additional setup after loading the view
    }
    class func drowSettingButton()->UIButton {
        let notifBtn: UIButton = UIButton(type: UIButton.ButtonType.custom)
        notifBtn.setImage(UIImage(named: "ic_settings"), for: [])
        notifBtn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        return notifBtn
        // Do any additional setup after loading the view
    }
    class func openback(sender : UINavigationController){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let linkingVC = storyboard.instantiateViewController(withIdentifier: "LanuchScreenViewController")
        sender.present(linkingVC, animated: true, completion: nil)
        sender.popViewController(animated: true)
        sender.dismiss(animated: true, completion: nil)
    }
    
    class func setNavigationShadow(navigationController: UINavigationController?){
        navigationController?.navigationBar.layer.shadowColor = UIColor.gray.cgColor
        navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        navigationController?.navigationBar.layer.shadowRadius = 4.0
        navigationController?.navigationBar.layer.shadowOpacity = 0.7
        navigationController?.navigationBar.layer.masksToBounds = false
    }
    class func isSaloonLogedin()-> Bool{
        let token = CashedData.getAdminApiKey() ?? ""
        if token.isEmpty{
            return false
        }else{
            return true
        }
        
    }
    class func isAdminLogedin()-> Bool{
        let token = CashedData.getAdminApiKey() ?? ""
        if token.isEmpty{
            return false
        }else{
            return true
        }
        
    }
    
    class func AdminLogout(currentController: UIViewController){
            CashedData.saveAdminApiKey(token: "")
            CashedData.saveUserPassword(name: "")
            openMain()
    }
    
    func loading(_ message:String = ""){
        let size = CGSize(width: 30, height: 30)
        startAnimating(size, message: "", type: NVActivityIndicatorType.lineSpinFadeLoader)
    }
    
    class func makeAlert( message: String = "عفوا حدث خطأ في الاتصال من فضلك حاول مره آخري") -> UIAlertController {
        let alert = UIAlertController(title: "Alert", message: message , preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
            switch action.style{
            case .default,.cancel,.destructive:
                print("default")
            @unknown default:
                print("default")
            }}))
        return alert
    }
    func CallPhone(phone: String) {
        var fullMob: String = phone
        fullMob = fullMob.replacingOccurrences(of: " ", with: "")
        fullMob = fullMob.replacingOccurrences(of: "+", with: "")
        fullMob = fullMob.replacingOccurrences(of: "-", with: "")
        if fullMob != "" {
            let url = NSURL(string: "tel://\(fullMob)")!
            UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
        }
    }
    class func callWhats(whats: String,currentController: UIViewController) {
        var fullMob: String = whats
        fullMob = fullMob.replacingOccurrences(of: " ", with: "")
        fullMob = fullMob.replacingOccurrences(of: "+", with: "")
        fullMob = fullMob.replacingOccurrences(of: "-", with: "")
        let urlWhats = "https://wa.me/\(fullMob)"
        
        if let urlString = urlWhats.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed) {
            if let whatsappURL = NSURL(string: urlString) {
                if UIApplication.shared.canOpenURL(whatsappURL as URL) {
                    UIApplication.shared.open(whatsappURL as URL, options: [:], completionHandler: { (Bool) in
                    })
                } else {
                    currentController.present(common.makeAlert(message:NSLocalizedString("WhatsApp Not Found on your device", comment: "")), animated: true, completion: nil)
                }
            }
        }
    }
    func setupSettingButton() {
        self.navigationItem.hidesBackButton = true
        let backBtn: UIButton = common.drowSettingButton()
        let backButton = UIBarButtonItem(customView: backBtn)
        self.navigationItem.setRightBarButton(backButton, animated: true)
        backBtn.addTarget(self, action: #selector(self.AuthToOpenSetting), for: UIControl.Event.touchUpInside)
    }
    @objc func AuthToOpenSetting() {
        if common.isAdminLogedin(){
            common.OpenSetting()
        }else{
            showCustomDialog()
        }
    }
    func setupCartButton(number :Int) {
        self.navigationItem.hidesBackButton = true
        let backBtn: UIButton = common.drowCartButton()
        let backButton = UIBarButtonItem(customView: backBtn)
        if number != 0{
            backBtn.addBadge(number: number, withOffset: CGPoint(x: -3, y: -3), andBackgroundColor: UIColor(named: "VividOrange") ?? UIColor.red, strokeColor: UIColor.white, textColor:
                UIColor.white)
        }
        backBtn.addTarget(self, action: #selector(self.OpenCart), for: UIControl.Event.touchUpInside)
        self.navigationItem.setLeftBarButton(backButton, animated: true)
    }
    
    func setupBackButtonWithPOP() {
        self.navigationItem.hidesBackButton = true
        let backBtn: UIButton = common.drowbackButton()
        let backButton = UIBarButtonItem(customView: backBtn)
        self.navigationItem.setRightBarButton(backButton, animated: true)
        backBtn.addTarget(self, action: #selector(self.POP), for: UIControl.Event.touchUpInside)
    }
    
    func setupBackButtonWithDismiss() {
        self.navigationItem.hidesBackButton = true
        let backBtn: UIButton = common.drowbackButton()
        let backButton = UIBarButtonItem(customView: backBtn)
        self.navigationItem.setRightBarButton(backButton, animated: true)
        backBtn.addTarget(self, action: #selector(self.Dismiss), for: UIControl.Event.touchUpInside)
    }
    
    @objc func Dismiss() {
        self.navigationController?.dismiss(animated: true)
    }
   
    @objc func POP() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func showCustomDialog(animated: Bool = true) {
        // Create a custom view controller
        let loginVC = LoginViewController(nibName: "loginViewController", bundle: nil)
        
        // Create the dialog
        let popup = PopupDialog(viewController: loginVC,
                                buttonAlignment: .horizontal,
                                transitionStyle: .bounceDown,
                                tapGestureDismissal: false,
                                panGestureDismissal: false)
        present(popup, animated: animated, completion: nil)
    }
    
    class func OpenSetting(){
        let storyboard = UIStoryboard(name: "Setting", bundle: nil)
        let linkingVC = storyboard.instantiateViewController(withIdentifier: "Setting") as! Setting
        linkingVC.modalPresentationStyle = .fullScreen
        let appDelegate = UIApplication.shared.delegate
        appDelegate?.window??.rootViewController = linkingVC
    }
    
    class func openMain(){
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let linkingVC = storyboard.instantiateViewController(withIdentifier: "Main") as! MainController
        linkingVC.modalPresentationStyle = .fullScreen
        let appDelegate = UIApplication.shared.delegate
        appDelegate?.window??.rootViewController = linkingVC
    }
   
    @objc func OpenCart() {
        let storyboard = UIStoryboard(name: "Cart", bundle: nil)
        let linkingVC = storyboard.instantiateViewController(withIdentifier: "CartNav") as!
        UINavigationController
        linkingVC.modalPresentationStyle = .fullScreen
        self.present(linkingVC,animated: true,completion: nil)
    }
    
  
    
    
    
    
    func getRegions(completion : @escaping (_ dataRecived: [Details]) -> Void){
        loading()
        let url = AppDelegate.url + "areas"
        let headers = [
            "Accept" : "application/json",
            "Content-Type": "application/json"
        ]
        AlamofireRequests.getMethod(url: url, headers:headers) { (error, success , jsonData) in
            do {
                let decoder = JSONDecoder()
                let dataRecived = try decoder.decode(City.self, from: jsonData)
                if error == nil{
                    if success{
                        completion(dataRecived.data)
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
                self.present(common.makeAlert(message: "حدث خطأ بالرجاء التاكد من اتصالك بالانترنت "), animated: true, completion: nil)
                self.stopAnimating()
            }
        }
        
    }
    
    
    func getCities(RegionId: Int? , completion : @escaping (_ dataRecived: [Details]) -> Void){
        loading()
        let url = AppDelegate.url + "cities/\(RegionId ?? 0)"
        let headers = [
            "Accept" : "application/json",
            "Content-Type": "application/json"
        ]
        AlamofireRequests.getMethod(url: url, headers:headers) { (error, success , jsonData) in
            do {
                let decoder = JSONDecoder()
                let dataRecived = try decoder.decode(City.self, from: jsonData)
                if error == nil{
                    if success{
                        completion(dataRecived.data)
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
                self.present(common.makeAlert(message: "حدث خطأ بالرجاء التاكد من اتصالك بالانترنت "), animated: true, completion: nil)
                self.stopAnimating()
            }
        }
    }
}
extension CAShapeLayer {
    func drawCircleAtLocation(location: CGPoint, withRadius radius: CGFloat, andColor color: UIColor,stokColor:UIColor) {
        fillColor = color.cgColor
        strokeColor = stokColor.cgColor
        let origin = CGPoint(x: location.x - radius, y: location.y - radius)
        path = UIBezierPath(ovalIn: CGRect(origin: origin, size: CGSize(width: radius * 2, height: radius * 2))).cgPath
    }
}
extension UIButton{
    public func addBadge(number: Int, withOffset offset: CGPoint = CGPoint.zero, andBackgroundColor color: UIColor, strokeColor: UIColor,textColor:UIColor) {
       
        guard let view = self as? UIView else { return }
        
        // badgeLayer?.removeFromSuperlayer()
        
        // Initialize Badge
        let badge = CAShapeLayer()
        let radius = CGFloat(8)
        let location = CGPoint(x: view.frame.width - (radius + offset.x), y: (radius + offset.y))
        badge.drawCircleAtLocation(location: location, withRadius: radius, andColor: color, stokColor: strokeColor)
        view.layer.addSublayer(badge)
        
        // Initialiaze Badge's label
        let label = CATextLayer()
        label.string = "\(number)"
        label.alignmentMode = CATextLayerAlignmentMode.center
        if number > 9 {
            label.fontSize = 9
            label.font = UIFont(name:"HelveticaNeue-Bold", size: 9)!
            label.frame = CGRect(origin: CGPoint(x: location.x - 5, y: offset.y+2), size: CGSize(width: 10, height: 16))
        }else{
            label.fontSize = 11
            label.font = UIFont(name:"HelveticaNeue-Bold", size: 11)!
            label.frame = CGRect(origin: CGPoint(x: location.x - 5, y: offset.y+1), size: CGSize(width: 10, height: 16))
        }
        label.foregroundColor = textColor.cgColor
        label.backgroundColor = UIColor.clear.cgColor
        label.contentsScale = UIScreen.main.scale
        badge.addSublayer(label)
        var handle: UInt8 = 0
        // Save Badge as UIBarButtonItem property
        objc_setAssociatedObject(self, &handle, badge, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
}
