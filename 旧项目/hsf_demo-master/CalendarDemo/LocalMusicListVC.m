//
//  LocalMusicListVC.m
//  CalendarDemo
//
//  Created by monkey2016 on 17/1/20.
//  Copyright © 2017年 monkey2016. All rights reserved.
//

#import "LocalMusicListVC.h"

#import "LocalMusicCell1.h"
#import "LocalMusicCell2.h"
#import "LocalMusicCell3.h"
#import "MusicVC.h"//播放界面
#import "CyclePicVC.h"//轮播图

@interface LocalMusicListVC ()<SDCycleScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,AVAudioPlayerDelegate,MusicVCDelegate,CurrentMusicListViewDelegate>
@property (nonatomic,strong) NSArray *scrollPicArr;//轮播图图片
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIImageView *singerPic;
@property (weak, nonatomic) IBOutlet UILabel *musicName;
@property (weak, nonatomic) IBOutlet UILabel *singerName;
@property (weak, nonatomic) IBOutlet UIButton *currentMusicListBtn;
@property (weak, nonatomic) IBOutlet UIButton *playBtn;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;

@property (nonatomic,strong) NSMutableArray *localMusicArr;//数据源
@property (nonatomic,strong) AVAudioPlayer *player;//音乐播放器
@property (nonatomic,strong) NSTimer *timer;//计时器
@property (nonatomic,strong) NSMutableArray *currentPlayListArr;//当前播放列表
@property (nonatomic,assign) NSInteger currentPlayIndex;//当前播放下标
@property (nonatomic,assign) MusicMode currentPlayMode;//当前播放模式
@property (nonatomic,strong) MusicModel *currentModel;//当前播放的歌曲
@property (nonatomic,strong) CurrentMusicListView *currentMusicList_View;
@property (nonatomic,strong) NSMutableArray *readyPlayMusicArr;

@end


static NSString *identifierCell1 = @"identifierCell1";
static NSString *identifierCell2 = @"identifierCell2";
static NSString *identifierCell3 = @"identifierCell3";
@implementation LocalMusicListVC
#pragma mark -懒加载
-(NSArray *)scrollPicArr{
    if (!_scrollPicArr) {
        _scrollPicArr = [NSArray array];
    }
    return _scrollPicArr;
}
-(NSMutableArray *)localMusicArr{
    if (!_localMusicArr) {
        NSArray *arr = [[HSFFmdbManager sharedManager] readAllLocalMusic];
        _localMusicArr = [NSMutableArray arrayWithArray:arr];
    }
    return _localMusicArr;
}
-(NSMutableArray *)currentPlayListArr{
    if (!_currentPlayListArr) {
        _currentPlayListArr = [NSMutableArray array];
    }
    return _currentPlayListArr;
}

