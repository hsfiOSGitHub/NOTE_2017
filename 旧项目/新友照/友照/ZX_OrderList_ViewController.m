//
//  ZX_OrderList_ViewController.m
//  友照
//
//  Created by cleloyang on 2016/12/7.
//  Copyright © 2016年 ZX_XPH. All rights reserved.
//

#import "ZX_OrderList_ViewController.h"
#import "ZXMyOrderListCell.h"
#import "orderListCell.h"
#import "ZX_PayCoin_ViewController.h"
#import "ZXKongKaQuanView.h"
#import "ZX_YuYueMoNi_ViewController.h"
#import "ZX_QuShangKe_ViewController.h"
#import "ZXKeSanOrderDetailVC.h"
#import "zhu_ye_ViewController.h"
#import "wo_de_ViewController.h"

@interface ZX_OrderList_ViewController ()<UITableViewDelegate, UITableViewDataSource, UITextViewDelegate>
@property(nonatomic,strong)UITableView *orderListTabV;
@property(nonatomic,strong)NSMutableArray *orderListArr;
@property(nonatomic, assign) NSInteger page;
@property (nonatomic, strong) NSString *orderID;
@property (nonatomic, assign) NSInteger btnTag;
@property (nonatomic, strong) UITextView *TV;
@property (nonatomic, copy) NSString *futime;
@property (nonatomic, copy) NSString *orderTime;
@property (nonatomic, strong) NSDictionary *orderListDict;
@property (nonatomic, strong) ZXKongKaQuanView *KongKaQuanView;
@property (nonatomic) BOOL isRefresh;
@property (nonatomic, strong) UIButton *btnBg;
@property (nonatomic) BOOL isCancel;
@property (nonatomic) BOOL isfresh;
@property (nonatomic) BOOL isfresh1;

@property (nonatomic, strong) UIButton *dingDanStatusBtn;

@end

@implementation ZX_OrderList_ViewController

- (void)viewWillAppear:(BOOL)animated
{
    _isRefresh = NO;
    _page = 0;
    switch ([[ZXUD objectForKey:@"orderStatus"] integerValue])
    {
        case 0:
            _orderStatus = @"0";
            break;
        case 1:
            _orderStatus = @"1";
            break;
        case 2:
            _orderStatus = @"2";
            break;
        case 4:
            _orderStatus = @"4";
            break;
        default:
            break;
    }
    [_orderListArr removeAllObjects];
    [self getOrderListData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self creatOrderListTabV];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"fanhui"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(goToBack)];
}

- (void)goToBack
{
    if (self.tabBarController.selectedIndex == 3)
    {
        for (UIViewController* VC in self.navigationController.viewControllers)
        {
            if ([VC isKindOfClass:[wo_de_ViewController class]])
            {
                [self.navigationController popToViewController:VC animated:YES];
                return;
            }
        }
    }
    else
    {
        for (UIViewController* VC in self.navigationController.viewControllers)
        {
            if ([VC isKindOfClass:[zhu_ye_ViewController class]])
            {
                [self.navigationController popToViewController:VC animated:YES];
                return;
            }
        }
    }
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    //滑动效果
    NSTimeInterval animationDuration = 0.3f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    //上移屏幕
    self.view.frame = CGRectMake(0.0f, -250.0f, self.view.frame.size.width, self.view.frame.size.height);
    
    [UIView commitAnimations];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    //滑动效果
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    //恢复屏幕
    self.view.frame = CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height);
    
    [UIView commitAnimations];
}

//懒加载空卡券视图
-(ZXKongKaQuanView *)KongKaQuanView
{
    if (!_KongKaQuanView)
    {
        _KongKaQuanView = [[ZXKongKaQuanView alloc]initWithFrame:self.view.bounds];
        switch ([[ZXUD objectForKey:@"orderStatus"] integerValue])
        {
            case 0:
                _KongKaQuanView.label.text = @"您还没有订单哦";
                break;
            case 1:
                _KongKaQuanView.label.text = @"您还没有待付款的订单哦";
                break;
            case 2:
                _KongKaQuanView.label.text = @"您还没有未使用的订单哦";
                break;
            case 4:
                _KongKaQuanView.label.text = @"您还没有已退款的订单哦";
                break;
            default:
                break;
        }

        
    }
    return _KongKaQuanView;
}

- (void)creatOrderListTabV
{
    if (!_orderListTabV)
    {
        _orderListTabV = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight) style:UITableViewStylePlain];
        [self.view addSubview:_orderListTabV];
        _orderListTabV.dataSource = self;
        _orderListTabV.delegate = self;
        _orderListTabV.showsVerticalScrollIndicator = NO;
        //注册cell
        [_orderListTabV registerNib:[UINib nibWithNibName:@"ZXMyOrderListCell" bundle:Nil] forCellReuseIdentifier:@"cellID"];
        [_orderListTabV registerNib:[UINib nibWithNibName:@"orderListCell" bundle:Nil] forCellReuseIdentifier:@"orderListCell"];
        //分隔线 
        _orderListTabV.separatorStyle = UITableViewCellSelectionStyleNone;
        //添加下拉刷新视图
        _orderListTabV.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^
                          {
                              if (!_isfresh)
                              {
                                  _page = 0;
                                  _isRefresh = YES;
                                  _isfresh = YES;
                                  [self getOrderListData];
                              }
                              else
                              {
                                  [_orderListTabV.mj_header endRefreshing];
                                 
                              }
                            
                          }];
        //上拉加载
        _orderListTabV.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^
                          {
                              if (!_isfresh1)
                              {
                                  _page ++;
                                  _isRefresh = YES;
                                  _isfresh1 = YES;
                                  [self getOrderListData];
                              }
                              else
                              {
                                  [_orderListTabV.mj_footer endRefreshing];
                              }
                          }];
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_orderListArr.count == 0 && _orderListArr)
    {
        [self KongKaQuanView];
        [self.view insertSubview:_KongKaQuanView belowSubview:_animationView];
    }
    else
    {
        [_KongKaQuanView removeFromSuperview];
    }
    return _orderListArr.count;
}

