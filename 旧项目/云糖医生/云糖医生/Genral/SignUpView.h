//
//  SZBAlertView1.h
//  yuntangyi
//
//  Created by yuntangyi on 16/9/19.
//  Copyright © 2016年 yuntangyi. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol AlertBtnAction <NSObject>

-(void)cancelAction;
-(void)okAction;

@end

@interface SignUpView : UIView

@property (weak, nonatomic) IBOutlet UILabel *title;//标题
@property (weak, nonatomic) IBOutlet UILabel *message;//信息
@property (weak, nonatomic) IBOutlet UIButton *cancel;//取消按钮
@property (weak, nonatomic) IBOutlet UIButton *ok;//确认按钮
@property (nonatomic,strong) NSDictionary *contentDic;
@property (nonatomic,assign) id<AlertBtnAction> agency;//代理
@end
