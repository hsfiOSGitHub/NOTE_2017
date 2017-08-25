//
//  HSFLuckyView.m
//  LuckyDemo
//
//  Created by JuZhenBaoiMac on 2017/7/3.
//  Copyright © 2017年 JuZhenBaoiMac. All rights reserved.
//

#import "HSFLuckyView.h"

#import "HSFLuckyItem.h"

#define k_padding 10



@interface HSFLuckyView ()

@property (nonatomic,strong) UIButton *startBtn;
@property (nonatomic,strong) UIImageView *bgView;

@property (nonatomic,strong) NSTimer *myTimer;
@property (nonatomic,strong) NSMutableArray *itemsArr;

@property (nonatomic,strong) NSMutableArray *arr1;
@property (nonatomic,strong) NSMutableArray *arr2;
@property (nonatomic,strong) NSMutableArray *arr3;
@property (nonatomic,strong) NSMutableArray *arr4;

@property (nonatomic,assign) float intervalTime;//变换时间差（用来表示速度）
@property (nonatomic,strong) HSFLuckyItem *currentItem;
@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,assign) NSInteger num_decrease;//减速时段需要跳过多少个item
@property (nonatomic,assign) NSInteger curNum_decrease;//减速时段当前跳过的item

@property (nonatomic,assign) BOOL isRunning;//是否在运行

@end

@implementation HSFLuckyView
#pragma mark -初始化方法
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}
#pragma mark -配置
-(void)setUp{
    
    //添加背景图片
    UIImageView *bgImgView = [[UIImageView alloc]initWithFrame:self.bounds];
    bgImgView.image = [UIImage imageNamed:self.bgImgName];
    [self addSubview:bgImgView];
    //添加imgView
    NSInteger row = self.size.section;
    NSInteger line = self.size.row;
    NSInteger count = row * line;
    CGFloat w = (self.frame.size.width - k_padding*(line - 1))/line;
    CGFloat h = (self.frame.size.height - k_padding*(row - 1))/row;
    //用于计算中间startBtn的位置
    CGFloat x_start = 0.0;
    CGFloat y_start = 0.0;
    CGFloat x_end = 0.0;
    CGFloat y_end = 0.0;
    
    for (int i = 0; i < count; i++) {
        CGFloat x = (w + k_padding) * (i%line);
        CGFloat y = (h + k_padding) * (i/line);
        if ((x>0 && y>0) && (x < (w + k_padding)*(line-1) && y < (h + k_padding)*(row - 1))) {
            //计算中间startBtn的位置
            if (i == line + 1) {
                x_start = x;
                y_start = y;
            }
            if (i == count - (line + 2)) {
                x_end = x;
                y_end = y;
            }
        }else{
            //添加img
            HSFLuckyItem *item = [[HSFLuckyItem alloc]initWithFrame:CGRectMake(x, y, w, h)];
            
            [self addSubview:item];
            
            if (i/line == 0) {
                [self.arr1 addObject:item];
            }
            if (i%line == line - 1) {
                [self.arr2 addObject:item];
            }
            if (i/line == row - 1) {
                [self.arr3 addObject:item];
            }
            if (i%line == 0) {
                [self.arr4 addObject:item];
            }
        }
    }
    //添加中间的startBtn
    CGFloat x_btn = x_start;
    CGFloat y_btn = y_start;
    CGFloat w_btn = x_end - x_start + w;
    CGFloat h_btn = y_end - y_start + h;
    self.startBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.startBtn.frame = CGRectMake(x_btn, y_btn, w_btn, h_btn);
    [self.startBtn setImage:[UIImage imageNamed:self.startBtnImgName] forState:UIControlStateNormal];
    [self.startBtn addTarget:self action:@selector(startACTION) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.startBtn];
        
    //添加title image
    [self changeDirectionWith:self.direction];
    [self.itemsArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        HSFLuckyItem *item = (HSFLuckyItem *)obj;
        [item setTag:(666 + idx)];
        item.maskViewColor = [UIColor clearColor];
        item.source = self.arr_source[idx];
        [item setUp];
    }];
}

#pragma mark -开始  -抽奖按钮按下后的准备工作
-(void)startACTION{
    self.num_decrease = 10;
    self.curNum_decrease = 0;
    self.intervalTime = 0.7;//起始的变换时间差（速度）
    if (!self.currentItem) {
        self.currentItem = self.itemsArr[0];
    }
    self.startBtn.userInteractionEnabled = NO;
    self.isRunning = YES;
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:self.intervalTime target:self selector:@selector(startLotterry:) userInfo:nil repeats:NO];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    if ([self.delegate respondsToSelector:@selector(didClickStartBtn:startBtn:)]) {
        [self.delegate didClickStartBtn:self startBtn:self.startBtn];
    }
}

#pragma mark -停止
-(void)stopACTION{
    self.isRunning = NO;
}