//行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (KScreenWidth - 30) * 3 / 5 + 8;
}

//tabViewcell的内容
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_orderListArr[indexPath.row][@"goods_type"] isEqualToString:@"101"] || [_orderListArr[indexPath.row][@"goods_type"] isEqualToString:@"102"] || [_orderListArr[indexPath.row][@"goods_type"] isEqualToString:@"103"])
    {
        orderListCell *Cell = [tableView dequeueReusableCellWithIdentifier:@"orderListCell" forIndexPath:indexPath];
        Cell.selectionStyle = NO;
        //订单名称
        Cell.dingDanNameLab.text = _orderListArr[indexPath.row][@"goods_name"];
        //驾校名称
        Cell.schoolNameLab.text = _orderListArr[indexPath.row][@"school_name"];
        //科目
        if ([_orderListArr[indexPath.row][@"goods_type"] isEqualToString:@"101"])
        {
            Cell.keMuLab.text = @"科目一";
        }
        else if ([_orderListArr[indexPath.row][@"goods_type"] isEqualToString:@"102"])
        {
            Cell.keMuLab.text = @"科目二";
        }
        else if ([_orderListArr[indexPath.row][@"goods_type"] isEqualToString:@"103"])
        {
            Cell.keMuLab.text = @"科目三";
        }
        //订单价格
        Cell.priceLab.text = [NSString stringWithFormat:@"合计: %@",_orderListArr[indexPath.row][@"pay_money"]];
        //日期
        NSString *order_time = _orderListArr[indexPath.row][@"order_time"];
        NSString *pay_time = _orderListArr[indexPath.row][@"pay_time"];
        //给多种状态按钮添加事件
        [Cell.payCoinBtn addTarget:self action:@selector(payCoin:) forControlEvents:UIControlEventTouchDown];
        [Cell.payCancelBtn addTarget:self action:@selector(payCancel:) forControlEvents:UIControlEventTouchDown];
        Cell.payCoinBtn.tag = indexPath.row+1000;
        Cell.payCancelBtn.tag = indexPath.row+2000;
        
        _dingDanStatusBtn = Cell.dingDanStatusBtn;
        Cell.dingDanStatusBtn.userInteractionEnabled = NO;
        
        //goods_status: 0.未付款已过期 1.未付款 ..已使用
        if ([_orderListArr[indexPath.row][@"goods_status"] isEqualToString:@"0"])
        {
            Cell.payCancelBtn.hidden = YES;
            Cell.payCoinBtn.userInteractionEnabled = YES;
            
            [Cell.dingDanStatusBtn setTitle:@"已过期" forState:UIControlStateNormal];
            [Cell.dingDanStatusBtn setTitleColor:ZX_DarkGray_Color forState:UIControlStateNormal];
            
            Cell.gouMaiDateLab.text = [NSString stringWithFormat:@"日期:%@", [order_time substringWithRange:NSMakeRange(0,16)] ];
        }
        else if ([_orderListArr[indexPath.row][@"goods_status"] isEqualToString:@"1"])
        {
            Cell.payCoinBtn.hidden = NO;
            Cell.payCancelBtn.hidden = NO;
            Cell.payCoinBtn.userInteractionEnabled = YES;
            Cell.payCancelBtn.userInteractionEnabled = YES;
            
            [Cell.dingDanStatusBtn setTitle:@"待付款" forState:UIControlStateNormal];
            [Cell.dingDanStatusBtn setTitleColor:[UIColor colorWithRed:255/255.0 green:155/255.0 blue:85/255.0 alpha:1] forState:UIControlStateNormal];
            
            [Cell.payCoinBtn.layer setMasksToBounds:YES];
            [Cell.payCoinBtn.layer setCornerRadius:4];
            [Cell.payCoinBtn.layer setBorderWidth:1];
            [Cell.payCoinBtn.layer setBorderColor:[[UIColor colorWithRed:255/255.0 green:155/255.0 blue:85/255.0 alpha:1] CGColor]];
            [Cell.payCoinBtn setTitle:@"付款" forState:UIControlStateNormal];
            [Cell.payCoinBtn setTitleColor:[UIColor colorWithRed:255/255.0 green:155/255.0 blue:85/255.0 alpha:1] forState:UIControlStateNormal];
            
            [Cell.payCancelBtn.layer setMasksToBounds:YES];
            [Cell.payCancelBtn.layer setCornerRadius:4];
            [Cell.payCancelBtn.layer setBorderWidth:1];
            [Cell.payCancelBtn.layer setBorderColor:[ZX_DarkGray_Color CGColor]];
            [Cell.payCancelBtn setTitle:@"取消订单" forState:UIControlStateNormal];
            [Cell.payCancelBtn setTitleColor:ZX_DarkGray_Color forState:UIControlStateNormal];
            
            Cell.gouMaiDateLab.text = [NSString stringWithFormat:@"日期:%@", [order_time substringWithRange:NSMakeRange(0,16)] ];
        }
        else
        {
            Cell.payCancelBtn.hidden = YES;
            Cell.payCoinBtn.userInteractionEnabled = YES;
            
            [Cell.dingDanStatusBtn setTitle:@"已使用" forState:UIControlStateNormal];
            [Cell.dingDanStatusBtn setTitleColor:dao_hang_lan_Color forState:UIControlStateNormal];
            
            Cell.gouMaiDateLab.text = [NSString stringWithFormat:@"日期:%@", [pay_time substringWithRange:NSMakeRange(0,16)] ];
        }
        
        //delete_status 1.可删除 0.不可删除
        if ([_orderListArr[indexPath.row][@"delete_status"] isEqualToString:@"1"])
        {
            Cell.payCoinBtn.hidden = NO;
            [Cell.payCoinBtn.layer setMasksToBounds:YES];
            [Cell.payCoinBtn.layer setCornerRadius:4];
            [Cell.payCoinBtn.layer setBorderWidth:1];
            [Cell.payCoinBtn.layer setBorderColor:[[UIColor colorWithRed:240/255.0 green:70/255.0 blue:95/255.0 alpha:1] CGColor]];
            [Cell.payCoinBtn setTitle:@"删除订单" forState:UIControlStateNormal];
            [Cell.payCoinBtn setTitleColor:[UIColor colorWithRed:240/255.0 green:70/255.0 blue:95/255.0 alpha:1] forState:UIControlStateNormal];
        }
        return Cell;
    }
    else
    {
        ZXMyOrderListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID" forIndexPath:indexPath];
        cell.selectionStyle = NO;
        
        //订单名称
        cell.dingDanNameLab.text = _orderListArr[indexPath.row][@"goods_name"];
        //订单图片
        if ([_orderListArr[indexPath.row][@"goods_type"] isEqualToString:@"1"])
        {
            [cell.dingDanPic sd_setImageWithURL:[NSURL URLWithString:_orderListArr[indexPath.row][@"goods_pic"]] placeholderImage:[UIImage imageNamed:@"科二模拟卡"]];
        }
        else if ([_orderListArr[indexPath.row][@"goods_type"] isEqualToString:@"2"])
        {
            [cell.dingDanPic sd_setImageWithURL:[NSURL URLWithString:_orderListArr[indexPath.row][@"goods_pic"]] placeholderImage:[UIImage imageNamed:@"科三模拟卡"]];
        }
        else if ([_orderListArr[indexPath.row][@"goods_type"] isEqualToString:@"12"])
        {
            [cell.dingDanPic sd_setImageWithURL:[NSURL URLWithString:_orderListArr[indexPath.row][@"goods_pic"]] placeholderImage:[UIImage imageNamed:@"科二学时卡"]];
        }
        else if ([_orderListArr[indexPath.row][@"goods_type"] isEqualToString:@"13"])
        {
            [cell.dingDanPic sd_setImageWithURL:[NSURL URLWithString:_orderListArr[indexPath.row][@"goods_pic"]] placeholderImage:[UIImage imageNamed:@"科三学时卡"]];
        }
        
        //驾校名称
        cell.jiaXiaoNameLab.text = _orderListArr[indexPath.row][@"school_name"];
        //科目
        if ([_orderListArr[indexPath.row][@"goods_type"] isEqualToString:@"1"] || [_orderListArr[indexPath.row][@"goods_type"] isEqualToString:@"12"])
        {
            cell.keMuLab.text = @"科目二";
            //教练名字
            if ([_orderListArr[indexPath.row][@"goods_type"] isEqualToString:@"12"])
            {
                cell.jiaoLianNameLab.text = _orderListArr[indexPath.row][@"teacher_name"];
            }
            else
            {
                cell.jiaoLianNameLab.text = @"";
            }
        }
        else
        {
            cell.keMuLab.text = @"科目三";
            
            //教练名字
            if ([_orderListArr[indexPath.row][@"goods_type"] isEqualToString:@"13"])
            {
                cell.jiaoLianNameLab.text = _orderListArr[indexPath.row][@"teacher_name"];
            }
            else
            {
                cell.jiaoLianNameLab.text = @"";
            }
        }
        //购买数量
        cell.dingDanNumLab.text = [NSString stringWithFormat:@"购买数量: %@",_orderListArr[indexPath.row][@"goods_number"]];
        
        //订单价格
        cell.dingDanPriceLab.text = [NSString stringWithFormat:@"合计: %@",_orderListArr[indexPath.row][@"pay_money"]];
        
        //日期
        NSString *order_time = _orderListArr[indexPath.row][@"order_time"];
        NSString *pay_time = _orderListArr[indexPath.row][@"pay_time"];
        
        //给多种状态按钮添加事件
        [cell.payCoinBtn addTarget:self action:@selector(payCoin:) forControlEvents:UIControlEventTouchDown];
        [cell.cancelBtn addTarget:self action:@selector(payCancel:) forControlEvents:UIControlEventTouchDown];
        cell.payCoinBtn.tag = indexPath.row+1000;
        cell.cancelBtn.tag = indexPath.row+2000;
        
        _dingDanStatusBtn = cell.dingDanStatusBtn;
        cell.dingDanStatusBtn.userInteractionEnabled = NO;
        
        //goods_status: 0.未付款已过期 1.未付款 2.已付款未使用 3.已使用 4.退款 5.科三模拟卡已付款已过期(不能退款)  默认为0(申请退款后为0)
        switch ([_orderListArr[indexPath.row][@"goods_status"] integerValue])
        {
            case 0:
                cell.tuiKuanBtn.hidden = YES;
                cell.cancelBtn.hidden = YES;
                cell.payCoinBtn.userInteractionEnabled = YES;
                
                [cell.dingDanStatusBtn setTitle:@"已过期" forState:UIControlStateNormal];
                [cell.dingDanStatusBtn setTitleColor:ZX_DarkGray_Color forState:UIControlStateNormal];
                
                cell.dingDanTimeLab.text = [NSString stringWithFormat:@"日期:%@", [order_time substringWithRange:NSMakeRange(0,16)] ];
                break;
                
            case 1:
                cell.payCoinBtn.hidden = NO;
                cell.cancelBtn.hidden = NO;
                cell.tuiKuanBtn.hidden = YES;
                cell.payCoinBtn.userInteractionEnabled = YES;
                cell.cancelBtn.userInteractionEnabled = YES;
                
                [cell.dingDanStatusBtn setTitle:@"待付款" forState:UIControlStateNormal];
                [cell.dingDanStatusBtn setTitleColor:[UIColor colorWithRed:255/255.0 green:155/255.0 blue:85/255.0 alpha:1] forState:UIControlStateNormal];
                
                [cell.payCoinBtn.layer setMasksToBounds:YES];
                [cell.payCoinBtn.layer setCornerRadius:4];
                [cell.payCoinBtn.layer setBorderWidth:1];
                [cell.payCoinBtn.layer setBorderColor:[[UIColor colorWithRed:255/255.0 green:155/255.0 blue:85/255.0 alpha:1] CGColor]];
                [cell.payCoinBtn setTitle:@"付款" forState:UIControlStateNormal];
                [cell.payCoinBtn setTitleColor:[UIColor colorWithRed:255/255.0 green:155/255.0 blue:85/255.0 alpha:1] forState:UIControlStateNormal];
                
                [cell.cancelBtn.layer setMasksToBounds:YES];
                [cell.cancelBtn.layer setCornerRadius:4];
                [cell.cancelBtn.layer setBorderWidth:1];
                [cell.cancelBtn.layer setBorderColor:[ZX_DarkGray_Color CGColor]];
                [cell.cancelBtn setTitle:@"取消订单" forState:UIControlStateNormal];
                [cell.cancelBtn setTitleColor:ZX_DarkGray_Color forState:UIControlStateNormal];
                
                cell.dingDanTimeLab.text = [NSString stringWithFormat:@"日期:%@", [order_time substringWithRange:NSMakeRange(0,16)] ];
                break;
                
            case 2:
                cell.payCoinBtn.hidden = NO;
                cell.cancelBtn.hidden = NO;
                cell.tuiKuanBtn.hidden = YES;
                cell.payCoinBtn.userInteractionEnabled = YES;
                cell.cancelBtn.userInteractionEnabled = YES;
                
                [cell.dingDanStatusBtn setTitle:@"待使用" forState:UIControlStateNormal];
                [cell.dingDanStatusBtn setTitleColor:[UIColor colorWithRed:105/255.0 green:155/255.0 blue:140/255.0 alpha:1] forState:UIControlStateNormal];
                
                [cell.payCoinBtn.layer setMasksToBounds:YES];
                [cell.payCoinBtn.layer setCornerRadius:4];
                [cell.payCoinBtn.layer setBorderWidth:1];
                [cell.payCoinBtn.layer setBorderColor:[[UIColor colorWithRed:105/255.0 green:155/255.0 blue:140/255.0 alpha:1] CGColor]];
                [cell.payCoinBtn setTitleColor:[UIColor colorWithRed:105/255.0 green:155/255.0 blue:140/255.0 alpha:1] forState:UIControlStateNormal];
                
                if ([_orderListArr[indexPath.row][@"goods_type"] isEqualToString:@"1"] || [_orderListArr[indexPath.row][@"goods_type"] isEqualToString:@"2"])
                {
                    [cell.payCoinBtn setTitle:@"使用" forState:UIControlStateNormal];
                }
                else
                {
                    [cell.payCoinBtn setTitle:@"添加课时" forState:UIControlStateNormal];
                }
                
                [cell.cancelBtn.layer setMasksToBounds:YES];
                [cell.cancelBtn.layer setCornerRadius:4];
                [cell.cancelBtn.layer setBorderWidth:1];
                [cell.cancelBtn.layer setBorderColor:[ZX_DarkGray_Color CGColor]];
                [cell.cancelBtn setTitle:@"申请退款" forState:UIControlStateNormal];
                [cell.cancelBtn setTitleColor:ZX_DarkGray_Color forState:UIControlStateNormal];
                
                cell.dingDanTimeLab.text = [NSString stringWithFormat:@"日期:%@", [pay_time substringWithRange:NSMakeRange(0,16)] ];
                break;
                
            case 3:
                cell.tuiKuanBtn.hidden = YES;
                cell.cancelBtn.hidden = YES;
                cell.payCoinBtn.userInteractionEnabled = YES;
                
                [cell.dingDanStatusBtn setTitle:@"已使用" forState:UIControlStateNormal];
                [cell.dingDanStatusBtn setTitleColor:dao_hang_lan_Color forState:UIControlStateNormal];
                
                cell.dingDanTimeLab.text = [NSString stringWithFormat:@"日期:%@", [pay_time substringWithRange:NSMakeRange(0,16)] ];
                break;
                
            case 5:
                cell.tuiKuanBtn.hidden = YES;
                cell.cancelBtn.hidden = YES;
                cell.payCoinBtn.userInteractionEnabled = YES;
                
                [cell.dingDanStatusBtn setTitle:@"已过期" forState:UIControlStateNormal];
                [cell.dingDanStatusBtn setTitleColor:ZX_DarkGray_Color forState:UIControlStateNormal];
                
                cell.dingDanTimeLab.text = [NSString stringWithFormat:@"日期:%@", [pay_time substringWithRange:NSMakeRange(0,16)] ];
                break;
                
            default:
                break;
        }
        
        //delete_status 1.可删除 0.不可删除
        if ([_orderListArr[indexPath.row][@"delete_status"] isEqualToString:@"1"])
        {
            cell.payCoinBtn.hidden = NO;
            [cell.payCoinBtn.layer setMasksToBounds:YES];
            [cell.payCoinBtn.layer setCornerRadius:4];
            [cell.payCoinBtn.layer setBorderWidth:1];
            [cell.payCoinBtn.layer setBorderColor:[[UIColor colorWithRed:240/255.0 green:70/255.0 blue:95/255.0 alpha:1] CGColor]];
            [cell.payCoinBtn setTitle:@"删除订单" forState:UIControlStateNormal];
            [cell.payCoinBtn setTitleColor:[UIColor colorWithRed:240/255.0 green:70/255.0 blue:95/255.0 alpha:1] forState:UIControlStateNormal];
        }
        
        //back_status 0.审核中 1.审核通过 2.审核被拒 3.退款成功  默认为空
        if (![_orderListArr[indexPath.row][@"goods_status"] isEqualToString:@"3"])
        {
            if (![_orderListArr[indexPath.row][@"back_status"] isEqualToString:@""])
            {
                [cell.dingDanStatusBtn setTitle:@"退款" forState:UIControlStateNormal];
                [cell.dingDanStatusBtn setTitleColor:dao_hang_lan_Color forState:UIControlStateNormal];
                
                cell.dingDanTimeLab.text = [NSString stringWithFormat:@"日期:%@", [pay_time substringWithRange:NSMakeRange(0,16)]];
                
                cell.payCoinBtn.userInteractionEnabled = NO;
                [cell.payCoinBtn.layer setMasksToBounds:YES];
                [cell.payCoinBtn.layer setCornerRadius:4];
                [cell.payCoinBtn.layer setBorderWidth:1];
                
                [cell.payCoinBtn.layer setBorderColor:[[UIColor colorWithRed:240/255.0 green:70/255.0 blue:95/255.0 alpha:1] CGColor]];
                [cell.payCoinBtn setTitleColor:[UIColor colorWithRed:240/255.0 green:70/255.0 blue:95/255.0 alpha:1] forState:UIControlStateNormal];
                
                switch ([_orderListArr[indexPath.row][@"back_status"] integerValue])
                {
                    case 0:
                        cell.tuiKuanBtn.hidden = YES;
                        cell.cancelBtn.hidden = YES;
                        cell.payCoinBtn.hidden = NO;
                        
                        
                        [cell.payCoinBtn.layer setBorderWidth:0];
                        [cell.payCoinBtn.layer setBorderColor:[dao_hang_lan_Color CGColor]];
                        [cell.payCoinBtn setTitleColor:dao_hang_lan_Color forState:UIControlStateNormal];
                        [cell.payCoinBtn setTitle:@"审核中" forState:UIControlStateNormal];
                        break;
                        
                    case 1:
                        cell.tuiKuanBtn.hidden = YES;
                        cell.cancelBtn.hidden = YES;
                        cell.payCoinBtn.hidden = NO;
                        
                        [cell.payCoinBtn.layer setBorderWidth:0];
                        [cell.payCoinBtn.layer setBorderColor:[dao_hang_lan_Color CGColor]];
                        [cell.payCoinBtn setTitleColor:dao_hang_lan_Color forState:UIControlStateNormal];
                        [cell.payCoinBtn setTitle:@"审核通过" forState:UIControlStateNormal];
                        break;
                        
                    case 2:
                        cell.tuiKuanBtn.hidden = YES;
                        cell.cancelBtn.hidden = NO;
                        cell.payCoinBtn.hidden = NO;
                        cell.payCoinBtn.userInteractionEnabled = YES;
                        cell.cancelBtn.userInteractionEnabled = YES;
                        
                        [cell.dingDanStatusBtn setTitle:@"待使用" forState:UIControlStateNormal];
                        [cell.dingDanStatusBtn setTitleColor:[UIColor colorWithRed:105/255.0 green:155/255.0 blue:140/255.0 alpha:1] forState:UIControlStateNormal];
                        
                        [cell.payCoinBtn.layer setMasksToBounds:YES];
                        [cell.payCoinBtn.layer setCornerRadius:4];
                        [cell.payCoinBtn.layer setBorderWidth:1];
                        [cell.payCoinBtn.layer setBorderColor:[[UIColor colorWithRed:105/255.0 green:155/255.0 blue:140/255.0 alpha:1] CGColor]];
                        [cell.payCoinBtn setTitleColor:[UIColor colorWithRed:105/255.0 green:155/255.0 blue:140/255.0 alpha:1] forState:UIControlStateNormal];
                        if ([_orderListArr[indexPath.row][@"goods_type"] isEqualToString:@"1"] || [_orderListArr[indexPath.row][@"goods_type"] isEqualToString:@"2"])
                        {
                            [cell.payCoinBtn setTitle:@"使用" forState:UIControlStateNormal];
                        }
                        else
                        {
                            [cell.payCoinBtn setTitle:@"添加课时" forState:UIControlStateNormal];
                        }
                        
                        [cell.cancelBtn.layer setBorderWidth:0];
                        [cell.cancelBtn setTitle:@"审核被拒" forState:UIControlStateNormal];
                        [cell.cancelBtn setTitleColor:dao_hang_lan_Color forState:UIControlStateNormal];
                        break;
                        
                    case 3:
                        cell.tuiKuanBtn.hidden = YES;
                        cell.cancelBtn.hidden = NO;
                        cell.payCoinBtn.userInteractionEnabled = YES;
                        
                        [cell.cancelBtn.layer setBorderWidth:0];
                        [cell.cancelBtn setTitle:@"退款成功" forState:UIControlStateNormal];
                        [cell.cancelBtn setTitleColor:dao_hang_lan_Color forState:UIControlStateNormal];
                        break;
                        
                    default:
                        break;          
                }
            }
        }
        return cell;
    }
}

