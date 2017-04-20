//
//  NetErrorView.h
//  SZB_doctor
//
//  Created by monkey2016 on 16/10/13.
//  Copyright © 2016年 monkey2016. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface NetErrorView : UIView
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;
@property (weak, nonatomic) IBOutlet UIImageView *picView;
@property (weak, nonatomic) IBOutlet UILabel *message;
@property (weak, nonatomic) IBOutlet UIButton *loadAgainBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgViewLeftConstraints;
@property (weak, nonatomic) IBOutlet UIView *bgView;

@end
