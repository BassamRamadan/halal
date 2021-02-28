//
//  MoreClasses.swift
//  Tourist-Guide
//
//  Created by Bassam Ramadan on 11/8/19.
//  Copyright © 2019 Bassam Ramadan. All rights reserved.
//

import UIKit

class Shadow: UIView {
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.masksToBounds = false
    }
}
class ViewShadow: UIView {
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 5
        clipsToBounds = true
        layer.masksToBounds = false
    }
}
class ViewBorder: UIView {
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 5
        clipsToBounds = true
        layer.borderWidth = 2.5
        layer.borderColor = UIColor(named: "AddBackground")?.cgColor
        layer.masksToBounds = false
    }
}
class TextFieldShadow: UITextField {
    
    let padding = UIEdgeInsets(top: 0,left: 15,bottom: 0,right: 15)
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 5
        clipsToBounds = true
        layer.masksToBounds = false
        backgroundColor = UIColor(named: "AddBackground")
    }
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
      return bounds.inset(by: padding)
    }
}
class TextViewShadow: UITextView {
    override func awakeFromNib() {
        super.awakeFromNib()
        textContainerInset = UIEdgeInsets(top: 8, left: 10, bottom: 8, right: 10)
        layer.cornerRadius = 5
        clipsToBounds = true
        layer.masksToBounds = true
    }
}
class ButtonShadow: UIButton {
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 5
        clipsToBounds = true
        layer.masksToBounds = false
    }
}
class imageShadow: UIImageView {
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 5
        clipsToBounds = true
        clipsToBounds = true
    }
}

class cellShadow: UIView {
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.masksToBounds = false
    }
}