//取消按钮事件
- (void)payCancel:(UIButton*)btn
{
    _btnTag = btn.tag-2000;
    _orderID = _orderListArr[_btnTag][@"order_id"];
    if ([btn.currentTitle isEqualToString:@"取消订单"])
    {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"确定要取消此订单吗" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
                                      {
                                          [self deleteOrderData:_orderID];
                                      }];
        
        UIAlertAction *anotherAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action)
                                        {
                                        }];
        [alert addAction:alertAction];
        [alert addAction:anotherAction];
        [self presentViewController:alert animated:YES completion:^{
        }];
    }
    else if ([btn.currentTitle isEqualToString:@"申请退款"])
    {
        if ([_orderListArr[_btnTag][@"back_status"] isEqualToString:@"2"])
        {
            [MBProgressHUD showSuccess:@"审核已被拒绝，无法再次申请"];
        }
        else
        {
            _btnBg = [[UIButton alloc]initWithFrame:self.view.frame];
            [_btnBg setBackgroundColor:[UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:0.5]];
            [_btnBg addTarget:self action:@selector(removeBtnBg) forControlEvents:UIControlEventTouchDown];
            [self.view addSubview:_btnBg];
            
            UIView *reasonView = [[UIView alloc]initWithFrame:CGRectMake(0, KScreenHeight*2/3, KScreenWidth, KScreenHeight/3)];
            reasonView.backgroundColor = [UIColor whiteColor];
            [_btnBg addSubview:reasonView];
            
            UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, KScreenWidth, 30)];
            lab.text = @"退款原因";
            lab.textColor = ZX_DarkGray_Color;
            lab.font = [UIFont systemFontOfSize:15];
            [reasonView addSubview:lab];
            
            UILabel *lab1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 30, KScreenWidth, 1)];
            lab1.backgroundColor = ZX_BG_COLOR;
            [reasonView addSubview:lab1];
            
            _TV = [[UITextView alloc]initWithFrame:CGRectMake(15, 36, KScreenWidth-30, KScreenHeight/3-91)];
            _TV.layer.borderWidth = 1;
            _TV.layer.borderColor = [ZX_BG_COLOR CGColor];
            [reasonView addSubview:_TV];
            _TV.delegate = self;
            
            UIButton *submitBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, KScreenHeight/3-50, KScreenWidth, 50)];
            submitBtn.backgroundColor = dao_hang_lan_Color;
            [submitBtn setTitle:@"提交" forState:UIControlStateNormal];
            [reasonView addSubview:submitBtn];
            [submitBtn addTarget:self action:@selector(submitTuiKuan) forControlEvents:UIControlEventTouchDown];
        }
    }
}

