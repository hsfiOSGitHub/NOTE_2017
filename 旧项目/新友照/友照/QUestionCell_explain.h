//
//  QUestionCell_explain.h
//  友照
//
//  Created by monkey2016 on 16/12/7.
//  Copyright © 2016年 ZX_XPH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QUestionCell_explain : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *explainStr;

@property (weak, nonatomic) IBOutlet UILabel *yourAnswer;
@property (weak, nonatomic) IBOutlet UILabel *rightAnswer;
@property (weak, nonatomic) IBOutlet UILabel *yourAnswerTitle;

@property (weak, nonatomic) IBOutlet UIImageView *finishImgView;

@end
