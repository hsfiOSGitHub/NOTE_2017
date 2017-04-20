//
//  ZXMessageTableViewCell.h
//  ZXJiaXiao
//
//  Created by Finsen on 16/6/23.
//  Copyright © 2016年 ZX. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface ZXMessageTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *date;
@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet UILabel *content1;
@property (weak, nonatomic) IBOutlet UIImageView *imgV;

-(void)setModel:(NSDictionary *)model;

@end
