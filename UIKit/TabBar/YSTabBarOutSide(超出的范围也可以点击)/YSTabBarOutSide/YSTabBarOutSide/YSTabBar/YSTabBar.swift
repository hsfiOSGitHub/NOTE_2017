//
//  YSTabBar.swift
//  YSTabBarOutSide
//
//  Created by yaoshuai on 2017/1/12.
//  Copyright © 2017年 ys. All rights reserved.
//

import UIKit

/// tabBar中item的个数
private var itemCount:CGFloat = 5

// 协议地继承NSObjectProtocol，否则无法使用弱引用
protocol YSTabBarDelegate:NSObjectProtocol {
    
    func centerButtonClick()
    
}

class YSTabBar: UITabBar {
    
    // MARK: - 代理属性
    weak var ysTabBarDelegate:YSTabBarDelegate?
    
    // MARK: - 中心大加号按钮
    private lazy var centerPlusBtn:UIButton = {
        let button = UIButton()
        
        button.addTarget(self, action: #selector(centerPlusBtnClick), for: .touchUpInside)
        
        button.setImage(UIImage(named : "tb_compose_add"), for: .normal)
        button.setImage(UIImage(named : "tb_compose_add_highlighted"), for: .highlighted)
        button.backgroundColor = UIColor.red
        
        button.bounds.size.width = 80
        button.bounds.size.height = 80
        button.layer.cornerRadius = 40
        button.layer.masksToBounds = true
        
        button.addTarget(self, action: #selector(btnACTION), for: .touchUpInside)
        
        return button
    }()
    
    func btnACTION(){
        
    }
    
    @objc private func centerPlusBtnClick(){
        ysTabBarDelegate?.centerButtonClick()
    }
    
    // MARK: - 创建控件
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    // MARK: - 布局界面
    private func setupUI(){
        // 设置背景图片，防止push时右边出现黑边
        backgroundImage = UIImage(named: "tb_background")
        
        // 添加中心大加号按钮
        addSubview(centerPlusBtn)
    }
    
    // MARK: - 布局子控件
    override func layoutSubviews() {
        super.layoutSubviews()
        
        centerPlusBtn.center.x = bounds.size.width * 0.5
        centerPlusBtn.center.y = bounds.size.height * 0.5 - 15
        
        let itemWidth = bounds.size.width / itemCount
        
        var index = 0
        
        for item in subviews{
            // 找到我们关心的按钮，UITabBarButton系统的私有类，不能直接使用
            // if item.isKind(of: UITabBarButton.self){
            if item.isKind(of: NSClassFromString("UITabBarButton")!){
                item.frame.size.width = itemWidth
                item.frame.origin.x = CGFloat(index) * itemWidth
                index += 1
                
                if index == Int(itemCount) / 2 {
                    index += 1
                }
            }
        }
    }
    
    // MARK: - 关键方法，超出范围仍能点击
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        for item in subviews{
            if item.frame.contains(point){
                return true
            }
        }
        return false
    }
}