-(AVAudioPlayer *)player{
    if (!_player) {
        NSString *fileName = [NSString stringWithFormat:@"%@.%@",self.currentModel.musicName,self.currentModel.type];
        _player = [MusicPlayerHelper playMusic:fileName];
        _player.delegate = self;//设置代理
        [_player pause];
    }
    return _player;
}
-(CurrentMusicListView *)currentMusicList_View{
    if (!_currentMusicList_View) {
        _currentMusicList_View = [[CurrentMusicListView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
        _currentMusicList_View.delegate = self;
    }
    return _currentMusicList_View;
}
-(NSMutableArray *)readyPlayMusicArr{
    if (!_readyPlayMusicArr) {
        _readyPlayMusicArr = [NSMutableArray array];
    }
    return _readyPlayMusicArr;
}

#pragma mark -配置导航栏
-(void)setUpNavi{
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    //退出
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"back_common"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    //搜索
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"search_common"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(searchAction)];
}
//退出
-(void)backAction{
    if (self.player.isPlaying) {
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"退出,音乐将会停止，是否退出?" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *back = [UIAlertAction actionWithTitle:@"退出" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [self.player pause];
            self.player = nil;
            [self.navigationController popViewControllerAnimated:YES];
        }];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [alertC addAction:back];
        [alertC addAction:cancel];
        [self presentViewController:alertC animated:YES completion:nil];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}
//搜索
-(void)searchAction{
    
}

#pragma mark -viewWillAppear
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barTintColor = KRGB(23, 159, 155, 1.0);
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:20],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.navigationItem.title = @"音乐";
}
#pragma mark -viewWillDisappear
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}
#pragma mark -viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    self.currentPlayMode = MusicModeLoop;//默认播放模式
    //配置导航栏
    [self setUpNavi];
    //轮播图图片数组
    self.scrollPicArr = @[@"xuezhiqian01",@"xuezhiqian02",@"xuezhiqian03",@"xuezhiqian04"];
    //配置tableView
    [self setUpTableView];
    //配置bottomView
    [self setUpBottomView];
    //配置计时器
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
    [self.timer setFireDate:[NSDate distantFuture]];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    //注册通知－－用于音乐播放小空间
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(littlePlayerNotify:) name:@"littlePlayer_local_notify" object:nil];
}
//计时器事件
-(void)timerAction{
    self.progressView.progress = self.player.currentTime/self.player.duration;
}
//配置tableView
-(void)setUpTableView{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    //高度
    self.tableView.estimatedRowHeight = 44;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    //注册cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([LocalMusicCell1 class]) bundle:nil] forCellReuseIdentifier:identifierCell1];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([LocalMusicCell2 class]) bundle:nil] forCellReuseIdentifier:identifierCell2];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([LocalMusicCell3 class]) bundle:nil] forCellReuseIdentifier:identifierCell3];
}
//配置bottomView
-(void)setUpBottomView{
    //设置音乐状态
    [self setUpMusicPlayIcons];
    //添加点击手势 进入播放界面
    self.bottomView.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(intoPlayer:)];
    [self.bottomView addGestureRecognizer:singleTap];
}
//点击手势 进入播放界面
-(void)intoPlayer:(UITapGestureRecognizer *)sender{
    if (self.currentPlayListArr.count <= 0) {
        [MBProgressHUD showError:@"队列中没有歌曲可以播放！"];
    }else{
        //先把计时器暂停
        [self.timer setFireDate:[NSDate distantFuture]];
        //再进入播放界面
        MusicVC *music_VC = [[MusicVC alloc]init];
        music_VC.delegate = self;
        music_VC.currentPlayListArr = self.currentPlayListArr;
        music_VC.currentPlayIndex = self.currentPlayIndex;
        music_VC.currentPlayMode = self.currentPlayMode;
        music_VC.player = self.player;
        [self.navigationController pushViewController:music_VC animated:YES];
    }
}