//付款按钮事件
- (void)payCoin:(UIButton*)btn
{
    _btnTag = btn.tag-1000;
    _orderID = _orderListArr[_btnTag][@"order_id"];
    if ([btn.currentTitle isEqualToString:@"付款"])
    {
        [self getFuWuQiTime];
    }
    else if ([btn.currentTitle isEqualToString:@"使用"])
    {
        //使用模拟卡
        if ([_orderListArr[_btnTag][@"goods_type"] isEqualToString:@"1"])
        {
            ZX_YuYueMoNi_ViewController *yuYueMoNiVC = [[ZX_YuYueMoNi_ViewController alloc] init];
            [self.navigationController pushViewController:yuYueMoNiVC animated:YES];
        }
        else
        {
            ZXKeSanOrderDetailVC *keSanDetailVC = [[ZXKeSanOrderDetailVC alloc]init];
            keSanDetailVC.orderId = _orderID;
            [self.navigationController pushViewController:keSanDetailVC animated:YES];
        }
    }
    else if ([btn.currentTitle isEqualToString:@"添加课时"])
    {
        NSString *str = [NSString stringWithFormat:@"确定添加 %@ 课时到 我的课时 吗？",_orderListArr[_btnTag][@"goods_number"]];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"添加课时" message:str preferredStyle:UIAlertControllerStyleAlert];
        NSMutableAttributedString *messageStr = [[NSMutableAttributedString alloc] initWithString:str];
        [messageStr addAttribute:NSForegroundColorAttributeName value:ZX_LightGray_Color range:NSMakeRange(0, str.length)];
        [messageStr addAttribute:NSForegroundColorAttributeName value:dao_hang_lan_Color range:NSMakeRange(str.length-7, 4)];
        [messageStr addAttribute:NSForegroundColorAttributeName value:dao_hang_lan_Color range:NSMakeRange(5, [_orderListArr[_btnTag][@"goods_number"] length])];
        [messageStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0, str.length)];
        [alert setValue:messageStr forKey:@"attributedMessage"];
        
        NSMutableAttributedString *titleStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"添加课时"]];
        [titleStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17] range:NSMakeRange(0, 4)];
        [titleStr addAttribute:NSForegroundColorAttributeName value:ZX_DarkGray_Color range:NSMakeRange(0, 4)];
        [alert setValue:titleStr forKey:@"attributedTitle"];
        
        UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
                                  {
                                      //添加课时
                                      [self addKeShiData];
                                  }];
        [confirm setValue:dao_hang_lan_Color forKey:@"titleTextColor"];
        
        UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action)
                                 {
                                 }];
        [cancle setValue:ZX_LightGray_Color forKey:@"titleTextColor"];
        [alert addAction:confirm];
        [alert addAction:cancle];
        [self presentViewController:alert animated:YES completion:nil];
    }
    else if ([btn.currentTitle isEqualToString:@"删除订单"])
    {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"确定删除此订单吗" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
                                      {
                                          //删除订单
                                          [self deleteOrderData:_orderID];
                                          _isCancel = YES;
                                      }];
        
        UIAlertAction *anotherAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action)
                                        {
                                        }];
        [alert addAction:alertAction];
        [alert addAction:anotherAction];
        [self presentViewController:alert animated:YES completion:^{
        }];
    }
}

