
//
//  MusicVC.m
//  CalendarDemo
//
//  Created by monkey2016 on 17/1/19.
//  Copyright © 2017年 monkey2016. All rights reserved.
//

#import "MusicVC.h"

@interface MusicVC ()<UITableViewDelegate,UITableViewDataSource,AVAudioPlayerDelegate,CurrentMusicListViewDelegate,MoreBtnMenuVCDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *blurryImageView;//模糊效果图片

//顶部
@property (weak, nonatomic) IBOutlet UIView *optionBgView;
@property (weak, nonatomic) IBOutlet UIButton *myLikeBtn;
@property (weak, nonatomic) IBOutlet UIButton *myCollectionBtn;
@property (weak, nonatomic) IBOutlet UIButton *myMusicListBtn;
@property (weak, nonatomic) IBOutlet UIButton *downloadCenterBtn;
@property (weak, nonatomic) IBOutlet UIButton *playRecentBtn;
@property (weak, nonatomic) IBOutlet UIButton *musicLibBtn;
@property (weak, nonatomic) IBOutlet UIButton *redioBtn;
@property (weak, nonatomic) IBOutlet UIButton *mvBtn;
//中间
@property (weak, nonatomic) IBOutlet UIView *contentBgView;
@property (weak, nonatomic) IBOutlet UIView *musicView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *singerPic;
//底部
@property (weak, nonatomic) IBOutlet UIView *controlBgView;
@property (weak, nonatomic) IBOutlet UIButton *addDownloadBtn;
@property (weak, nonatomic) IBOutlet UIButton *addLikeBtn;
@property (weak, nonatomic) IBOutlet UIButton *addListBtn;
@property (weak, nonatomic) IBOutlet UIButton *moreBtn;
@property (weak, nonatomic) IBOutlet UILabel *startTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *endTimeLabel;
@property (weak, nonatomic) IBOutlet UISlider *progressSlider;
@property (weak, nonatomic) IBOutlet UIButton *modeBtn;
@property (weak, nonatomic) IBOutlet UIButton *currentListBtn;
@property (weak, nonatomic) IBOutlet UIButton *lastBtn;
@property (weak, nonatomic) IBOutlet UIButton *playBtn;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;


@property (nonatomic,assign) BOOL isLrc;//歌词界面的切换 
@property (nonatomic,strong) UIView *titleView;//(歌曲名，歌手名)
@property (nonatomic,strong) MarqueeView *mar_music;
@property (nonatomic,strong) MarqueeView *mar_singer;
@property (nonatomic,strong) NSTimer *currentTimer;
@property (nonatomic,strong) MusicModel *currentModel;//当前播放歌曲
@property (nonatomic,strong) CurrentMusicListView *currentMusicList_View_player;
@property (nonatomic,strong) MoreBtnMenuVC *moreBtnMenuView;//其实这是个view 只是我命名时搞错了

@end

@implementation MusicVC
#pragma mark -懒加载
-(UIView *)titleView{
    if (!_titleView) {
        _titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 200, 44)];
        //歌名
        _mar_music = [[MarqueeView alloc]initWithFrame:CGRectMake(0, 0, _titleView.width, _titleView.height*2/3)];
        _mar_music.bgColor = [UIColor clearColor];
        _mar_music.fontColor = [UIColor whiteColor];
        _mar_music.fontSize = 17;
        [_titleView addSubview:_mar_music];
        //歌手名
        _mar_singer = [[MarqueeView alloc]initWithFrame:CGRectMake(0, _titleView.height * 2/3, _titleView.width, _titleView.height/3)];
        _mar_singer.bgColor = [UIColor clearColor];
        _mar_singer.fontColor = [UIColor whiteColor];
        _mar_singer.fontSize = 12;
        [_titleView addSubview:_mar_singer];
    }
    return _titleView;
}

