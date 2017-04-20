//
//  QuestionCell_question.h
//  友照
//
//  Created by monkey2016 on 16/12/7.
//  Copyright © 2016年 ZX_XPH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QuestionCell_question : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *questionStr;
@property (weak, nonatomic) IBOutlet UIImageView *sinaimgView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sinaimgViewHeightCons;
@property (weak, nonatomic) IBOutlet UIView *movieView;


@end