-(void)removeBtnBg
{
    [_TV resignFirstResponder];
    [_btnBg removeFromSuperview];
}

//提交退款
-(void)submitTuiKuan
{
    if ([_TV.text isEqualToString:@""])
    {
        [MBProgressHUD showSuccess:@"您还没有填写退款理由哦"];
    }
    else
    {
        [self getTuiKuanData];
    }
}

//获取订单列表数据
- (void)getOrderListData
{
    if (!_isRefresh && !_orderListArr)
    {
        //小车动画
        _animationView=[[ZXAnimationView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
        [self.view addSubview:_animationView];
    }
    
    if (_isfresh && _isfresh1)
    {
        return;
    }
    
    [[ZXNetDataManager manager5] orderListDataWithRndstring:[ZXDriveGOHelper getCurrentTimeStamp] andIdent_code:[ZXUD objectForKey:@"ident_code"] andOrder_status:_orderStatus andPage:[NSString stringWithFormat:@"%ld",(long)_page] success:^(NSURLSessionDataTask *task, id responseObject)
    {
        NSError *err;
        NSString *receiveStr = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSString *jsonString = [receiveStr stringByReplacingOccurrencesOfString:@"\r" withString:@""];
        jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\t" withString:@""];
        jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\v" withString:@""];
        jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\f" withString:@""];
        jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\b" withString:@""];
        jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\a" withString:@""];
        jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\e" withString:@""];
        NSData * data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&err];
        
        if(err)
        {
            NSLog(@"json解析失败：%@",err);
        }
        
        //先判断是否成功接收到数据,如果成功分类型展示
        if([[ZXwangLuoDanLi WangLuoDanLi] resIsTrue:jsonDict andAlertView:self])
        {
            if ([jsonDict[@"orderList"] isKindOfClass:[NSArray class]])
            {
                if (_isfresh)
                {
                    [_orderListArr removeAllObjects];
                }

                if (!_orderListArr)
                {
                    _orderListArr = [NSMutableArray arrayWithArray:jsonDict[@"orderList"]];
                }
                else
                {
                    [_orderListArr addObjectsFromArray:jsonDict[@"orderList"]];
                }
            }
        }
        [_orderListTabV reloadData];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [_animationView removeFromSuperview];
            _isfresh1 = NO;
            _isfresh = NO;
        });
        _isRefresh = NO;
        [_orderListTabV.mj_header endRefreshing];
        [_orderListTabV.mj_footer endRefreshing];
        
    } failed:^(NSURLSessionTask *task, NSError *error)
    {
        [_animationView removeFromSuperview];
        [_orderListTabV.mj_header endRefreshing];
        [_orderListTabV.mj_footer endRefreshing];
    }];
}

