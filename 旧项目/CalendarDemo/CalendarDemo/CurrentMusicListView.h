//
//  CurrentMusicListView.h
//  CalendarDemo
//
//  Created by monkey2016 on 17/1/22.
//  Copyright © 2017年 monkey2016. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MusicPlayerHelper.h"
@class MusicModel;

@protocol CurrentMusicListViewDelegate <NSObject>

@optional

-(void)changePlayModeWithCurrentPlayMode:(MusicMode)currentPlayMode;
-(void)changeCurrentPlayListArr:(NSMutableArray *)currentPlayListArr;
-(void)clickDeleteBtnToChangeCurrentPlayListArr:(NSMutableArray *)currentPlayListArr andCurrentModel:(MusicModel *)currentModel andChangeCurrentPlayIndex:(NSInteger)currentPlayIndex;
-(void)playMusicWithCurrentPlayListArr:(NSMutableArray *)currentPlayListArr andClickedIndex:(NSInteger)clickedIndex;

@end

@interface CurrentMusicListView : UIView<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIView *listBgView;
@property (weak, nonatomic) IBOutlet UIButton *maskBtn;
@property (weak, nonatomic) IBOutlet UIImageView *noDataImgView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *currentPlayListArr;
@property (nonatomic,assign) NSInteger currentPlayIndex;
@property (nonatomic,assign) MusicMode currentPlayMode;
@property (weak, nonatomic) IBOutlet UIButton *clearBtn;//清空按钮
@property (weak, nonatomic) IBOutlet UIButton *currentPlayModeBtn;
@property (weak, nonatomic) IBOutlet UILabel *title;

@property (nonatomic,assign) id<CurrentMusicListViewDelegate> delegate;


//show
-(void)show;
//dismiss
-(void)dismiss;


@end