-(CurrentMusicListView *)currentMusicList_View_player{
    if (!_currentMusicList_View_player) {
        _currentMusicList_View_player = [[CurrentMusicListView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
        _currentMusicList_View_player.delegate = self;
    }
    return _currentMusicList_View_player;
}

-(MoreBtnMenuVC *)moreBtnMenuView{
    if (!_moreBtnMenuView) {
        _moreBtnMenuView = [[MoreBtnMenuVC alloc]initWithFrame:[UIScreen mainScreen].bounds];
    }
    return _moreBtnMenuView;
}

#pragma mark -配置导航栏
-(void)setUpNavi{
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    //退出
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"back_common"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    //分享
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"shareIcon2_music"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(shareAction)];
    //标题
    self.navigationItem.titleView = self.titleView;
}
//退出
-(void)backAction{
    if ([self.delegate respondsToSelector:@selector(backToLocalMusicListVCWithCurrentPlayListArr:andCurrentPlayIndex:andPlayer:andCurrentPlayMode:)]) {
        [self.delegate backToLocalMusicListVCWithCurrentPlayListArr:self.currentPlayListArr andCurrentPlayIndex:self.currentPlayIndex andPlayer:self.player andCurrentPlayMode:self.currentPlayMode];
    }
    [self.navigationController popViewControllerAnimated:YES];
}
//分享
-(void)shareAction{
    
}

#pragma mark -viewWillAppear
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barTintColor = KRGB(23, 159, 155, 1.0);
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:20],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
}
#pragma mark -viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    //设置音乐播放器的代理
    self.currentModel = self.currentPlayListArr[self.currentPlayIndex];
    self.player.delegate = self;
    //配置计时器
    self.currentTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(currentTimerAction) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.currentTimer forMode:NSRunLoopCommonModes];
    [self.currentTimer setFireDate:[NSDate distantFuture]];
    //配置导航栏
    [self setUpNavi];
    //配置子视图
    [self setUpSubviews];
    //添加手势
    [self addGesture];
    //注册通知－－用于音乐播放小空间
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(littlePlayerNotify:) name:@"littlePlayer_player_notify" object:nil];
    
}
//配置计时器
-(void)currentTimerAction{
    self.progressSlider.value = self.player.currentTime;
    self.startTimeLabel.text = [NSString stringWithFormat:@"%02d:%02d",((int)self.player.currentTime)/60,((int)self.player.currentTime)%60];
    //旋转图片
    [UIView animateWithDuration:0.1 animations:^{
        [UIView setAnimationCurve:UIViewAnimationCurveLinear];
        self.singerPic.transform = CGAffineTransformRotate(self.singerPic.transform, M_PI/150);
    }];
    
}

//配置子视图
-(void)setUpSubviews{
    self.musicView.layer.masksToBounds = YES;
    self.musicView.layer.cornerRadius = (KScreenWidth - 60)/2;
    self.singerPic.layer.masksToBounds = YES;
    self.singerPic.layer.cornerRadius = (KScreenWidth - 160)/2;
    //图片模糊效果
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.blurryImageView.image = [UIImage imageNamed:self.currentModel.singerPic];
        [self blurEffect:self.blurryImageView];
    });
    //配置tableView
    [self setUpTableView];
    //当前歌曲
    [self setUpMusicPlayerIcons];
}
//配置tableView
-(void)setUpTableView{
    self.tableView.hidden = YES;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    //高度
    self.tableView.estimatedRowHeight = 44;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    //注册cell
    
}
//图片模糊效果
- (void)blurEffect:(UIImageView *)bgImgView {
    /**
     iOS8.0
     毛玻璃的样式(枚举)
     UIBlurEffectStyleExtraLight,
     UIBlurEffectStyleLight,
     UIBlurEffectStyleDark,
     
     // iOS 10新增的枚举值
     UIBlurEffectStyleRegular NS_ENUM_AVAILABLE_IOS(10_0), // Adapts to user interface style
     UIBlurEffectStyleProminent NS_ENUM_AVAILABLE_IOS(10_0), // Adapts to user interface style
     */
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
    effectView.frame = CGRectMake(0, 0, bgImgView.width, bgImgView.height);
    [bgImgView addSubview:effectView];
    
    // 加上以下代码可以使毛玻璃特效更明亮点
    UIVibrancyEffect *vibrancyView = [UIVibrancyEffect effectForBlurEffect:effect];
    UIVisualEffectView *visualEffectView = [[UIVisualEffectView alloc] initWithEffect:vibrancyView];
    visualEffectView.translatesAutoresizingMaskIntoConstraints = NO;
    [effectView.contentView addSubview:visualEffectView];
}