//获取服务器时间和订单时间
- (void)getFuWuQiTime
{
    [[ZXNetDataManager manager] payCoinFromOrderListWithRndString:[ZXDriveGOHelper getCurrentTimeStamp] andIdent_code:[ZXUD objectForKey:@"ident_code"] andOrder_id:_orderID success:^(NSURLSessionDataTask *task, id responseObject)
    {
        NSError *err;
        NSString *receiveStr = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSString *jsonString = [receiveStr stringByReplacingOccurrencesOfString:@"\r" withString:@""];
        jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\t" withString:@""];
        jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\v" withString:@""];
        jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\f" withString:@""];
        jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\b" withString:@""];
        jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\a" withString:@""];
        jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\e" withString:@""];
        NSData * data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&err];
        
        if(err)
        {
            NSLog(@"json解析失败：%@",err);
        }
        
        NSDictionary *dic = [NSDictionary dictionary];
        dic = jsonDict[@"resdata"];
        //判断数组是否为空
        if ([dic isKindOfClass:[NSDictionary class]] )
        {
            _futime = jsonDict[@"resdata"][@"futime"];
            
            _orderTime = jsonDict[@"resdata"][@"order_time"];
            
            NSInteger one = [[NSString stringWithFormat:@"%@",jsonDict[@"resdata"][@"futime"]] integerValue];
            NSInteger two = [[NSString stringWithFormat:@"%@",jsonDict[@"resdata"][@"order_time"]] integerValue];
            NSInteger timeBetween = one-two;
            
            //去付款界面
            ZX_PayCoin_ViewController *payCoinVC = [[ZX_PayCoin_ViewController alloc]init];
            payCoinVC.payPrice = _orderListArr[_btnTag][@"pay_money"];
            payCoinVC.froms = _orderListArr[_btnTag][@"goods_type"];
            payCoinVC.timebetween = 600.0 - timeBetween;
            payCoinVC.orderId =_orderListArr[_btnTag][@"order_id"];
            payCoinVC.fukuan = YES;
            payCoinVC.fromOrderList = YES;
            [self.navigationController pushViewController:payCoinVC animated:YES];
            [payCoinVC.myTimer setFireDate:[NSDate distantFuture]];
        }
    }failed:^(NSURLSessionTask *task, NSError *error)
     {
     }];
}

