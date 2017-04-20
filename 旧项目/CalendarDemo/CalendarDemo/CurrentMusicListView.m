//
//  CurrentMusicListView.m
//  CalendarDemo
//
//  Created by monkey2016 on 17/1/22.
//  Copyright © 2017年 monkey2016. All rights reserved.
//

#import "CurrentMusicListView.h"

#import "CurrentMusicListCell.h"
#import "MusicModel.h"

static NSString *identifierCell = @"identifierCell";
@implementation CurrentMusicListView
//初始化方法
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self = (CurrentMusicListView *)[self loadNibView];
        self.frame = frame;
    }
    return self;
}
//获取到xib中的View
-(UIView *)loadNibView{
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    return views.firstObject;
}

#pragma mark -awakeFromNib
-(void)awakeFromNib{
    [super awakeFromNib];
    //配置subViews
    [self setUpSubViews];
    self.maskBtn.alpha = 0.1;
}
//配置subViews
-(void)setUpSubViews{
    //标题
    self.clearBtn.layer.masksToBounds = YES;
    self.clearBtn.layer.cornerRadius = 8;
    self.clearBtn.layer.borderWidth = 1;
    self.clearBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    //数据源代理
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    //高度
    self.tableView.estimatedRowHeight = 44;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    //注册cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([CurrentMusicListCell class]) bundle:nil] forCellReuseIdentifier:identifierCell];
}
//点击maskBtn
- (IBAction)maskBtnACTION:(UIButton *)sender {
    [self removeFromSuperview];
}
//show
-(void)show{
    [UIView animateWithDuration:0.3 animations:^{
        self.maskBtn.alpha = 0.4;
        self.listBgView.frame = CGRectMake(0, KScreenHeight - self.listBgView.height, self.listBgView.width, self.listBgView.height);
    }];
    [self.tableView reloadData];
    if (self.currentPlayListArr.count > 0) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.currentPlayIndex inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
        });
    }
}
//dismiss
-(void)dismiss{
    [self removeFromSuperview];
}

//添加数据／刷表
-(void)setCurrentPlayListArr:(NSMutableArray *)currentPlayListArr{
    _currentPlayListArr = currentPlayListArr;
    if (currentPlayListArr.count == 0) {
        [self.listBgView bringSubviewToFront:self.noDataImgView];
    }else{
        [self.listBgView sendSubviewToBack:self.noDataImgView];
    }
    [self.tableView reloadData];
}
-(void)setCurrentPlayMode:(MusicMode)currentPlayMode{
    _currentPlayMode = currentPlayMode;
    [self getModeBtnImage];
}
//当前播放模式
-(void)getModeBtnImage{
    switch (self.currentPlayMode) {
        case MusicModeOrder:{//顺序播放
            [self.currentPlayModeBtn setImage:[UIImage imageNamed:@"order_music"] forState:UIControlStateNormal];
        }
            break;
        case MusicModeSingle:{//单曲循环
            [self.currentPlayModeBtn setImage:[UIImage imageNamed:@"single_music"] forState:UIControlStateNormal];
        }
            break;
        case MusicModeLoop:{//循环列表
            [self.currentPlayModeBtn setImage:[UIImage imageNamed:@"loop_music"] forState:UIControlStateNormal];
        }
            break;
        case MusicModeRandom:{//随机播放
            [self.currentPlayModeBtn setImage:[UIImage imageNamed:@"random_music"] forState:UIControlStateNormal];
        }
            break;
            
        default:
            break;
    }
}
//点击切换播放模式
- (IBAction)currentPlayModeBtnACTION:(UIButton *)sender {
    switch (self.currentPlayMode) {
        case MusicModeOrder:{//顺序播放
            self.currentPlayMode = MusicModeSingle;
        }
            break;
        case MusicModeSingle:{//单曲循环
            self.currentPlayMode = MusicModeLoop;
        }
            break;
        case MusicModeLoop:{//循环列表
            self.currentPlayMode = MusicModeRandom;
        }
            break;
        case MusicModeRandom:{//随机播放
            self.currentPlayMode = MusicModeOrder;
        }
            break;
            
        default:
            break;
    } 
    [self getModeBtnImage];
    //更改本地歌曲页面的播放模式
    if ([self.delegate respondsToSelector:@selector(changePlayModeWithCurrentPlayMode:)]) {
        [self.delegate changePlayModeWithCurrentPlayMode:self.currentPlayMode];
    }
}
//点击清空按钮
- (IBAction)clearBtnACTION:(UIButton *)sender {
    [self.currentPlayListArr removeAllObjects];
    [self.tableView reloadData];
    if ([self.delegate respondsToSelector:@selector(changeCurrentPlayListArr:)]) {
        [self.delegate changeCurrentPlayListArr:self.currentPlayListArr];
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.3 animations:^{
            self.maskBtn.alpha = 0;
            self.listBgView.frame = CGRectMake(0, KScreenHeight, self.listBgView.width, self.listBgView.height);
        }completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    });
}



