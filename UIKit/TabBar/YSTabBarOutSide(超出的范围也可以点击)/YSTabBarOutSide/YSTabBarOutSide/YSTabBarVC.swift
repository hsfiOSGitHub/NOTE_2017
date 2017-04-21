//
//  YSTabBarVC.swift
//  YSTabBarOutSide
//
//  Created by yaoshuai on 2017/1/12.
//  Copyright © 2017年 ys. All rights reserved.
//

import UIKit

class YSTabBarVC: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 设置tintColor -> 统一设置tabBar的选中颜色
        // 越早设置越好，一般放到AppDelegate中
        // 或者：设置图片渲染模式、设置tabBar文字
        UITabBar.appearance().tintColor = UIColor.orange
        
        let ysTabBar = YSTabBar()
        ysTabBar.ysTabBarDelegate = self
        // self.tabBar只读，使用kvc给只读属性赋值
        setValue(ysTabBar, forKey: "tabBar")
        
        addChildViewController(childController: YSHomeVC(), title: "首页", imageName: "tb_home")
        addChildViewController(childController: YSMessageVC(), title: "消息", imageName: "tb_message")
        addChildViewController(childController: YSDiscoverVC(), title: "发现", imageName: "tb_discover")
        addChildViewController(childController: YSProfileVC(), title: "我的", imageName: "tb_profile")
    }
    
    private func addChildViewController(childController: UIViewController, title:String, imageName:String){
        // 设置image的位置(如果图片带有文字，会偏上，设置此属性，使图片向下偏移)
        // childController.tabBarItem.imageInsets = UIEdgeInsetsMake(5, 0, -5, 0)
        
        childController.tabBarItem.image = UIImage(named: imageName)?.withRenderingMode(.alwaysOriginal)
        childController.tabBarItem.selectedImage = UIImage(named: "\(imageName)_selected")?.withRenderingMode(.alwaysOriginal)
        
        childController.tabBarItem.setTitleTextAttributes([NSFontAttributeName : UIFont.systemFont(ofSize: 14)], for: .normal)
        childController.tabBarItem.setTitleTextAttributes([NSForegroundColorAttributeName : UIColor.orange], for: .selected)
        
        childController.tabBarItem.title = title
        childController.navigationItem.title = title
        
        let nav = YSNavigationVC(rootViewController: childController)
        
        addChildViewController(nav)
    }
    
}

// MARK: - YSTabBarDelegate
extension YSTabBarVC:YSTabBarDelegate{
    func centerButtonClick() {
        print("点击了TabBar中心的大加号按钮")
    }
}
