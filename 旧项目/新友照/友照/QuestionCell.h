//
//  QuestionCell.h
//  友照
//
//  Created by monkey2016 on 16/12/7.
//  Copyright © 2016年 ZX_XPH. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol QuestionCellDelegate <NSObject>

@optional
//用于答错时显示详解
-(void)changeShowExplainArrWith:(NSInteger)index;
//用于答对时跳转到下一题
-(void)jumpToNextQuestionWith:(NSInteger)index;
//用于播放视频
-(void)playVideoWith:(CGRect)FRAME andSuperLayer:(CALayer *)superLayer;

@end

@interface QuestionCell : UICollectionViewCell<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,assign) BOOL isShowExplain;
@property (nonatomic,assign) BOOL isShowExplain_2;

@property (nonatomic,strong) ZXBaseTopicModel *Q_Model;
@property (nonatomic,strong) NSMutableArray *seleteStateArr;//选中icon的图标
@property (nonatomic,strong) NSMutableArray *seleteCellArr;//cell的选中状态
@property (nonatomic,strong) NSArray *seleteStateArr_copy;

@property (nonatomic,assign) id<QuestionCellDelegate> agency;//代理
@property (nonatomic,assign) NSInteger currentIndex;//当前题 下标

@property (nonatomic,strong) NSMutableArray *currentAnswer;

@property (nonatomic,strong) AVPlayer *avPlayer;//播放器对象
@property (nonatomic,strong) AVPlayerLayer *avPlayerLayer;

@property (nonatomic,strong) NSMutableArray *playerArr;//数组：播放器对象
@property (nonatomic,strong) NSMutableArray *lastPlayer;

@property (nonatomic,assign) BOOL isPracticeMode;

@end
