//
//  YSNavigationVC.swift
//  YSTabBarOutSide
//
//  Created by yaoshuai on 2017/1/12.
//  Copyright © 2017年 ys. All rights reserved.
//

import UIKit

extension UIBarButtonItem{
    
    convenience init?(title:String, imageName:String? = nil, target:Any?, action:Selector) {
        
        self.init()
        
        let button = UIButton()
        if imageName != nil {
            button.setImage(UIImage(named:imageName!), for: .normal)
        }
        
        button.addTarget(target, action: action, for: .touchUpInside)
        
        button.setTitle(title, for: .normal)
        button.setTitleColor(UIColor.darkGray, for: .normal)
        button.setTitleColor(UIColor.orange, for: .highlighted)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.sizeToFit()
        
        customView = button
    }
}

class YSNavigationVC: UINavigationController,UIGestureRecognizerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 设置边缘手势代码
        self.interactivePopGestureRecognizer?.delegate = self
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        // 如果个数大于0，表示不是根视图控制器
        if viewControllers.count > 0 {
            // ==1 表示当前是第二个视图控制器
            if viewControllers.count == 1 {
                // 获取上一级控制器的title
                let title = viewControllers.first!.title!
                
                viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(title: title, imageName:"navigationbar_back_withtext", target: self, action: #selector(backAction))
            }
            else{
                viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "返回", imageName:"navigationbar_back_withtext", target: self, action: #selector(backAction))
            }
            
            viewController.title = "当前显示的是第\(viewControllers.count + 1)级控制器"
        }
        
        super.pushViewController(viewController, animated: animated)
    }
    
    func backAction() -> Void {
        popViewController(animated: true)
    }
    
    // 是否处理这次开始点击的手势
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        // 根视图控制器不处理边缘手势，其他控制器处理
        return viewControllers.count > 1
    }
    
}
