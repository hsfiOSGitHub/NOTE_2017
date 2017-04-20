//
//  LittlePlayerView.m
//  CalendarDemo
//
//  Created by monkey2016 on 17/1/24.
//  Copyright © 2017年 monkey2016. All rights reserved.
//

#import "LittlePlayerView.h"

#define space 20

@interface LittlePlayerView ()

@property (nonatomic,strong) UIView *iconBgView;
@property (nonatomic,strong) UIImageView *iconImgView;
@property (nonatomic,strong) UIView *contentView;
@property (nonatomic,strong) UIButton *lastMusicBtn;
@property (nonatomic,strong) UIButton *nextMusicBtn;
@property (nonatomic,strong) UIButton *playBtn;
@property (nonatomic,assign) CGFloat contentViewWidth;

@property (nonatomic,strong) NSTimer *timer;

@end


@implementation LittlePlayerView

#pragma mark -懒加载
-(NSTimer *)timer{
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(timerAction:) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
        [_timer setFireDate:[NSDate distantFuture]];
    }
    return _timer;
}
-(void)timerAction:(NSTimer *)sender{
    //旋转图片
    [UIView animateWithDuration:0.1 animations:^{
        [UIView setAnimationCurve:UIViewAnimationCurveLinear];
        self.iconImgView.transform = CGAffineTransformRotate(self.iconImgView.transform, M_PI/150);
    }];
}

//初始化方法
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self createSubViews];
        //注册通知更换singerPic
        [self registerNotify];
    }
    return self;
}
-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        [self createSubViews];
        //注册通知更换singerPic
        [self registerNotify];
    }
    return self;
}

#pragma mark -注册通知更换singerPic
-(void)registerNotify{
    self.iconImgView.transform = CGAffineTransformIdentity;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeSingerPic:) name:@"littlePlayer_changeSingerPic" object:nil];
}
-(void)changeSingerPic:(NSNotification *)sender{
    self.iconImgView.image = sender.userInfo[@"singerPic"];
}

