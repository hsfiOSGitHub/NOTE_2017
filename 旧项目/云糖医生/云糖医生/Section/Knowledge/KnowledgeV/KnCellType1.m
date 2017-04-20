//
//  KnCellType2.m
//  yuntangyi
//
//  Created by yuntangyi on 16/8/29.
//  Copyright © 2016年 yuntangyi. All rights reserved.
//

#import "KnCellType1.h"

#import "KnMeetingListModel.h"
#import "MiMyMeetingListModel.h"
#import "UIImageView+WebCache.h"
#import "NSString+TimeString.h"

@interface KnCellType1 ()
@property (weak, nonatomic) IBOutlet UILabel *markLabel1;//标签1
@property (weak, nonatomic) IBOutlet UILabel *markLabel2;//标签2
@property (weak, nonatomic) IBOutlet UILabel *markLabel3;//标签3
@property (weak, nonatomic) IBOutlet UIImageView *picImgView;//图片
@property (weak, nonatomic) IBOutlet UILabel *signUp;//报名人数
@property (weak, nonatomic) IBOutlet UILabel *time;//时间
@property (weak, nonatomic) IBOutlet UILabel *title;//标题
@property (weak, nonatomic) IBOutlet UILabel *firstContent;//第一句内容
@property (weak, nonatomic) IBOutlet UIView *markView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *markViewHeightConstraint;

@end