#pragma mark -UITableViewDelegate,UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 100;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell;
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }else{
        cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    }
    cell.textLabel.text = @"新年好！";
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}
-(BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    return NO;
}

#pragma mark -添加手势
-(void)addGesture{
//菜单    
    self.contentBgView.userInteractionEnabled = YES;
    //添加下滑手势 弹出菜单（option）
    UISwipeGestureRecognizer *swipeDown = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeMenuACTION:)];
    swipeDown.direction = UISwipeGestureRecognizerDirectionDown;
    [self.contentBgView addGestureRecognizer:swipeDown];
    //添加上滑手势 收起菜单（option）
    UISwipeGestureRecognizer *swipeUp = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeMenuACTION:)];
    swipeUp.direction = UISwipeGestureRecognizerDirectionUp;
    [self.contentBgView addGestureRecognizer:swipeUp];
//点击歌词切换
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(singleTapChangeLrc:)];
    [self.contentBgView addGestureRecognizer:singleTap];
    
//歌曲切换
    self.musicView.userInteractionEnabled = YES;
    //添加左滑手势（下一曲）
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeMusicACTION:)];
    swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.musicView addGestureRecognizer:swipeLeft];
    //添加右滑手势（上一曲）
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeMusicACTION:)];
    swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
    [self.musicView addGestureRecognizer:swipeRight];
}
//扫动手势 弹出\收起 菜单（option）
-(void)swipeMenuACTION:(UISwipeGestureRecognizer *)sender{
    CGRect newFrame;
    if (sender.direction == UISwipeGestureRecognizerDirectionDown) {//弹出
        newFrame = CGRectMake(0, 0, self.optionBgView.width, self.optionBgView.height);
    }else if (sender.direction == UISwipeGestureRecognizerDirectionUp) {//收起
        newFrame = CGRectMake(0, -self.optionBgView.height, self.optionBgView.width, self.optionBgView.height);
    }
    [UIView animateWithDuration:0.2 animations:^{
        self.optionBgView.frame = newFrame;
    }];
}
//单击切换歌词界面
-(void)singleTapChangeLrc:(UITapGestureRecognizer *)sender{
    self.isLrc = !self.isLrc;
    if (self.isLrc) {//显示歌词
        [self.contentBgView bringSubviewToFront:self.tableView];
        self.tableView.hidden = NO;
        self.musicView.hidden = YES;
    }else{//不显示歌词
        [self.contentBgView sendSubviewToBack:self.tableView];
        self.tableView.hidden = YES;
        self.musicView.hidden = NO;
    }
}
//扫动手势 上一曲\下一曲
-(void)swipeMusicACTION:(UISwipeGestureRecognizer *)sender{
    CATransition *ca=[CATransition animation];
    ca.duration=0.5;
    ca.type=@"push";
    if (sender.direction == UISwipeGestureRecognizerDirectionRight) {//上一曲
        ca.subtype=kCATransitionFromLeft;
        //模拟点击上一曲
        [self lastMusicBtnACTION:self.lastBtn];
    }else if (sender.direction == UISwipeGestureRecognizerDirectionLeft) {//下一曲
        ca.subtype=kCATransitionFromRight;
        //模拟点击下一曲
        [self nextMusicBtnACTION:self.nextBtn];
    }
    [self.musicView.layer addAnimation:ca forKey:nil];
}
//配置音乐播放状态图片
-(void)setUpMusicPlayerIcons{
    //歌曲信息
    if (self.currentPlayListArr.count <= 0) {
        self.mar_music.title = @"爱音乐，爱生活";
        self.mar_singer.title = @"音乐也能改变世界";
        self.singerPic.image = [UIImage imageNamed:@"placeholder3_music_player"];
        self.singerPic.transform = CGAffineTransformIdentity;
        //开始计时器
        [self.currentTimer setFireDate:[NSDate distantPast]];
    }else{
        self.mar_music.title = self.currentModel.musicName;
        self.mar_singer.title = self.currentModel.singerName;
        self.singerPic.image = [UIImage imageNamed:self.currentModel.singerPic];
        //是否开始计时器
        if (self.player.isPlaying) {
            [self.currentTimer setFireDate:[NSDate distantPast]];
        }else{
            [self.currentTimer setFireDate:[NSDate distantFuture]];
        }
    }
    //播放状态
    if (self.player.isPlaying) {
        [self.playBtn setImage:[UIImage imageNamed:@"stop_music"] forState:UIControlStateNormal];
    }else{
        [self.playBtn setImage:[UIImage imageNamed:@"play_music"] forState:UIControlStateNormal];
    }
    //进度条
    self.progressSlider.minimumValue = 0.0;
    self.progressSlider.maximumValue = self.player.duration;
    self.progressSlider.value = self.player.currentTime;
    self.startTimeLabel.text = [NSString stringWithFormat:@"%02d:%02d",((int)self.player.currentTime)/60,((int)self.player.currentTime)%60];
    self.endTimeLabel.text = [NSString stringWithFormat:@"%02d:%02d",((int)self.player.duration)/60,((int)self.player.duration)%60];
    //当前播放模式
    [self getModeBtnImage];
    //是否为我喜欢歌曲
    NSString *isLike = self.currentModel.isLike;
    if ([isLike isEqualToString:@"0"]) {
        [self.addLikeBtn setImage:[UIImage imageNamed:@"like_music"] forState:UIControlStateNormal];
    }else if ([isLike isEqualToString:@"1"]) {
        [self.addLikeBtn setImage:[UIImage imageNamed:@"like_hd_music"] forState:UIControlStateNormal];
    }
}

