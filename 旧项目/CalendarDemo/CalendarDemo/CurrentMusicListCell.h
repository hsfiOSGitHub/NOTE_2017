//
//  CurrentMusicListCell.h
//  CalendarDemo
//
//  Created by monkey2016 on 17/1/22.
//  Copyright © 2017年 monkey2016. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CurrentMusicListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *numBgView;
@property (weak, nonatomic) IBOutlet UIImageView *singerPic;
@property (weak, nonatomic) IBOutlet UIImageView *readyPlay;
@property (weak, nonatomic) IBOutlet UILabel *num;
@property (weak, nonatomic) IBOutlet UILabel *musicName;
@property (weak, nonatomic) IBOutlet UILabel *singerName;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;

@end
