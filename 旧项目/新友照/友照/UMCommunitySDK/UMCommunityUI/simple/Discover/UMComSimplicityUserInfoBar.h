//
//  UMComUserInfoBar.h
//  UMCommunity
//
//  Created by umeng on 1/21/16.
//  Copyright © 2016 Umeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UMComImageView.h"

@interface UMComSimplicityUserInfoBar : UIView

@property (weak, nonatomic) IBOutlet UMComImageView *avatar;
@property (weak, nonatomic) IBOutlet UIView *userInfoBar;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UMComImageView *medalView;
@property (weak, nonatomic) IBOutlet UILabel *loginTip;
@property (weak, nonatomic) IBOutlet UIImageView *genderIcon;

- (void)refresh;

@end