#pragma mark -UITableViewDelegate,UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 2;
    }else if (section == 1) {
        return self.localMusicArr.count;
    }
    return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row ==  0) {
            LocalMusicCell1 *cell_scroll = [tableView dequeueReusableCellWithIdentifier:identifierCell1 forIndexPath:indexPath];
            //创建轮播图
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                // 本地加载 --- 创建不带标题的图片轮播器
                SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:cell_scroll.scrollContentView.bounds shouldInfiniteLoop:YES imageNamesGroup:self.scrollPicArr];
                cycleScrollView.delegate = self;
                cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated;
                cycleScrollView.scrollDirection = UICollectionViewScrollDirectionHorizontal;
                [cell_scroll.scrollContentView addSubview:cycleScrollView];
                
                //         --- 轮播时间间隔，默认1.0秒，可自定义
                //cycleScrollView.autoScrollTimeInterval = 4.0;
            });
            
            return cell_scroll;
        }else if (indexPath.row ==  1) {
            LocalMusicCell2 *cell_option = [tableView dequeueReusableCellWithIdentifier:identifierCell2 forIndexPath:indexPath];
            //option 菜单
            [cell_option.myLikeBtn setTag:1000];
            [cell_option.myCollectionBtn setTag:2000];
            [cell_option.myMusicListBtn setTag:3000];
            [cell_option.downloadCenterBtn setTag:4000];
            [cell_option.recentBtn setTag:5000];
            [cell_option.musicLibBtn setTag:6000];
            [cell_option.redioBtn setTag:7000];
            [cell_option.mvBtn setTag:8000];
            
            [cell_option.myLikeBtn addTarget:self action:@selector(optionBtnACTION:) forControlEvents:UIControlEventTouchUpInside];
            [cell_option.myCollectionBtn addTarget:self action:@selector(optionBtnACTION:) forControlEvents:UIControlEventTouchUpInside];
            [cell_option.myMusicListBtn addTarget:self action:@selector(optionBtnACTION:) forControlEvents:UIControlEventTouchUpInside];
            [cell_option.downloadCenterBtn addTarget:self action:@selector(optionBtnACTION:) forControlEvents:UIControlEventTouchUpInside];
            [cell_option.recentBtn addTarget:self action:@selector(optionBtnACTION:) forControlEvents:UIControlEventTouchUpInside];
            [cell_option.musicLibBtn addTarget:self action:@selector(optionBtnACTION:) forControlEvents:UIControlEventTouchUpInside];
            [cell_option.redioBtn addTarget:self action:@selector(optionBtnACTION:) forControlEvents:UIControlEventTouchUpInside];
            [cell_option.mvBtn addTarget:self action:@selector(optionBtnACTION:) forControlEvents:UIControlEventTouchUpInside];
            return cell_option;
        }
    }else if (indexPath.section == 1) {
        LocalMusicCell3 *cell_music = [tableView dequeueReusableCellWithIdentifier:identifierCell3 forIndexPath:indexPath];
        MusicModel *model = self.localMusicArr[indexPath.row];
        cell_music.musicNsme.text = model.musicName;
        cell_music.singerName.text = model.singerName;
        //点击加号
        [cell_music.seleteBtn setTag:(indexPath.row + 100)];
        [cell_music.seleteBtn addTarget:self action:@selector(seleteBtnACTION:) forControlEvents:UIControlEventTouchUpInside];
        return cell_music;
    }
    return nil;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 1) {
        self.currentPlayListArr = self.localMusicArr.mutableCopy;//不管播放队列中有没有歌曲只要点击了本地歌曲列表中的歌曲，当前播放队列就是本地歌曲列表队列
        self.currentModel = self.localMusicArr[indexPath.row];
        self.currentPlayIndex = indexPath.row;
        //更换player
        [self.player pause];
        self.player = nil;
        self.player.delegate = self;
        NSString *fileName = [NSString stringWithFormat:@"%@.%@",self.currentModel.musicName,self.currentModel.type];
        self.player = [MusicPlayerHelper playMusic:fileName];
        [self.player play];
        //设置音乐状态
        [self setUpMusicPlayIcons];
        //是否正在播放
        [self makeSurePlaying];
    }
}
//是否正在播放
-(void)makeSurePlaying{
    NSMutableArray *newCurrentPlayListArr = [NSMutableArray array];
    [self.currentPlayListArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        MusicModel *model = (MusicModel *)obj;
        if (idx == self.currentPlayIndex) {
            model.is_playing = @"1";
        }else{
            if ([model.is_playing isEqualToString:@"1"]) {
                model.is_playing = @"0";
            }
        }
        [newCurrentPlayListArr addObject:model];
    }];
    [self.currentPlayListArr removeAllObjects];
    self.currentPlayListArr = newCurrentPlayListArr.mutableCopy;
}

#pragma mark -点击加号
-(void)seleteBtnACTION:(UIButton *)sender{
    LocalMusicCell3 *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:sender.tag - 100 inSection:1]];
    UIWindow* window = [UIApplication sharedApplication].keyWindow;
    CGRect rect1 = [sender convertRect:sender.frame fromView:cell.contentView];     //获取button在contentView的位置
    CGRect rect2 = [sender convertRect:rect1 toView:window];         //获取button在window的位置