#pragma mark -菜单
- (IBAction)optionBtnACTION:(UIButton *)sender {
    switch (sender.tag) {
        case 1000:{//我喜欢
            MyLikeMusicVC *myLikeMusic_VC = [[MyLikeMusicVC alloc]init];
            myLikeMusic_VC.sourceVC = @"MusicVC";
            [self.navigationController pushViewController:myLikeMusic_VC animated:YES];
        }
            break;
        case 2000:{//我的收藏
            MyCollectionMusicVC *myCollectionMusic_VC = [[MyCollectionMusicVC alloc]init];
            myCollectionMusic_VC.sourceVC = @"MusicVC";
            [self.navigationController pushViewController:myCollectionMusic_VC animated:YES];
        }
            break;
        case 3000:{//我的歌单
            MyMusicListVC *myMusicList_VC = [[MyMusicListVC alloc]init];
            myMusicList_VC.sourceVC = @"MusicVC";
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
}
#pragma mark -通知／用于音乐播放小空间
-(void)littlePlayerNotify:(NSNotification *)sender{
    NSDictionary *userInfo = sender.userInfo;
    NSString *action = userInfo[@"action"];
    if (self.currentPlayListArr.count <= 0) {
        [MBProgressHUD showError:@"队列中暂无歌曲可以播放！"];
    }else{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if ([action isEqualToString:@"next"]) {//下一曲
                [self nextMusicBtnACTION:self.nextBtn];
            }else if ([action isEqualToString:@"last"]) {//上一曲
                [self lastMusicBtnACTION:self.lastBtn];
            }else if ([action isEqualToString:@"play"]) {//播放暂停
                [self playOrStopACTION:self.playBtn];
            }
        });
    }
}

