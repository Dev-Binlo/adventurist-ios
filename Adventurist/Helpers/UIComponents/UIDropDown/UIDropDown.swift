//
//  UIDropDown.swift
//  Azerfon
//
//  Created by AbdulRehman Warraich on 2/19/19.
//  Copyright © 2019 Evamp&Saanga. All rights reserved.
//

import UIKit
import SnapKit

//@IBDesignable
class UIDropDown: UIControl {

    fileprivate var title: UILabel = UILabel()
    fileprivate var imageView: UIImageView = UIImageView()
    fileprivate var sepratorView: UIView = UIView()
    open var dropDown = DropDown()
    fileprivate var didSelectOption: SelectionClosure?


    @IBInspectable public var placeholder: String? {
        didSet {
            title.text = placeholder ?? ""
        }
    }
    @IBInspectable public var text: String? {
        set {
            title.text = newValue
        }
        get {
            return title.text
        }
    }
    
    @IBInspectable public var sepatorColor: UIColor = UIColor.purple {
        didSet {
            sepratorView.backgroundColor = sepatorColor
        }
    }


    @IBInspectable public var rightImage: UIImage? {
        didSet {
            setup()
        }
    }

    @IBInspectable public var applyTintColor: Bool = true {
        didSet {
            setup()
        }
    }
    // Init
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        setup()
    }

    public var dataSource = [String]() {
        didSet {
            dropDown.dataSource = self.dataSource
        }
    }

    func reloadAllComponents() {
        dropDown.reloadAllComponents()
        title.text = placeholder ?? ""
    }

    fileprivate func setup() {
        //self.layer.borderColor = UIColor.mbBorderGray.cgColor
        self.layer.borderColor = UIColor.clear.cgColor
        self.layer.borderWidth = 1

        title.textAlignment = .left
        self.addSubview(title)

        if rightImage != nil {

            imageView.image = rightImage
            imageView.contentMode = .scaleAspectFit

            if self.applyTintColor == true {
                imageView.image = imageView.image?.withRenderingMode(.alwaysTemplate)
                self.imageView.tintColor = UIColor.lightGray
            } else {
                self.imageView.tintColor = UIColor.clear
            }

            self.addSubview(imageView)

            imageView.snp.remakeConstraints { (make) in
                make.right.equalTo(self.snp.right).offset(-4)
                make.top.equalTo(self.snp.top).offset(4)
                make.bottom.equalTo(self.snp.bottom).offset(-4)
                make.width.equalTo(self.snp.height).offset(-12)
            }
        } else {

            imageView.removeFromSuperview()
        }

        title.snp.remakeConstraints { (make) in
            make.left.equalTo(self.snp.left).offset(2)
            make.top.equalTo(self.snp.top)
            make.bottom.equalTo(self.snp.bottom).offset(-2)
            if rightImage != nil {
                make.right.equalTo(self.imageView.snp.left).offset(-4)
            } else {
                make.right.equalTo(self.snp.right)
            }
        }
        
        self.addSubview(sepratorView)
        self.bringSubviewToFront(sepratorView)
        sepratorView.backgroundColor = sepatorColor
        
        sepratorView.snp.remakeConstraints { (make) in
            make.left.equalTo(self.snp.left)
            make.bottom.equalTo(self.snp.bottom)
            make.right.equalTo(self.snp.right)
            make.height.equalTo(2)
        }
        
        self.addTarget(self, action: #selector(touchAction), for: .touchUpInside)



        // The view to which the drop down will appear on
        dropDown.anchorView = self
        dropDown.dismissMode = .automatic
        dropDown.direction = .bottom
        dropDown.bottomOffset = CGPoint(x: 0, y:(dropDown.anchorView?.plainView.bounds.height)!)
        dropDown.dataSource = []

        title.font = UIFont.systemFont(ofSize: 13)
        title.textColor = UIColor.black

        dropDown.textFont = UIFont.systemFont(ofSize: 12)
        dropDown.textColor = UIColor.darkGray
        dropDown.backgroundColor = UIColor.lightText
        dropDown.cellHeight = 34
        dropDown.separatorColor = UIColor.clear
        dropDown.selectionBackgroundColor = .gray

        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.title.text = item
            if self.didSelectOption != nil {
                self.didSelectOption?(index,item)
            }
        }

        dropDown.cancelAction = { [unowned self] in
            if self.applyTintColor == true {
                self.imageView.tintColor = UIColor.blue
            } else {
                self.imageView.tintColor = .clear
            }
        }

        dropDown.willShowAction = { [unowned self] in
            if self.applyTintColor == true {
                self.imageView.tintColor = UIColor.black
            } else {
                self.imageView.tintColor = .clear
            }
        }


    }

    @objc fileprivate func touchAction() {
        dropDown.show()
        DropDown.startListeningToKeyboard()
    }

    public func didSelectOption(_ selectionBlock: @escaping SelectionClosure) {
        didSelectOption = selectionBlock
    }
    
}