//删除订单
- (void)deleteOrderData:(id)orderID
{
    [[ZXNetDataManager manager] deleteOrderDataWithRndstring:[ZXDriveGOHelper getCurrentTimeStamp] andIdent_code:[ZXUD objectForKey:@"ident_code"] andOrder_id:_orderID andOp:@"del" success:^(NSURLSessionDataTask *task, id responseObject)
     {
         NSError *err;
         NSString *receiveStr = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
         NSString *jsonString = [receiveStr stringByReplacingOccurrencesOfString:@"\r" withString:@""];
         jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
         jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\t" withString:@""];
         jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\v" withString:@""];
         jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\f" withString:@""];
         jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\b" withString:@""];
         jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\a" withString:@""];
         jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\e" withString:@""];
         NSData * data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
         NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&err];
         
         if(err)
         {
             NSLog(@"json解析失败：%@",err);
         }
         
         if([[ZXwangLuoDanLi WangLuoDanLi] resIsTrue:jsonDict andAlertView:self])
         {
             for (int i = 0; i < _orderListArr.count; i ++)
             {
                 if ([_orderID isEqualToString: _orderListArr[i][@"order_id"]])
                 {
                     [_orderListArr removeObjectAtIndex:i];
                     [_orderListTabV reloadData];
                     break;
                 }
             }
             if (_isCancel)
             {
                 [MBProgressHUD showSuccess:jsonDict[@"msg"]];
             }
             else
             {
                 [MBProgressHUD showSuccess:@"订单取消成功"];
             }
         }
     }failed:^(NSURLSessionTask *task, NSError *error)
     {
         [MBProgressHUD showSuccess:@"网络不好，请稍后重试。"];
     }];
}