//    CGRect rect3 = CGRectInset(rect2, -0.5 * 8, -0.5 * 8);          //扩大热区
    
    UIButton *animationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    animationBtn.frame = rect2;
    [animationBtn setImage:[UIImage imageNamed:@"add_music_list"] forState:UIControlStateNormal];
    [window addSubview:animationBtn];
    
    //位移动画
    CAKeyframeAnimation *anima1 = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(animationBtn.centerX, animationBtn.centerY)];
    CGPoint endPoint = CGPointMake(self.currentMusicListBtn.centerX, self.currentMusicListBtn.centerY + self.tableView.height + 64);
    [path addQuadCurveToPoint:endPoint controlPoint:CGPointMake(rect2.origin.x + rect2.size.width/2 + 150, rect2.origin.y + rect2.size.height/2 - 150)];
    anima1.path = path.CGPath;
    //缩放动画
    CABasicAnimation *anima2 = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    anima2.fromValue = [NSNumber numberWithFloat:0.8f];
    anima2.toValue = [NSNumber numberWithFloat:1.2f];
    //旋转动画
    CABasicAnimation *anima3 = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    anima3.toValue = [NSNumber numberWithFloat:M_PI*4];
    //组动画
    CAAnimationGroup *groupAnimation = [CAAnimationGroup animation];
    groupAnimation.animations = [NSArray arrayWithObjects:anima1,anima2,anima3, nil];
    groupAnimation.duration = 1.0f;
    //添加动画
    [animationBtn.layer addAnimation:groupAnimation forKey:@"groupAnimation"];
    //提示添加成功
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [MBProgressHUD showError:@"成功添加一首歌曲到播放队列"];
    });
    //移除
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [animationBtn removeFromSuperview];
    });
        
    //添加数据
    MusicModel *model = self.localMusicArr[sender.tag - 100];
    NSDictionary *dic = @{@"musicName":model.musicName,
                          @"singerName":model.singerName,
                          @"type":model.type,
                          @"singerPic":model.singerPic,
                          @"is_playing":@"2"};
    MusicModel *readyModel = [MusicModel modelWithDic:dic];
    if (self.currentPlayListArr.count < self.localMusicArr.count) {
        [self.currentPlayListArr addObject:readyModel];
    }else{
        if (self.currentPlayIndex == self.currentPlayListArr.count - 1) {
            [self.currentPlayListArr addObject:readyModel];
        }else{
            [self.currentPlayListArr insertObject:readyModel atIndex:self.currentPlayIndex + 1];
        }
    }
}



#pragma mark - SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    NSLog(@"---点击了第%ld张图片", (long)index);
    
    [self.navigationController pushViewController:[NSClassFromString(@"CyclePicVC") new] animated:YES];
}

#pragma mark -bottomView音乐播放器
//当前播放列表
- (IBAction)currentMusicListBtnACTION:(UIButton *)sender {
    [KMyWindow addSubview:self.currentMusicList_View];
    self.currentMusicList_View.title.text = [NSString stringWithFormat:@"当前播放列表（%ld）",self.currentPlayListArr.count];
    self.currentMusicList_View.currentPlayMode = self.currentPlayMode;
    self.currentMusicList_View.currentPlayListArr = self.currentPlayListArr;
    self.currentMusicList_View.currentPlayIndex = self.currentPlayIndex;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.currentMusicList_View show];
    });
}
//播放暂停
- (IBAction)playBtnACTION:(UIButton *)sender {
    if (self.currentPlayListArr.count <= 0) {
        [MBProgressHUD showError:@"播放错误!"];
    }else{
        if (self.player.isPlaying) {
            [self.player pause];
            [sender setImage:[UIImage imageNamed:@"play_music_local"] forState:UIControlStateNormal];
        }else{
            [self.player play];
            [sender setImage:[UIImage imageNamed:@"stop_music_local"] forState:UIControlStateNormal];
        }
    }
}
//下一曲
- (IBAction)nextBtnACTION:(UIButton *)sender {
    if (self.currentPlayListArr.count <= 0) {
        [MBProgressHUD showError:@"播放错误!"];
    }else{
        self.currentPlayIndex++;
        [self getUsableCurrentIndex:self.currentPlayIndex];//给index加保险
        self.currentModel = self.currentPlayListArr[self.currentPlayIndex];
        //更换player
        [self.player pause];
        self.player = nil;
        self.player.delegate = self;
        NSString *fileName = [NSString stringWithFormat:@"%@.%@",self.currentModel.musicName,self.currentModel.type];
        self.player = [MusicPlayerHelper playMusic:fileName];
        [self.player play];
        //更换歌曲信息
        [self setUpMusicPlayIcons];
        //是否正在播放
        [self makeSurePlaying];
    }
}