@implementation KnCellType1
#pragma mark -配置数据
-(void)setListModel:(KnMeetingListModel *)listModel{
    _listModel = listModel;
    //配置数据
    [_picImgView sd_setImageWithURL:[NSURL URLWithString:listModel.pic] placeholderImage:[UIImage imageNamed:@"图片图标"] completed:nil];//图片
    _title.text = listModel.meeting_name;
    _firstContent.text = listModel.content;
    _time.text = listModel.start_time;
    //"dotype": 1,//报名方式 空为未报名，0是主动报名，1是后台邀请
    if (listModel.dotype == NULL || [listModel.dotype isEqualToString:@""]) {//未报名
        _signUp.text = @" 未报名该会议 ";
        _signUp.textColor = [UIColor whiteColor];
    }else if ([listModel.dotype isEqualToString:@"0"]) {//主动报名
        _signUp.text = @" 已报名该会议 ";
        _signUp.textColor = KRGB(0, 172, 204, 1);
    }else if ([listModel.dotype isEqualToString:@"1"]) {//后台邀请
        _signUp.text = @" 已报名该会议 ";
        _signUp.textColor = KRGB(0, 172, 204, 1);
    }
    //标签
    NSArray *markArr = (NSArray *)listModel.tags_list;
    if (markArr == nil || markArr.count == 0 || [markArr[0] isEqualToString:@""]) {
        self.markViewHeightConstraint.constant = 0;
        [self.markView setNeedsLayout];
        _markLabel1.hidden = YES;
        _markLabel2.hidden = YES;
        _markLabel3.hidden = YES;
        return;
    }else{
        self.markViewHeightConstraint.constant = 60;
        [self.markView setNeedsLayout];
        _markLabel1.hidden = NO;
        _markLabel2.hidden = NO;
        _markLabel3.hidden = NO;
        if (markArr.count >= 3) {
            _markLabel1.text = [NSString stringWithFormat:@"  %@  ",listModel.tags_list[0]];
            _markLabel2.text = [NSString stringWithFormat:@"  %@  ",listModel.tags_list[1]];
            _markLabel3.text = [NSString stringWithFormat:@"  %@  ",listModel.tags_list[2]];
        }else if (markArr.count == 2) {
            _markLabel1.text = [NSString stringWithFormat:@"  %@  ",listModel.tags_list[0]];
            _markLabel2.text = [NSString stringWithFormat:@"  %@  ",listModel.tags_list[1]];
            _markLabel3.hidden = YES;
        }else if (markArr.count == 1) {
            _markLabel1.text = [NSString stringWithFormat:@"  %@  ",listModel.tags_list[0]];
            _markLabel2.hidden = YES;
            _markLabel3.hidden = YES;
        }
        
        
//        for (id obj in self.maskView.subviews) {
//            [obj removeFromSuperview];
//        }
//        for (int i = 0; i < markArr.count; i++) {
//            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(100, 100, 100, 20)];
//            label.textColor = [UIColor darkTextColor];
//            label.font = [UIFont systemFontOfSize:13];
//            label.numberOfLines = 0; //这个属性 一定要设置为0   0表示自动换行   默认是1 不换行
//            label.backgroundColor = [UIColor whiteColor];
//            label.textAlignment = NSTextAlignmentCenter;
//            NSString *str = markArr[i];
//            label.text = str;
//            label.layer.masksToBounds = YES;
//            label.layer.cornerRadius = 5;
//            label.layer.borderColor = [UIColor lightGrayColor].CGColor;
//            label.layer.borderWidth = 1;
//            //第一种方式
////            CGSize size = [str sizeWithFont:label.font constrainedToSize: CGSizeMake(MAXFLOAT,markLabel.frame.size.height) lineBreakMode:NSLineBreakByWordWrapping];
//            //第二种方式
//            NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
//            attrs[NSFontAttributeName] = [UIFont systemFontOfSize:10];
//            CGSize size =  [str boundingRectWithSize:CGSizeMake( MAXFLOAT,label.frame.size.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
//            
//            CGFloat markLabelW = size.width + 30;
//            label.frame = CGRectMake((markLabelW + 15) * i + 20, 20, markLabelW, 20);
//            [self.markView addSubview:label];
//        }
    }
}
//我收藏的会议 数据
-(void)setMyMeetingListModel:(MiMyMeetingListModel *)myMeetingListModel{
    _myMeetingListModel = myMeetingListModel;
    //配置数据
    [_picImgView sd_setImageWithURL:[NSURL URLWithString:myMeetingListModel.pic] placeholderImage:[UIImage imageNamed:@"图片图标"] completed:nil];//图片
    _title.text = myMeetingListModel.meeting_name;
    _firstContent.text = myMeetingListModel.content;
    _time.text = [NSString returnUploadTime:myMeetingListModel.start_time];
    //"dotype": 1,//报名方式 空为未报名，0是主动报名，1是后台邀请
    if (myMeetingListModel.dotype == NULL || [myMeetingListModel.dotype isEqualToString:@""]) {//未报名
        _signUp.text = @" 未报名该会议 ";
        _signUp.textColor = [UIColor whiteColor];
    }else if ([myMeetingListModel.dotype isEqualToString:@"0"]) {//主动报名
        _signUp.text = @" 已报名该会议 ";
        _signUp.textColor = KRGB(0, 172, 204, 1);
    }else if ([myMeetingListModel.dotype isEqualToString:@"1"]) {//后台邀请
        _signUp.text = @" 已报名该会议 ";
        _signUp.textColor = KRGB(0, 172, 204, 1);
    }
    //标签
    NSArray *markArr = (NSArray *)myMeetingListModel.tags_list;
    if (markArr == nil || markArr.count == 0 || [markArr[0] isEqualToString:@""]) {
        self.markViewHeightConstraint.constant = 0;
        [self.markView setNeedsLayout];
        _markLabel1.hidden = YES;
        _markLabel2.hidden = YES;
        _markLabel3.hidden = YES;
        return;
    }else{
        self.markViewHeightConstraint.constant = 60;
        [self.markView setNeedsLayout];
        _markLabel1.hidden = NO;
        _markLabel2.hidden = NO;
        _markLabel3.hidden = NO;
        if (markArr.count >= 3) {
            _markLabel1.text = [NSString stringWithFormat:@"  %@  ",myMeetingListModel.tags_list[0]];
            _markLabel2.text = [NSString stringWithFormat:@"  %@  ",myMeetingListModel.tags_list[1]];
            _markLabel3.text = [NSString stringWithFormat:@"  %@  ",myMeetingListModel.tags_list[2]];
        }else if (markArr.count == 2) {
            _markLabel1.text = [NSString stringWithFormat:@"  %@  ",myMeetingListModel.tags_list[0]];
            _markLabel2.text = [NSString stringWithFormat:@"  %@  ",myMeetingListModel.tags_list[1]];
            _markLabel3.hidden = YES;
        }else if (markArr.count == 1) {
            _markLabel1.text = [NSString stringWithFormat:@"  %@  ",myMeetingListModel.tags_list[0]];
            _markLabel2.hidden = YES;
            _markLabel3.hidden = YES;
        }
        
//        for (int i = 0; i < markArr.count; i++) {
//            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(100, 100, 100, 20)];
//            label.textColor = [UIColor darkTextColor];
//            label.font = [UIFont systemFontOfSize:13];
//            label.numberOfLines = 0; //这个属性 一定要设置为0   0表示自动换行   默认是1 不换行
//            label.backgroundColor = [UIColor whiteColor];
//            label.textAlignment = NSTextAlignmentCenter;
//            NSString *str = markArr[i];
//            label.text = str;
//            label.layer.masksToBounds = YES;
//            label.layer.cornerRadius = 5;
//            label.layer.borderColor = [UIColor lightGrayColor].CGColor;
//            label.layer.borderWidth = 1;
//            //第一种方式
//            //            CGSize size = [str sizeWithFont:label.font constrainedToSize: CGSizeMake(MAXFLOAT,markLabel.frame.size.height) lineBreakMode:NSLineBreakByWordWrapping];
//            //第二种方式
//            NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
//            attrs[NSFontAttributeName] = [UIFont systemFontOfSize:10];
//            CGSize size =  [str boundingRectWithSize:CGSizeMake( MAXFLOAT,label.frame.size.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
//            
//            CGFloat markLabelW = size.width + 30;
//            label.frame = CGRectMake((markLabelW + 15) * i + 20, 20, markLabelW, 20);
//            [self.markView addSubview:label];
//        }
    }
}
#pragma mark -awakeFromNib
- (void)awakeFromNib {
    [super awakeFromNib];
    //配置会议标签
    [self setUpMarkLabel];
}
-(void)setUpMarkLabel{
    _markLabel1.layer.masksToBounds = YES;
    _markLabel2.layer.masksToBounds = YES;
    _markLabel3.layer.masksToBounds = YES;
    
    _markLabel1.layer.cornerRadius = 5;
    _markLabel2.layer.cornerRadius = 5;
    _markLabel3.layer.cornerRadius = 5;
    
    _markLabel1.layer.borderWidth = 1;
    _markLabel2.layer.borderWidth = 1;
    _markLabel3.layer.borderWidth = 1;
    
    _markLabel1.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _markLabel2.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _markLabel3.layer.borderColor = [UIColor lightGrayColor].CGColor;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