#pragma mark -音乐控制部分1（bottom）
//播放／暂停
- (IBAction)playOrStopACTION:(UIButton *)sender {
    if (self.currentPlayListArr.count <= 0) {
        [MBProgressHUD showError:@"播放队列中没有可以播放的歌曲！"];
    }else{
        if (self.player.isPlaying) {
            [self.player pause];
            [sender setImage:[UIImage imageNamed:@"play_music"] forState:UIControlStateNormal];
        }else{
            [self.player play];
            [sender setImage:[UIImage imageNamed:@"stop_music"] forState:UIControlStateNormal];
        }
    }
}
//上一曲
- (IBAction)lastMusicBtnACTION:(UIButton *)sender {
    if (self.currentPlayListArr.count <= 0) {
        [MBProgressHUD showError:@"播放队列中没有可以播放的歌曲！"];
    }else{
        self.currentPlayIndex--;
        [self getUsablePlayerCurrentIndex:self.currentPlayIndex];//给index加保险
        self.currentModel = self.currentPlayListArr[self.currentPlayIndex];
        //更换player
        [self.player pause];
        self.player = nil;
        NSString *fileName = [NSString stringWithFormat:@"%@.%@",self.currentModel.musicName,self.currentModel.type];
        self.player = [MusicPlayerHelper playMusic:fileName];
        self.player.delegate = self;
        [self.player play];
    }
    self.singerPic.transform = CGAffineTransformIdentity;
    //更换歌曲信息
    [self setUpMusicPlayerIcons];
    //是否正在播放
    [self makeSurePlaying];
}
//下一曲
- (IBAction)nextMusicBtnACTION:(UIButton *)sender {
    if (self.currentPlayListArr.count <= 0) {
        [MBProgressHUD showError:@"播放队列中没有可以播放的歌曲！"];
    }else{
        self.currentPlayIndex++;
        [self getUsablePlayerCurrentIndex:self.currentPlayIndex];//给index加保险
        self.currentModel = self.currentPlayListArr[self.currentPlayIndex];
        //更换player
        [self.player pause];
        self.player = nil;
        NSString *fileName = [NSString stringWithFormat:@"%@.%@",self.currentModel.musicName,self.currentModel.type];
        self.player = [MusicPlayerHelper playMusic:fileName];
        self.player.delegate = self;
        [self.player play];
    }
    self.singerPic.transform = CGAffineTransformIdentity;
    //更换歌曲信息
    [self setUpMusicPlayerIcons];
    //是否正在播放
    [self makeSurePlaying];
}
//播放模式
- (IBAction)modeBtnACTION:(UIButton *)sender {
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
}
//当前播放列表
- (IBAction)currentListBtnACTION:(UIButton *)sender {
    [KMyWindow addSubview:self.currentMusicList_View_player];
    self.currentMusicList_View_player.title.text = [NSString stringWithFormat:@"当前播放列表（%ld）",self.currentPlayListArr.count];
    self.currentMusicList_View_player.currentPlayMode = self.currentPlayMode;
    self.currentMusicList_View_player.currentPlayListArr = self.currentPlayListArr;
    self.currentMusicList_View_player.currentPlayIndex = self.currentPlayIndex;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.currentMusicList_View_player show];
    });
}
//歌曲进度
- (IBAction)progressSlideACTION:(UISlider *)sender {
    if (sender.value < self.player.duration - 5) {
        self.player.currentTime = sender.value;
    }else{
        return;
    }
}
//当前播放模式
-(void)getModeBtnImage{
    switch (self.currentPlayMode) {
        case MusicModeOrder:{//顺序播放
            [self.modeBtn setImage:[UIImage imageNamed:@"order_music"] forState:UIControlStateNormal];
        }
            break;
        case MusicModeSingle:{//单曲循环
            [self.modeBtn setImage:[UIImage imageNamed:@"single_music"] forState:UIControlStateNormal];
        }
            break;
        case MusicModeLoop:{//循环列表
            [self.modeBtn setImage:[UIImage imageNamed:@"loop_music"] forState:UIControlStateNormal];
        }
            break;
        case MusicModeRandom:{//随机播放
            [self.modeBtn setImage:[UIImage imageNamed:@"random_music"] forState:UIControlStateNormal];
        }
            break;
            
        default:
            break;
    }
}
//获取可用的播放下标
-(void)getUsablePlayerCurrentIndex:(NSInteger)index{
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
#pragma mark -音乐控制部分2（bottom）
//下载
- (IBAction)addDownloadBtnACTION:(UIButton *)sender {
}
//添加到我喜欢
- (IBAction)addLikeBtnACTION:(UIButton *)sender {
    //是否为我喜欢歌曲
    NSString *isLike = self.currentModel.isLike;
    if ([isLike isEqualToString:@"0"]) {
        [self.addLikeBtn setImage:[UIImage imageNamed:@"like_hd_music"] forState:UIControlStateNormal];
        self.currentModel.isLike = @"1";
    }else if ([isLike isEqualToString:@"1"]) {
        [self.addLikeBtn setImage:[UIImage imageNamed:@"like_music"] forState:UIControlStateNormal];
        self.currentModel.isLike = @"0";
    }
    //改变数据库中的状态
    [[HSFFmdbManager sharedManager] modifyLocalMusicWith:self.currentModel whereCondition:@{@"musicName":self.currentModel.musicName}];
}
//添加到歌单
- (IBAction)addListBtnACTION:(UIButton *)sender {
}
//更多按钮
- (IBAction)MoreBtnACTION:(UIButton *)sender {
    [KMyWindow addSubview:self.moreBtnMenuView];
    self.moreBtnMenuView.delegate = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.moreBtnMenuView show];
    });
}