//配置音乐播放状态图标
-(void)setUpMusicPlayIcons{
    //歌曲信息
    if (!self.currentModel) {
        self.singerPic.image = [UIImage imageNamed:@"placeholder2_music_player"];
        self.musicName.text = @"爱音乐，爱生活";
        self.singerName.text = @"音乐也能改变世界";
    }else{
        self.singerPic.image = [UIImage imageNamed:self.currentModel.singerPic];
        self.musicName.text = self.currentModel.musicName;
        self.singerName.text = self.currentModel.singerName;
    }
    //播放状态
    if (self.player.isPlaying) {
        [self.playBtn setImage:[UIImage imageNamed:@"stop_music_local"] forState:UIControlStateNormal];
    }else{
        [self.playBtn setImage:[UIImage imageNamed:@"play_music_local"] forState:UIControlStateNormal];
    }
    //进度条
    self.progressView.progress = self.player.currentTime/self.player.duration;
    //是否开始计时器
    if (self.player.isPlaying) {
        [self.timer setFireDate:[NSDate distantPast]];
    }else{
        [self.timer setFireDate:[NSDate distantFuture]];
    }
}

//获取可用的播放下标
-(void)getUsableCurrentIndex:(NSInteger)index{
    switch (self.currentPlayMode) {
        case MusicModeOrder:{//顺序播放
            self.player.numberOfLoops = 0;
            if (index < 0) {
                self.currentPlayIndex = 0;
            }else if (index > self.currentPlayListArr.count - 1) {
                self.currentPlayIndex = self.currentPlayListArr.count - 1;
            }else{
                self.currentPlayIndex = index;
            }
        }
            break;
        case MusicModeLoop:{//循环播放
            self.player.numberOfLoops = 0;
            if (index < 0) {
                self.currentPlayIndex = self.currentPlayListArr.count - 1;
            }else if (index > self.currentPlayListArr.count - 1) {
                self.currentPlayIndex = 0;
            }else{
                self.currentPlayIndex = index;
            }
        }
            break;
        case MusicModeRandom:{//随机播放
            self.player.numberOfLoops = 0;
            self.currentPlayIndex = arc4random()%self.currentPlayListArr.count;
        }
            break;
        case MusicModeSingle:{//单曲循环
            self.player.numberOfLoops = 0;
            if (index < 0) {
                self.currentPlayIndex = self.currentPlayListArr.count - 1;
            }else if (index > self.currentPlayListArr.count - 1) {
                self.currentPlayIndex = 0;
            }else{
                self.currentPlayIndex = index;
            }
        }
            break;
            
        default:
            break;
    }
}


#pragma mark -AVAudioPlayerDelegate
//自动播放的情况
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    switch (self.currentPlayMode) {
        case MusicModeOrder:{//顺序播放
            if (self.currentPlayIndex>= 0 && self.currentPlayIndex < self.currentPlayListArr.count - 1) {
                //自动播放下一曲
                [self nextBtnACTION:self.nextBtn];
            }else{
                //更换歌曲信息
                [self setUpMusicPlayIcons];
            }
        }
            break;
        case MusicModeLoop:{//循环播放
            //自动播放下一曲
            [self nextBtnACTION:self.nextBtn];
        }
            break;
        case MusicModeRandom:{//随机播放
            //自动播放下一曲
            [self nextBtnACTION:self.nextBtn];
        }
            break;
        case MusicModeSingle:{//单曲循环
            //自动播放下一曲
            self.currentPlayIndex--;
            [self nextBtnACTION:self.nextBtn];
        }
            break;
            
        default:
            break;
    }
}
//播放失败
- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError * __nullable)error{
    [MBProgressHUD showError:@"播放失败"];
}

