//
//  AYMenuCell.h
//  AYMenuList
//
//  Created by Andy on 2017/4/26.
//  Copyright © 2017年 Andy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AYMenuItem;

@interface AYMenuCell : UITableViewCell

@property (nonatomic , strong)AYMenuItem *item;

@property (weak, nonatomic) IBOutlet UIImageView *menuImgView;


@end