//订单退款
- (void)getTuiKuanData
{
    [[ZXNetDataManager manager] tuiKuanDataWithRndstring:[ZXDriveGOHelper getCurrentTimeStamp] andIdent_code:[ZXUD objectForKey:@"ident_code"] andOrder_id:_orderID andReason:_TV.text success:^(NSURLSessionDataTask *task, id responseObject)
     {
         NSError *err;
         NSString *receiveStr = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
         NSString *jsonString = [receiveStr stringByReplacingOccurrencesOfString:@"\r" withString:@""];
         jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
         jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\t" withString:@""];
         jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\v" withString:@""];
         jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\f" withString:@""];
         jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\b" withString:@""];
         jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\a" withString:@""];
         jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\e" withString:@""];
         NSData * data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
         NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&err];
         
         if(err)
         {
             NSLog(@"json解析失败：%@",err);
         }
         
         if([[ZXwangLuoDanLi WangLuoDanLi] resIsTrue:jsonDict andAlertView:self])
         {
         }
         [MBProgressHUD showSuccess:jsonDict[@"msg"] toView:self.view];
         [_btnBg removeFromSuperview];
     }failed:^(NSURLSessionTask *task, NSError *error)
     {
     }];
}

//添加课时
- (void)addKeShiData
{
    [[ZXNetDataManager manager] addKeShiDataWithRndstring:[ZXDriveGOHelper getCurrentTimeStamp] andIdent_code:[ZXUD objectForKey:@"ident_code"] andOrder_id:_orderID success:^(NSURLSessionDataTask *task, id responseObject)
     {
         NSError *err;
         NSString *receiveStr = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
         NSString *jsonString = [receiveStr stringByReplacingOccurrencesOfString:@"\r" withString:@""];
         jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
         jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\t" withString:@""];
         jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\v" withString:@""];
         jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\f" withString:@""];
         jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\b" withString:@""];
         jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\a" withString:@""];
         jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\e" withString:@""];
         NSData * data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
         NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&err];
         
         if(err)
         {
             NSLog(@"json解析失败：%@",err);
         }
         
         if([[ZXwangLuoDanLi WangLuoDanLi] resIsTrue:jsonDict andAlertView:self])
         {
             NSString *str = [NSString stringWithFormat:@"已成功添加 %@ 课时到 我的课时 ，可以预约练车了。",_orderListArr[_btnTag][@"goods_number"]];
             UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"添加成功" message:str preferredStyle:UIAlertControllerStyleAlert];
             NSMutableAttributedString *messageStr = [[NSMutableAttributedString alloc] initWithString:str];
             [messageStr addAttribute:NSForegroundColorAttributeName value:ZX_LightGray_Color range:NSMakeRange(0, str.length)];
             [messageStr addAttribute:NSForegroundColorAttributeName value:dao_hang_lan_Color range:NSMakeRange(str.length-14, 4)];
             [messageStr addAttribute:NSForegroundColorAttributeName value:dao_hang_lan_Color range:NSMakeRange(6, [_orderListArr[_btnTag][@"goods_number"] length])];
             [messageStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0, str.length)];
             [alert setValue:messageStr forKey:@"attributedMessage"];
             
             NSMutableAttributedString *titleStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"添加成功"]];
             [titleStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17] range:NSMakeRange(0, 4)];
             [titleStr addAttribute:NSForegroundColorAttributeName value:ZX_DarkGray_Color range:NSMakeRange(0, 4)];
             [alert setValue:titleStr forKey:@"attributedTitle"];
             
             UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"去上课" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
                                       {
                                           //使用课时卡(去上课)
                                           ZX_QuShangKe_ViewController *quShangKeVC = [[ZX_QuShangKe_ViewController alloc]init];
                                           quShangKeVC.goods_type = _orderListArr[_btnTag][@"goods_type"];
                                           quShangKeVC.subId = [ZXUD objectForKey:@"T_ID"];
                                           quShangKeVC.subject = [ZXUD objectForKey:@"usersubject"];
                                           [self.navigationController pushViewController:quShangKeVC animated:YES];
                                       }];
             [confirm setValue:dao_hang_lan_Color forKey:@"titleTextColor"];
             
             UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action)
                                      {
                                      }];
             
             [cancle setValue:ZX_LightGray_Color forKey:@"titleTextColor"];
             [alert addAction:confirm];
             [alert addAction:cancle];
             [self presentViewController:alert animated:YES completion:nil];
         }
     }failed:^(NSURLSessionTask *task, NSError *error)
     {
     }];
}


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