#pragma mark -MusicVCDelegate
-(void)backToLocalMusicListVCWithCurrentPlayListArr:(NSMutableArray *)currentPlayListArr andCurrentPlayIndex:(NSInteger)currentPlayIndex andPlayer:(AVAudioPlayer *)player andCurrentPlayMode:(MusicMode)currentPlayMode{
    self.currentPlayListArr = currentPlayListArr;
    if (currentPlayListArr.count <= 0) {
        self.currentModel = nil;
    }else{
        self.currentPlayIndex = currentPlayIndex;
        self.currentModel = self.currentPlayListArr[self.currentPlayIndex];
    }
    self.player = player;
    self.player.delegate = self;
    self.currentPlayMode = currentPlayMode;
    //配置音乐播放状态图标
    [self setUpMusicPlayIcons];
}


#pragma mark -CurrentMusicListViewDelegate
-(void)changePlayModeWithCurrentPlayMode:(MusicMode)currentPlayMode{//点击播放模式按钮
    self.currentPlayMode = currentPlayMode;
}
-(void)changeCurrentPlayListArr:(NSMutableArray *)currentPlayListArr{//点击清空按钮 
    self.currentPlayListArr = currentPlayListArr;
    if (self.currentPlayListArr.count <= 0) {
        [self.player pause];
        self.player = nil;
        self.currentModel = nil;
        //配置音乐播放状态图标
        [self setUpMusicPlayIcons];
    }
}
-(void)clickDeleteBtnToChangeCurrentPlayListArr:(NSMutableArray *)currentPlayListArr andCurrentModel:(MusicModel *)currentModel andChangeCurrentPlayIndex:(NSInteger)currentPlayIndex{//点击删除按钮
    self.currentPlayListArr = currentPlayListArr;
    self.currentPlayIndex = currentPlayIndex;
    //配置音乐播放状态图标
    [self setUpMusicPlayIcons];
    //删除的是当前正在播放的歌曲
    if (self.currentPlayListArr.count <= 0) {
        [self.player pause];
        self.player = nil;
        self.currentModel = nil;
        //配置音乐播放状态图标
        [self setUpMusicPlayIcons];
        
        return;
    }
    if ([self.currentModel isEqual:currentModel]) {
        [self.player pause];
        self.player = nil;
        self.currentModel = nil;
        //配置音乐播放状态图标
        [self setUpMusicPlayIcons];
    }
}
-(void)playMusicWithCurrentPlayListArr:(NSMutableArray *)currentPlayListArr andClickedIndex:(NSInteger)clickedIndex{//点击歌曲
    self.currentPlayListArr = currentPlayListArr;
    self.currentModel = self.currentPlayListArr[clickedIndex];
    self.currentPlayIndex = clickedIndex;
    //更换player
    [self.player pause];
    self.player = nil;
    self.player.delegate = self;
    NSString *fileName = [NSString stringWithFormat:@"%@.%@",self.currentModel.musicName,self.currentModel.type];
    self.player = [MusicPlayerHelper playMusic:fileName];
    [self.player play];
    //设置音乐状态
    [self setUpMusicPlayIcons];
    //是否正在播放
    [self makeSurePlaying];
}