#pragma mark -配置子视图
-(void)createSubViews{
    self.backgroundColor = [UIColor clearColor];
    self.layer.masksToBounds = YES;
    //图标
    self.iconBgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.height, self.height)];
    [self addSubview:self.iconBgView];
    
    self.iconImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.height, self.height)];
    self.iconImgView.image = [UIImage imageNamed:@"placeholder3_music_player"];
    [self.iconBgView addSubview:self.iconImgView];
    self.iconImgView.layer.masksToBounds = YES;
    self.iconImgView.layer.cornerRadius = (self.height)/2;
    self.iconImgView.layer.borderWidth = 2;
    self.iconImgView.layer.borderColor = KRGB(23, 159, 155, 1.0).CGColor;
    
    self.iconBgView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(iconImgViewACTION:)];
    [self.iconBgView addGestureRecognizer:tap];
    //内容视图
    self.contentViewWidth = (40*3 + space *4);
    self.contentView = [[UIView alloc]initWithFrame:CGRectMake(self.iconImgView.maxX, 0, self.contentViewWidth, self.height)];
    self.contentView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.contentView];
    self.contentView.layer.masksToBounds = YES;
    self.contentView.layer.cornerRadius = self.contentView.height/2;
    //上一曲
    self.lastMusicBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.lastMusicBtn.frame = CGRectMake(space, 0, 40, 40);
    self.lastMusicBtn.center = CGPointMake(self.lastMusicBtn.centerX, self.contentView.centerY);
    [self.lastMusicBtn setImage:[UIImage imageNamed:@"next_music_local"] forState:UIControlStateNormal];
    self.lastMusicBtn.transform = CGAffineTransformRotate(self.lastMusicBtn.transform, M_PI);//旋转180度(因为图标的问题)
    [self.lastMusicBtn addTarget:self action:@selector(lastMusicBtnACTION:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.lastMusicBtn];
    //播放
    self.playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.playBtn.frame = CGRectMake(self.lastMusicBtn.maxX + space, 0, 40, 40);
    self.playBtn.center = CGPointMake(self.playBtn.centerX, self.contentView.centerY);
    AVAudioPlayer *player = [HSFHelper sharedHelper].currentPlayer;
    if (player.isPlaying) {
        [self.playBtn setImage:[UIImage imageNamed:@"stop_music_local"] forState:UIControlStateNormal];
        [self.timer setFireDate:[NSDate distantPast]];//开始定时器
    }else{
        [self.playBtn setImage:[UIImage imageNamed:@"play_music_local"] forState:UIControlStateNormal];
        [self.timer setFireDate:[NSDate distantFuture]];//暂停定时器
    }
    
    [self.playBtn addTarget:self action:@selector(playBtnACTION:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.playBtn];
    //下一曲
    self.nextMusicBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.nextMusicBtn.frame = CGRectMake(self.playBtn.maxX + space, 0, 40, 40);
    self.nextMusicBtn.center = CGPointMake(self.nextMusicBtn.centerX, self.contentView.centerY);
    [self.nextMusicBtn setImage:[UIImage imageNamed:@"next_music_local"] forState:UIControlStateNormal];
    [self.nextMusicBtn addTarget:self action:@selector(nextMusicBtnACTION:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.nextMusicBtn];
}
#pragma mark -点击事件
//点击iconImgView
-(void)iconImgViewACTION:(UITapGestureRecognizer *)sender{
    if (self.width > self.iconImgView.height) {
        [self close];
    }else{
        [self open];
    }
}
//点击上一曲
-(void)lastMusicBtnACTION:(UIButton *)sender{
    if ([self.sourceVC isEqualToString:@"LocalMusicListVC"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"littlePlayer_local_notify" object:nil userInfo:@{@"action":@"last"}];
    }else if ([self.sourceVC isEqualToString:@"MusicVC"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"littlePlayer_player_notify" object:nil userInfo:@{@"action":@"last"}];
    }
    AVAudioPlayer *player = [HSFHelper sharedHelper].currentPlayer;
    if (player.isPlaying) {
        [self.playBtn setImage:[UIImage imageNamed:@"stop_music_local"] forState:UIControlStateNormal];
    }else{
        [self.playBtn setImage:[UIImage imageNamed:@"play_music_local"] forState:UIControlStateNormal];
    }
    
    [self.timer setFireDate:[NSDate distantPast]];//开始定时器
}
//点击播放按钮
-(void)playBtnACTION:(UIButton *)sender{    
    
    if ([self.sourceVC isEqualToString:@"LocalMusicListVC"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"littlePlayer_local_notify" object:nil userInfo:@{@"action":@"play"}];
    }else if ([self.sourceVC isEqualToString:@"MusicVC"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"littlePlayer_player_notify" object:nil userInfo:@{@"action":@"play"}];
    }
    
    AVAudioPlayer *player = [HSFHelper sharedHelper].currentPlayer;
    if (player.isPlaying) {
        [self.playBtn setImage:[UIImage imageNamed:@"play_music_local"] forState:UIControlStateNormal];
        [self.timer setFireDate:[NSDate distantFuture]];//暂停定时器
    }else{
        [self.playBtn setImage:[UIImage imageNamed:@"stop_music_local"] forState:UIControlStateNormal];
        [self.timer setFireDate:[NSDate distantPast]];//开始定时器
    }
    
}
//点击下一曲
-(void)nextMusicBtnACTION:(UIButton *)sender{
    if ([self.sourceVC isEqualToString:@"LocalMusicListVC"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"littlePlayer_local_notify" object:nil userInfo:@{@"action":@"next"}];
    }else if ([self.sourceVC isEqualToString:@"MusicVC"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"littlePlayer_player_notify" object:nil userInfo:@{@"action":@"next"}];
    }
    AVAudioPlayer *player = [HSFHelper sharedHelper].currentPlayer;
    if (player.isPlaying) {
        [self.playBtn setImage:[UIImage imageNamed:@"stop_music_local"] forState:UIControlStateNormal];
    }else{
        [self.playBtn setImage:[UIImage imageNamed:@"play_music_local"] forState:UIControlStateNormal];
    }
    [self.timer setFireDate:[NSDate distantPast]];//开始定时器
}

#pragma mark -打开、关闭
-(void)open{
    self.backgroundColor = KRGB(244, 244, 244, 1);
    CGRect fromRect;
    CGRect toRect;
    CGPoint center = self.center;
    if (center.x < self.superview.width/2) {
        fromRect = CGRectMake(self.iconBgView.width, 0, 0, self.contentView.height);
        toRect = CGRectMake(self.iconBgView.width, 0, _contentViewWidth, self.contentView.height);
        
        self.iconBgView.frame = CGRectMake(0, 0, self.iconBgView.width, self.iconBgView.height);
        self.contentView.frame = fromRect;
        self.contentView.center = CGPointMake(self.contentView.centerX, self.iconBgView.centerY);
        [UIView animateWithDuration:0.4 animations:^{
            self.frame = CGRectMake(0, self.y, (self.iconBgView.width + _contentViewWidth), self.height);
            self.contentView.frame = toRect;
            self.contentView.center = CGPointMake(self.contentView.centerX, self.iconBgView.centerY);
        }];
    }else if (center.x >= self.superview.width/2) {
        fromRect = CGRectMake(_contentViewWidth, 0, 0, self.contentView.height);
        toRect = CGRectMake(0, 0, _contentViewWidth, self.contentView.height);
        
        self.iconBgView.frame = CGRectMake(_contentViewWidth, 0, self.iconBgView.width, self.iconBgView.height);
        self.contentView.frame = fromRect;
        self.contentView.center = CGPointMake(self.contentView.centerX, self.iconBgView.centerY);
        [UIView animateWithDuration:0.4 animations:^{
            self.frame = CGRectMake((self.superview.width - (self.iconBgView.width + _contentViewWidth)), self.y, (self.iconBgView.width + _contentViewWidth), self.height);
            self.contentView.frame = toRect;
            self.contentView.center = CGPointMake(self.contentView.centerX, self.iconBgView.centerY);
        }];
    }
}
-(void)close{
    self.backgroundColor = [UIColor clearColor];
    CGRect fromRect;
    CGRect toRect;
    CGPoint center = self.center;
    if (center.x < self.superview.width/2) {
        toRect = CGRectMake(self.iconBgView.width, 0, 0, self.contentView.height);
        fromRect = CGRectMake(self.iconBgView.width, 0, _contentViewWidth, self.contentView.height);
        
        self.iconBgView.frame = CGRectMake(0, 0, self.iconBgView.width, self.iconBgView.height);
        self.contentView.frame = fromRect;
        self.contentView.center = CGPointMake(self.contentView.centerX, self.iconBgView.centerY);
        [UIView animateWithDuration:0.4 animations:^{
            self.frame = CGRectMake(0, self.y, self.iconBgView.width, self.height);
            self.contentView.frame = toRect;
            self.contentView.center = CGPointMake(self.contentView.centerX, self.iconBgView.centerY);
        }];
    }else if (center.x >= self.superview.width/2) {
        toRect = CGRectMake(_contentViewWidth, 0, 0, self.contentView.height);
        fromRect = CGRectMake(0, 0, _contentViewWidth, self.contentView.height);
        
        self.iconBgView.frame = CGRectMake(_contentViewWidth, 0, self.iconBgView.width, self.iconBgView.height);
        self.contentView.frame = fromRect;
        self.contentView.center = CGPointMake(self.contentView.centerX, self.iconBgView.centerY);
        [UIView animateWithDuration:0.4 animations:^{
            self.frame = CGRectMake((self.superview.width - self.iconBgView.width), self.y, self.iconBgView.width, self.iconBgView.height);
            self.iconBgView.frame = CGRectMake(0, 0, self.iconBgView.width, self.iconBgView.height);
            self.contentView.frame = toRect;
            self.contentView.center = CGPointMake(self.contentView.centerX, self.iconBgView.centerY);
        }];
    }
}


//拖动
- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event  
{  
    //保存触摸起始点位置  
    CGPoint point = [[touches anyObject] locationInView:self];  
    startPoint = point;  
    
    //该view置于最前  
    [[self superview] bringSubviewToFront:self];  
}  

-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event  
{  
    CGFloat currentCenterX = self.centerX;
    
    //计算位移=当前位置-起始位置  
    CGPoint point = [[touches anyObject] locationInView:self];  
    float dx = point.x - startPoint.x;  
    float dy = point.y - startPoint.y;  
    
    //计算移动后的view中心点  
    CGPoint newcenter = CGPointMake(self.center.x + dx, self.center.y + dy);  
    
    
    /* 限制用户不可将视图托出屏幕 */  
    float halfx = CGRectGetMidX(self.bounds);  
    //x坐标左边界  
    newcenter.x = MAX(halfx, newcenter.x);  
    //x坐标右边界  
    newcenter.x = MIN(self.superview.bounds.size.width - halfx, newcenter.x);  
    
    //y坐标同理  
    float halfy = CGRectGetMidY(self.bounds);  
    newcenter.y = MAX(halfy, newcenter.y);  
    newcenter.y = MIN(self.superview.bounds.size.height - halfy, newcenter.y);  
    
    //移动view      
    if (self.width>self.iconImgView.height) {//展开时
        self.center = CGPointMake(currentCenterX, newcenter.y);
    }else{//收起时
        self.center = newcenter; 
    }
}
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    if (self.width>self.iconImgView.height) {//展开时
        
    }else{//收起时
        CGPoint center = self.center;
        if (center.x < self.superview.width/2) {
            center.x = self.width/2;
        }
        if (center.x >= self.superview.width/2) {
            center.x = self.superview.width - self.width/2;
        }
        [UIView animateWithDuration:0.2 animations:^{
            self.center = center;
        }];
    }
    
}

@end
