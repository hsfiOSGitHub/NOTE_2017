//
//  ZXDateTableViewCell.h
//  ZXJiaXiao
//
//  Created by Finsen on 16/5/12.
//  Copyright © 2016年 ZX. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZXDateTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *keyuyeu;
@property (weak, nonatomic) IBOutlet UILabel *bukeyuyue;

- (void)setUpCellWith:(NSDictionary *)model;

@end