#pragma mark -定时器动作 //开始抽奖
-(void)startLotterry:(NSTimer *)sender{
    
    NSInteger count = self.itemsArr.count;
    NSInteger index = self.currentItem.tag - 666;
    index++;
    if (index==count) {
        self.currentItem = self.itemsArr[0];
    }else{
        self.currentItem = self.itemsArr[index];
    }
    
    //更换图片
    [self changePic];
    
    if (self.intervalTime > 0.05) {
        self.intervalTime = self.intervalTime - 0.05;
    }
    
    if (self.isRunning) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:self.intervalTime target:self selector:@selector(startLotterry:) userInfo:nil repeats:NO];
        [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    }else{
        if (self.stopIndex) {
            if (index == [self.stopIndex integerValue]) {
                [self.timer invalidate];
                self.startBtn.userInteractionEnabled = YES;
            }else{
                self.timer = [NSTimer scheduledTimerWithTimeInterval:self.intervalTime target:self selector:@selector(startLotterry:) userInfo:nil repeats:NO];
                [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
            }
        }else{
            //停止
        }
    }
}


#pragma mark -更换图片
-(void)changePic{
    //上一个
    NSInteger count = self.itemsArr.count;
    NSInteger index = self.currentItem.tag - 666 - 1;
    HSFLuckyItem *item;
    if (index<0) {
        item = self.itemsArr[count - 1];
        item.maskViewColor = [UIColor clearColor];
        
    }else{
        item = self.itemsArr[index];
        item.maskViewColor = [UIColor clearColor];
    }
    [item setUp];
    //当前的
    self.currentItem.maskViewColor = self.maskViewColor;
    [self.currentItem setUp];
}

#pragma mark -item圆角
-(void)itemCornerRadius:(CGFloat)cornerRadius borderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth{
    [self.itemsArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        HSFLuckyItem *item = (HSFLuckyItem *)obj;
        item.layer.masksToBounds = YES;
        item.layer.cornerRadius = cornerRadius;
        item.layer.borderColor = borderColor.CGColor;
        item.layer.borderWidth = borderWidth;
    }];
}

#pragma mark -懒加载
-(NSMutableArray *)itemsArr{
    if (!_itemsArr) {
        _itemsArr = [NSMutableArray array];
    }
    return _itemsArr;
}
-(NSMutableArray *)arr1{
    if (!_arr1) {
        _arr1 = [NSMutableArray array];
    }
    return _arr1;
}
-(NSMutableArray *)arr2{
    if (!_arr2) {
        _arr2 = [NSMutableArray array];
    }
    return _arr2;
}
-(NSMutableArray *)arr3{
    if (!_arr3) {
        _arr3 = [NSMutableArray array];
    }
    return _arr3;
}
-(NSMutableArray *)arr4{
    if (!_arr4) {
        _arr4 = [NSMutableArray array];
    }
    return _arr4;
}


#pragma mark -更换顺序
-(void)changeDirectionWith:(HSFDirection)dir{
    self.itemsArr = nil;
    //换顺序
    if (dir == HSFDirection_cw) {//顺时针
        //先将arr3 arr4 倒序
        NSInteger line = self.size.row;
        NSInteger row = self.size.section;
        NSMutableArray *newArr3 = [NSMutableArray array];
        NSMutableArray *newArr4 = [NSMutableArray array];
        for (NSInteger i = line - 1; i >= 0 ; i--) {
            [newArr3 addObject:self.arr3[i]];
        }
        self.arr3 = newArr3.mutableCopy;
        for (NSInteger i = row - 1; i >= 0 ; i--) {
            [newArr4 addObject:self.arr4[i]];
        }
        self.arr4 = newArr4.mutableCopy;
        [self.itemsArr addObjectsFromArray:self.arr1];
        [self.itemsArr addObjectsFromArray:[self getLastSubarrFromArr2:self.arr2 withArr1:self.arr1]];
        [self.itemsArr addObjectsFromArray:[self getLastSubarrFromArr2:self.arr3 withArr1:self.arr2]];
        [self.itemsArr addObjectsFromArray:[self getLastSubarrFromArr2:self.arr4 withArr1:self.arr3]];
        [self.itemsArr removeLastObject];
    }else if (dir == HSFDirection_acw) {//逆时针
        //先将arr1 arr2 倒序
        NSInteger line = self.size.row;
        NSInteger row = self.size.section;
        NSMutableArray *newArr1 = [NSMutableArray array];
        NSMutableArray *newArr2 = [NSMutableArray array];
        for (NSInteger i = line - 1; i >= 0 ; i--) {
            [newArr1 addObject:self.arr1[i]];
        }
        self.arr1 = newArr1.mutableCopy;
        for (NSInteger i = row - 1; i >= 0 ; i--) {
            [newArr2 addObject:self.arr2[i]];
        }
        self.arr2 = newArr2.mutableCopy;
        [self.itemsArr addObjectsFromArray:self.arr1];
        [self.itemsArr addObjectsFromArray:[self getLastSubarrFromArr2:self.arr4 withArr1:self.arr1]];
        [self.itemsArr addObjectsFromArray:[self getLastSubarrFromArr2:self.arr3 withArr1:self.arr4]];
        [self.itemsArr addObjectsFromArray:[self getLastSubarrFromArr2:self.arr2 withArr1:self.arr3]];
        [self.itemsArr removeLastObject];
    }
}
-(NSArray *)getLastSubarrFromArr2:(NSArray *)arr2 withArr1:(NSArray *)arr1{
    NSPredicate * filter = [NSPredicate predicateWithFormat:@"NOT (SELF IN %@)",arr1];
    NSArray * result = [arr2 filteredArrayUsingPredicate:filter];
    return result;
}




@end