#pragma mark -AVAudioPlayerDelegate
//自动播放的情况
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    switch (self.currentPlayMode) {
        case MusicModeOrder:{//顺序播放
            if (self.currentPlayIndex>= 0 && self.currentPlayIndex < self.currentPlayListArr.count - 1) {
                //自动播放下一曲
                [self nextMusicBtnACTION:self.nextBtn];
            }else{
                //更换歌曲信息
                [self setUpMusicPlayerIcons];
            }
        }
            break;
        case MusicModeLoop:{//循环播放
            //自动播放下一曲
            [self nextMusicBtnACTION:self.nextBtn];
        }
            break;
        case MusicModeRandom:{//随机播放
            //自动播放下一曲
            [self nextMusicBtnACTION:self.nextBtn];
        }
            break;
        case MusicModeSingle:{//单曲循环
            //自动播放下一曲
            self.currentPlayIndex--;
            [self nextMusicBtnACTION:self.nextBtn];
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

#pragma mark -CurrentMusicListViewDelegate
-(void)changePlayModeWithCurrentPlayMode:(MusicMode)currentPlayMode{//点击播放模式按钮
    self.currentPlayMode = currentPlayMode;
    [self getModeBtnImage];
}
-(void)changeCurrentPlayListArr:(NSMutableArray *)currentPlayListArr{//点击清空按钮 
    self.currentPlayListArr = currentPlayListArr;
    if (self.currentPlayListArr.count <= 0) {
        [self.player pause];
        self.player = nil;
        self.currentModel = nil;
        //更换歌曲信息
        [self setUpMusicPlayerIcons];
    }
}
-(void)clickDeleteBtnToChangeCurrentPlayListArr:(NSMutableArray *)currentPlayListArr andCurrentModel:(MusicModel *)currentModel andChangeCurrentPlayIndex:(NSInteger)currentPlayIndex{//点击删除按钮
    self.currentPlayListArr = currentPlayListArr;
    self.currentPlayIndex = currentPlayIndex;
    //更换歌曲信息
    [self setUpMusicPlayerIcons];
    //删除的是当前正在播放的歌曲
    if (self.currentPlayListArr.count <= 0) {
        [self.player pause];
        self.player = nil;
        self.currentModel = nil;
        //更换歌曲信息
        [self setUpMusicPlayerIcons];
        return;
    }
    if ([self.currentModel isEqual:currentModel]) {
        [self.player pause];
        self.player = nil;
        self.currentModel = nil;
        //更换歌曲信息
        [self setUpMusicPlayerIcons];
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
    //更换歌曲信息
    [self setUpMusicPlayerIcons];
    //是否正在播放
    [self makeSurePlaying];
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

#pragma mark -音量 MoreBtnMenuVCDelegate
-(void)dragSoundSliderWithValue:(CGFloat)value{
    self.player.volume = value;
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