#pragma mark -UITableViewDelegate,UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.currentPlayListArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CurrentMusicListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierCell forIndexPath:indexPath];
    MusicModel *model = self.currentPlayListArr[indexPath.row];
    cell.musicName.text = model.musicName;
    cell.singerName.text = model.singerName;
    cell.singerPic.image = [UIImage imageNamed:model.singerPic];
    cell.num.text = [NSString stringWithFormat:@"%ld",indexPath.row + 1];
    if ([model.is_playing isEqualToString:@"0"]) {
        [cell.numBgView bringSubviewToFront:cell.num];
        cell.musicName.textColor = KRGB(21, 21, 21, 1);
        cell.singerName.textColor = [UIColor lightGrayColor];
    }else if ([model.is_playing isEqualToString:@"1"]) {
        [cell.numBgView bringSubviewToFront:cell.singerPic];
        cell.musicName.textColor = KRGB(23, 159, 155, 1.0);
        cell.singerName.textColor = KRGB(23, 159, 155, 1.0);
    }else if ([model.is_playing isEqualToString:@"2"]) {//即将要播放的歌曲
        cell.readyPlay.image = [[UIImage imageNamed:@"addMusic_music"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [cell.numBgView bringSubviewToFront:cell.readyPlay];
        cell.musicName.textColor = KRGB(21, 21, 21, 1);
        cell.singerName.textColor = [UIColor lightGrayColor];
    }
    //点击单个删除按钮
    [cell.deleteBtn setTag:(indexPath.row + 100)];
    [cell.deleteBtn addTarget:self action:@selector(deleteBtnACTION:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}
//点击播放歌曲
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([self.delegate respondsToSelector:@selector(playMusicWithCurrentPlayListArr:andClickedIndex:)]) {
        [self.delegate playMusicWithCurrentPlayListArr:self.currentPlayListArr andClickedIndex:indexPath.row];
    }

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.3 animations:^{
            self.maskBtn.alpha = 0;
            self.listBgView.frame = CGRectMake(0, KScreenHeight, self.listBgView.width, self.listBgView.height);
        }completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    });
    
}

//点击单个删除按钮
-(void)deleteBtnACTION:(UIButton *)sender{
    NSMutableArray *tmpArr = self.currentPlayListArr.mutableCopy;
    [tmpArr removeObjectAtIndex:(sender.tag - 100)];
    __block NSInteger newIndex = 0;
    [tmpArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        MusicModel *model = (MusicModel *)obj;
        if ([model.is_playing isEqualToString:@"1"]) {
            newIndex = idx;
        }
    }];
    if ([self.delegate respondsToSelector:@selector(clickDeleteBtnToChangeCurrentPlayListArr:andCurrentModel:andChangeCurrentPlayIndex:)]) {
        [self.delegate clickDeleteBtnToChangeCurrentPlayListArr:self.currentPlayListArr andCurrentModel:self.currentPlayListArr[sender.tag - 100] andChangeCurrentPlayIndex:newIndex];
    }
    [self.currentPlayListArr removeObjectAtIndex:(sender.tag - 100)];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:(sender.tag - 100) inSection:0];
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
        
        if (self.currentPlayListArr.count == 0) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [UIView animateWithDuration:0.3 animations:^{
                    self.maskBtn.alpha = 0;
                    self.listBgView.frame = CGRectMake(0, KScreenHeight, self.listBgView.width, self.listBgView.height);
                }completion:^(BOOL finished) {
                    [self removeFromSuperview];
                }];
            });
        }
    }); 
    
    
}




@end
