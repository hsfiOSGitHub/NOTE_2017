//
//  NearbySchoolCell.h
//  友照
//
//  Created by monkey2016 on 16/11/22.
//  Copyright © 2016年 ZX_XPH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NearbySchoolCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *picView;
@property (weak, nonatomic) IBOutlet UILabel *name;

@property (weak, nonatomic) IBOutlet UILabel *avgRate;
@property (weak, nonatomic) IBOutlet UILabel *distance;
@property (weak, nonatomic) IBOutlet UIView *starView;
@property (weak, nonatomic) IBOutlet UILabel *money;


@property (nonatomic,strong) SchoolListModel *schoolListModel;

@end
