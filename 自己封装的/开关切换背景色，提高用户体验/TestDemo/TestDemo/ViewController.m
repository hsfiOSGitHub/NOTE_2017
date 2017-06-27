//
//  ViewController.m
//  TestDemo
//
//  Created by JuZhenBaoiMac on 2017/4/28.
//  Copyright © 2017年 JuZhenBaoiMac. All rights reserved.
//

#import "ViewController.h"

#import "CustomCell.h"
#define kRGBColor(r, g, b)     [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *headTitleColor_arr;
@property (nonatomic,strong) NSMutableArray *switchState_arr;
@end

static NSString *identifierCell = @"identifierCell";
@implementation ViewController

#pragma mark -懒加载
-(NSMutableArray *)headTitleColor_arr{
    if (!_headTitleColor_arr) {
        _headTitleColor_arr = [NSMutableArray array];
        for (int i = 0; i < 10; i++) {
            //随机 HEAD TITLE
            int random1 = arc4random()%256;
            int random2 = arc4random()%256;
            int random3 = arc4random()%256;
            UIColor *randomColor = kRGBColor(random1, random2, random3);
            [_headTitleColor_arr addObject:randomColor];
        }
    }
    return _headTitleColor_arr;
}
-(NSMutableArray *)switchState_arr{
    if (!_switchState_arr) {
        _switchState_arr = [NSMutableArray array];
        for (int i = 0; i < 10; i++) {
            [_switchState_arr addObject:@"0"];
        }
    }
    return _switchState_arr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //数据源代理
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    //cell高度
    self.tableView.estimatedRowHeight = 44;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    //注册cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([CustomCell class]) bundle:nil] forCellReuseIdentifier:identifierCell];
}

#pragma mark -<UITableViewDelegate,UITableViewDataSource>
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CustomCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierCell forIndexPath:indexPath];
    if ([self.switchState_arr[indexPath.row] isEqualToString:@"0"]) {//关闭
        [cell.mySwitch setOn:NO];
        cell.headTitle.textColor = self.headTitleColor_arr[indexPath.row];
        cell.contentView.backgroundColor = [UIColor whiteColor];
    }else if ([self.switchState_arr[indexPath.row] isEqualToString:@"1"]) {//展开
        [cell.mySwitch setOn:YES];
        cell.headTitle.textColor = [UIColor whiteColor];
        cell.contentView.backgroundColor = self.headTitleColor_arr[indexPath.row];
    }
    //给mySwitch添加事件
    [cell.mySwitch setTag:(100 + indexPath.row)];
    [cell.mySwitch addTarget:self action:@selector(mySwitchACTION:) forControlEvents:UIControlEventValueChanged];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
//点击开关
-(void)mySwitchACTION:(UISwitch *)sender{
    NSInteger index = sender.tag - 100;
    //更改开关状态数据源
    if ([self.switchState_arr[index] isEqualToString:@"0"]) {
        [self.switchState_arr replaceObjectAtIndex:index withObject:@"1"];
    }else if ([self.switchState_arr[index] isEqualToString:@"1"]) {
        [self.switchState_arr replaceObjectAtIndex:index withObject:@"0"];
    }
    //获取到cell
    CustomCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
    [self addClickEffectForView:cell.contentView withClickPointInSuperView:cell.mySwitch.center withEffectColor:cell.headTitle.textColor removeWhenFinished:YES];
    //刷新
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
    
}

/*  关键  */
-(void)addClickEffectForView:(UIView *)view withClickPointInSuperView:(CGPoint)point withEffectColor:(UIColor *)color removeWhenFinished:(BOOL)isRemove {
    view.layer.masksToBounds = YES;
    //创建layer
    CALayer *clickEffectLayer = [CALayer layer];
    CGFloat radius = sqrtf((powf(view.frame.size.width, 2) + powf(view.frame.size.height, 2)));//扩散圆的半径
    
    clickEffectLayer.frame = CGRectMake(0, 0, radius * 2, radius * 2);
    clickEffectLayer.cornerRadius = radius;
    clickEffectLayer.position = point;
    clickEffectLayer.backgroundColor = color.CGColor;
    [view.layer insertSublayer:clickEffectLayer atIndex:0];//将layer放在底层

    //尺寸比例动画
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale.xy"];
    scaleAnimation.fromValue = @0.1;//开始的大小
    scaleAnimation.toValue = @1.0;//最后的大小
    scaleAnimation.duration = 0.5;//动画持续时间
    [clickEffectLayer addAnimation:scaleAnimation forKey:@"pulse"];
    //完成动画是否移除
    if (isRemove) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [clickEffectLayer removeFromSuperlayer];
        });
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
