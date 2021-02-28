//
//  sendSuccessful.swift
//  fruitsApp
//
//  Created by Bassam Ramadan on 11/5/20.
//  Copyright © 2020 Bassam Ramadan. All rights reserved.


import UIKit

class sendSuccessfully: common{
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBackButtonWithDismiss()
    }
    func drowbackIconButton()->UIButton {
        let notifBtn: UIButton = UIButton(type: UIButton.ButtonType.custom)
        notifBtn.setImage(UIImage(named: "ic_back_icon"), for: [])
        notifBtn.setTitle("الرئيسية  ", for: .normal)
        notifBtn.setTitleColor(.black, for: .normal)
        notifBtn.semanticContentAttribute = .forceRightToLeft
        notifBtn.frame = CGRect(x: 0, y: 0, width: 50, height: 30)
        return notifBtn
        // Do any additional setup after loading the view
    }
    override func setupBackButtonWithDismiss() {
        self.navigationItem.hidesBackButton = true
        let backBtn: UIButton = drowbackIconButton()
        let backButton = UIBarButtonItem(customView: backBtn)
        self.navigationItem.setRightBarButton(backButton, animated: true)
        backBtn.addTarget(self, action: #selector(self.Dismiss), for: UIControl.Event.touchUpInside)
    }
    @objc override func Dismiss() {
        common.openMain()
    }
    
    @IBAction func main(){
        common.openMain()
    }
    
}
