//
//  AddCoin34VC.h
//  CalendarDemo
//
//  Created by monkey2016 on 17/1/13.
//  Copyright © 2017年 monkey2016. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AddCoin34VCDelegate <NSObject>

@optional

-(void)addSuccessWithTimeArr:(NSMutableArray *)timeArr andContentDic:(NSMutableDictionary *)contentDic andColorDic:(NSMutableDictionary *)colorDic;

@end

@interface AddCoin34VC : UIViewController

@property (nonatomic,assign) id<AddCoin34VCDelegate> delegate;

@property (nonatomic,strong) NSMutableDictionary *colorDic;
@property (nonatomic,strong) NSMutableDictionary *contentDic;
@property (nonatomic,strong) NSMutableArray *timeArr;
@property (nonatomic,strong) NSString *addOrModify;//添加还是修改

//点击cell进来的时候进行赋值
@property (nonatomic,assign) NSInteger clickIndex;


@end
