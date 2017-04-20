//
//  QuestionCardVC.h
//  友照
//
//  Created by monkey2016 on 16/12/8.
//  Copyright © 2016年 ZX_XPH. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol QuestionCardVCDelegate <NSObject>

@optional
-(void)offsetCollectionViewWith:(NSIndexPath *)indexPath;
-(void)resetQuestion;
@end

@interface QuestionCardVC : UIViewController
@property (nonatomic,strong) NSMutableArray *source;//数据源
@property (nonatomic,assign) NSInteger currentIndex;//当前下标
@property (nonatomic,assign) id<QuestionCardVCDelegate> agency;

@property (nonatomic,assign) BOOL isMock;//是否是在模拟考试
@property (nonatomic,strong) NSString *wrongNum;
@property (nonatomic,strong) NSString *rightNum;


@end
