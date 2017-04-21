//
//  YSMessageVC.swift
//  YSTabBarOutSide
//
//  Created by yaoshuai on 2017/1/12.
//  Copyright © 2017年 ys. All rights reserved.
//

import UIKit

class YSMessageVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(red: CGFloat(arc4random_uniform(256)) / 255.0, green: CGFloat(arc4random_uniform(256)) / 255.0, blue: CGFloat(arc4random_uniform(256)) / 255.0, alpha: 1)
    }

}
