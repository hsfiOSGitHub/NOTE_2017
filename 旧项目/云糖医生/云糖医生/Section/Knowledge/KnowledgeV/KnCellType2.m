//
//  KnCellType2.m
//  yuntangyi
//
//  Created by yuntangyi on 16/9/12.
//  Copyright © 2016年 yuntangyi. All rights reserved.
//

#import "KnCellType2.h"

#import "KnNewsListModel.h"
#import "UIImageView+WebCache.h"
#import "NSString+TimeString.h"

@implementation KnCellType2

#pragma mark -配置数据
-(void)setListModel:(KnNewsListModel *)listModel{
    _listModel = listModel;
    
    //标题
    self.title.text = listModel.title;
    //图片
    [self.picView sd_setImageWithURL:[NSURL URLWithString:listModel.pic] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    //人数
    self.numLabel.text = listModel.click;
    [self.numIcon setImage:[UIImage imageNamed:@"kn_news2_scan"]];
    //收藏
    self.collectLabel.text = listModel.collect;
    if ([listModel.iscollect integerValue]) {//已收藏
        [self.collectIcon setImage:[UIImage imageNamed:@"kn_news2_collection"]];
    }else{//没有收藏
        [self.collectIcon setImage:[UIImage imageNamed:@"kn_news_noCollection"]];
    }
    //时间
    self.timeLabel.text = [NSString returnUploadTime:listModel.addtime];
    [self.timeIcon setImage:[UIImage imageNamed:@"kn_news2_time"]];
    
}



#pragma mark -awakeFromNib
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
