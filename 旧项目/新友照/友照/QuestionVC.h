//
//  QuestionVC.h
//  友照
//
//  Created by monkey2016 on 16/12/7.
//  Copyright © 2016年 ZX_XPH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QuestionVC : UIViewController
@property (nonatomic,strong) NSMutableArray *source;
@property (nonatomic,strong) NSString *classType;//科一还是科四
@property (nonatomic,strong) NSString *subject;//科一还是科四

//以下都要ZXUD纪录状态
@property (nonatomic,strong) NSMutableArray *seleteBtnArr_big; //选中图标
@property (nonatomic,strong) NSMutableArray *seleteCellArr_big;//选中的cell
@property (nonatomic,strong) NSMutableArray *showExplainArr;//是否显示详解
@property (nonatomic,strong) NSMutableArray *currentAnswerArr_big;//当前选中的答案
@property (nonatomic,strong) NSMutableArray *finishStatus_big;//完成状态
//保存文件名
@property (nonatomic,strong) NSString *plistName_seleteBtnArr_big1Path;
@property (nonatomic,strong) NSString *plistName_seleteCellArr_big1Path;
@property (nonatomic,strong) NSString *plistName_showExplainArr1Path;
@property (nonatomic,strong) NSString *plistName_currentAnswerArr_big1Path;
@property (nonatomic,strong) NSString *plistName_finishStatus_big1Path;
@property (nonatomic,strong) NSString *plistName_seleteBtnArr_big4Path;
@property (nonatomic,strong) NSString *plistName_seleteCellArr_big4Path;
@property (nonatomic,strong) NSString *plistName_showExplainArr4Path;
@property (nonatomic,strong) NSString *plistName_currentAnswerArr_big4Path;
@property (nonatomic,strong) NSString *plistName_finishStatus_big4Path;

@property (nonatomic,strong) NSString *class1Q_index;
@property (nonatomic,strong) NSString *class4Q_index;

@property (nonatomic,strong) NSString *selectedSegmentIndex1;
@property (nonatomic,strong) NSString *selectedSegmentIndex4;

@property (nonatomic,assign) BOOL isMock;//是否是在模拟考试

@property (nonatomic,strong) NSString *wrongOrCollect;

@property (nonatomic,strong) NSString *random;

@property (nonatomic,strong) NSString *unfinish_Q;

@end