#pragma mark -option菜单
-(void)optionBtnACTION:(UIButton *)sender{
    switch (sender.tag) {
        case 1000:{//我喜欢
            MyLikeMusicVC *myLikeMusic_VC = [[MyLikeMusicVC alloc]init];
            myLikeMusic_VC.sourceVC = @"LocalMusicListVC";
            [HSFHelper sharedHelper].currentPlayer = self.player;
            [self.navigationController pushViewController:myLikeMusic_VC animated:YES];
        }
            break;
        case 2000:{//我的收藏
            MyCollectionMusicVC *myCollectionMusic_VC = [[MyCollectionMusicVC alloc]init];
            myCollectionMusic_VC.sourceVC = @"LocalMusicListVC";
            [HSFHelper sharedHelper].currentPlayer = self.player;
            [self.navigationController pushViewController:myCollectionMusic_VC animated:YES];
        }
            break;
        case 3000:{//我的歌单
            MyMusicListVC *myMusicList_VC = [[MyMusicListVC alloc]init];
            myMusicList_VC.sourceVC = @"LocalMusicListVC";
            [HSFHelper sharedHelper].currentPlayer = self.player;
            [self.navigationController pushViewController:myMusicList_VC animated:YES];
        }
            break;
        case 4000:{//下载中心
            DownloadCenterVC *downloadCenter_VC = [[DownloadCenterVC alloc]init];
            [self.navigationController pushViewController:downloadCenter_VC animated:YES];
        }
            break;
        case 5000:{//最近播放
            ReccentPlayVC *recenterPlay_VC = [[ReccentPlayVC alloc]init];
            [self.navigationController pushViewController:recenterPlay_VC animated:YES];
        }
            break;
        case 6000:{//音乐库
            MusicLibVC *musicLib_VC = [[MusicLibVC alloc]init];
            [self.navigationController pushViewController:musicLib_VC animated:YES];
        }
            break;
        case 7000:{//电台
            RedioVC *redio_VC = [[RedioVC alloc]init];
            [self.navigationController pushViewController:redio_VC animated:YES];
        }
            break;
        case 8000:{//MV
            MVVC *mv_VC = [[MVVC alloc]init];
            [self.navigationController pushViewController:mv_VC animated:YES];
        }
            break;
            
        default:
            break;
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //发消息通知 更换singerPic
        [[NSNotificationCenter defaultCenter] postNotificationName:@"littlePlayer_changeSingerPic" object:nil userInfo:@{@"singerPic":self.singerPic.image}];
    });
    
}
#pragma mark -通知／用于音乐播放小空间
-(void)littlePlayerNotify:(NSNotification *)sender{
    NSDictionary *userInfo = sender.userInfo;
    NSString *action = userInfo[@"action"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.currentPlayListArr.count <= 0) {
            [MBProgressHUD showError:@"队列中暂无歌曲可以播放！"];
        }else{
            if ([action isEqualToString:@"next"]) {//下一曲
                [self nextBtnACTION:self.nextBtn];
            }else if ([action isEqualToString:@"last"]) {//上一曲
                if (self.currentPlayListArr.count <= 0) {
                    [MBProgressHUD showError:@"播放错误!"];
                }else{
                    self.currentPlayIndex--;
                    [self getUsableCurrentIndex:self.currentPlayIndex];//给index加保险
                    self.currentModel = self.currentPlayListArr[self.currentPlayIndex];
                    //更换player
                    [self.player pause];
                    self.player = nil;
                    self.player.delegate = self;
                    NSString *fileName = [NSString stringWithFormat:@"%@.%@",self.currentModel.musicName,self.currentModel.type];
                    self.player = [MusicPlayerHelper playMusic:fileName];
                    [self.player play];
                    //更换歌曲信息
                    [self setUpMusicPlayIcons];
                    //是否正在播放
                    [self makeSurePlaying];
                }
            }else if ([action isEqualToString:@"play"]) {//播放暂停
                [self playBtnACTION:self.playBtn];
            }
        }
        [HSFHelper sharedHelper].currentPlayer = self.player;
        //发消息通知 更换singerPic
        [[NSNotificationCenter defaultCenter] postNotificationName:@"littlePlayer_changeSingerPic" object:nil userInfo:@{@"singerPic":self.singerPic.image}];
    });
    
}



#pragma mark -didReceiveMemoryWarning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
