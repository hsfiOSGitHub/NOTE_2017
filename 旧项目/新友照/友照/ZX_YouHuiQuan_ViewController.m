//
//  ZX_YouHuiQuan_ViewController.m
//  友照
//
//  Created by cleloyang on 2017/1/10.
//  Copyright © 2017年 ZX_XPH. All rights reserved.
//

#import "ZX_YouHuiQuan_ViewController.h"
#import "ZX_YouHuiQuanTableViewCell.h"
#import "ZXFunctionBtnsView.h"
#import "ZXKongKaQuanView.h"

@interface ZX_YouHuiQuan_ViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic) ZXFunctionBtnsView *btnsView;
@property (nonatomic, strong) ZXKongKaQuanView *KongKaQuanView;
@property (nonatomic, strong) UITableView *youHuiQuanTabV;
@property (nonatomic, strong) NSMutableArray *youHuiQuanArr;
@property (nonatomic, assign) NSInteger page;
//判断是否加载动画
@property(nonatomic)BOOL isRefresh;
@property (nonatomic, assign) NSInteger numOfPage;
@property (nonatomic, strong) UIButton *youHuiQuanBtn;
//优惠券id
@property (nonatomic, strong) NSString *discount_id;
//优惠金额
@property (nonatomic, strong) NSString *money_discount;
//优惠券类型
@property (nonatomic, copy) NSString *discount;
@end

@implementation ZX_YouHuiQuan_ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"优惠券";
    _page = 0;
    _useType = @"0";
    [self creatYouHuiQuanTabV];
     [self createFunctionBtns];
    [self getYouHuiQuanListData];
}

- (void)viewWillDisappear:(BOOL)animated
{
    _tiJiaoDingDanVC.discount_id = _discount_id;
    _tiJiaoDingDanVC.money_discount = _money_discount;
    _tiJiaoDingDanVC.discount = _discount;
}

//懒加载空卡券视图
-(ZXKongKaQuanView *)KongKaQuanView
{
    if (!_KongKaQuanView)
    {
        _KongKaQuanView = [[ZXKongKaQuanView alloc]initWithFrame:_youHuiQuanTabV.frame];
        _KongKaQuanView.label.text = @"您现在还没有优惠券哦";
    }
    return _KongKaQuanView;
}

- (void)createFunctionBtns
{
    NSArray *functionNames = @[@"可用优惠券",@"不可用优惠券"];
    _btnsView = [[ZXFunctionBtnsView alloc] initWithButtonNames:functionNames andStartPoint:CGPointMake(0, 64) andSpace:1 andBtnHeight:ZXFUNCTION_BTN_HEIGHT andXiaHuaXiaImage:[UIImage imageNamed:@"btn_denglu"]];
    for (UIButton *btn in _btnsView.buttonArray)
    {
        [btn addTarget:self action:@selector(functionBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    [_btnsView btnsPasteSuperView:self.view];
    _btnsView.cutHeight = ZXFUNCTION_SPAD_CUT_HEIGHT;
}

- (void)creatYouHuiQuanTabV
{
    _youHuiQuanTabV = [[UITableView alloc] initWithFrame:CGRectMake(0, KTableView_Y, KScreenWidth, KScreenHeight - KTableView_Y) style:UITableViewStylePlain];
    [self.view addSubview:_youHuiQuanTabV];
    _youHuiQuanTabV.backgroundColor = ZX_BG_COLOR;
    _youHuiQuanTabV.dataSource = self;
    _youHuiQuanTabV.delegate = self;
    _youHuiQuanTabV.showsVerticalScrollIndicator = NO;
    //注册cell
    [_youHuiQuanTabV registerNib:[UINib nibWithNibName:@"ZX_YouHuiQuanTableViewCell" bundle:Nil] forCellReuseIdentifier:@"cellID"];
    _youHuiQuanTabV.separatorStyle = UITableViewCellSelectionStyleNone;
    
    //添加下拉刷新视图
    _youHuiQuanTabV.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _page = 0;
        [_youHuiQuanArr removeAllObjects];
        _isRefresh = YES;
        [self getYouHuiQuanListData];
    }];
    //
    _youHuiQuanTabV.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        _page ++;
        _isRefresh = YES;
        [self getYouHuiQuanListData];
    }];

    //在tableview添加手势
    UISwipeGestureRecognizer *leftSwipGes = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(rightSwipEvent:)];
    leftSwipGes.direction = UISwipeGestureRecognizerDirectionRight;
    [_youHuiQuanTabV addGestureRecognizer:leftSwipGes];
    
    UISwipeGestureRecognizer *rightSwipGes = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(leftSwipEvent:)];
    leftSwipGes.direction = UISwipeGestureRecognizerDirectionLeft;
    [_youHuiQuanTabV addGestureRecognizer:rightSwipGes];
}

//切换按钮点击事件
- (void)functionBtnClick:(UIButton *)btn
{
    _page = 0;
    [_animationView removeFromSuperview];
    //配置数据源
    [_btnsView buttonSelected:btn.tag - 1000];
    _numOfPage = btn.tag;
    [_youHuiQuanArr removeAllObjects];
    switch (btn.tag)
    {
        case 1000:
        {
            //可用优惠券
            _useType = @"0";
        }
            break;
        case 1001:
        {
            //不可用优惠券
            _useType = @"1";
        }
            break;
        default:
            break;
    }
    [self getYouHuiQuanListData];
}

- (void)leftSwipEvent:(UISwipeGestureRecognizer *)swip
{
    [_animationView removeFromSuperview];
    if( --_numOfPage < 0)
    {
        _numOfPage = 0;
    }
    [_btnsView buttonSelected:_numOfPage];
    [self slideGetData];
}
- (void)rightSwipEvent:(UISwipeGestureRecognizer *)swip
{
    [_animationView removeFromSuperview];
    if( ++_numOfPage > 2)
    {
        _numOfPage = 2;
    }
    [_btnsView buttonSelected:_numOfPage];
    [self slideGetData];
}
//滑动切换页面时的数据刷新
- (void)slideGetData
{
    _page = 0;
    [_youHuiQuanArr removeAllObjects];
    if (_numOfPage == 0)
    {
        _useType = @"0";
    }
    else if (_numOfPage == 1)
    {
        _useType = @"1";
    }
        [self getYouHuiQuanListData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_youHuiQuanArr && _youHuiQuanArr.count == 0)
    {
        [self KongKaQuanView];
        [self.view insertSubview:_KongKaQuanView belowSubview:_animationView];
    }
    else
    {
        return _youHuiQuanArr.count;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 110;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZX_YouHuiQuanTableViewCell *cell = [_youHuiQuanTabV dequeueReusableCellWithIdentifier:@"cellID"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if ([_youHuiQuanArr[indexPath.row][@"type"] isEqualToString:@"1"])
    {
        cell.danWeiLab.hidden = NO;
        cell.youHuiQuanPriceLab.text = _youHuiQuanArr[indexPath.row][@"money_discount"];
    }
    else
    {
        if ([_youHuiQuanArr[indexPath.row][@"money_rate"] integerValue]%10)
        {
            cell.youHuiQuanPriceLab.text = [NSString stringWithFormat:@"%.1f折",[_youHuiQuanArr[indexPath.row][@"money_rate"] floatValue]/10.0];
        }
        else
        {
            cell.youHuiQuanPriceLab.text = [NSString stringWithFormat:@"%ld折",[_youHuiQuanArr[indexPath.row][@"money_rate"] integerValue]/10];
        }
        cell.danWeiLab.hidden = YES;
//        if ([_list isEqualToString:@"1"])
//        {
//            if ([_youHuiQuanArr[indexPath.row][@"money_rate"] integerValue]%10)
//            {
//                cell.youHuiQuanPriceLab.text = [NSString stringWithFormat:@"%.1f折",[_youHuiQuanArr[indexPath.row][@"money_rate"] floatValue]/10.0];
//            }
//            else
//            {
//                cell.youHuiQuanPriceLab.text = [NSString stringWithFormat:@"%ld折",[_youHuiQuanArr[indexPath.row][@"money_rate"] integerValue]/10];
//            }
//            cell.danWeiLab.hidden = YES;
//        }
//        else
//        {
//           cell.youHuiQuanPriceLab.text = [NSString stringWithFormat:@"%.1f", _price-[_youHuiQuanArr[indexPath.row][@"money_rate"] floatValue]*_price/100.0];
//        }
    }
    
    if ([_youHuiQuanArr[indexPath.row][@"goods_type"] isEqualToString:@"学时卡通用"])
    {
        cell.youHuiQuanNameLab.text = [NSString stringWithFormat:@"仅限购买 学时卡 使用"];
    }
    else
    {
        cell.youHuiQuanNameLab.text = [NSString stringWithFormat:@"仅限购买 %@ 使用",_youHuiQuanArr[indexPath.row][@"goods_type"]];
    }
    
//    if ([_list isEqualToString:@"1"])
//    {
//        if ([_youHuiQuanArr[indexPath.row][@"goods_type"] isEqualToString:@"学时卡通用"])
//        {
//            cell.youHuiQuanNameLab.text = [NSString stringWithFormat:@"仅限购买 学时卡 使用"];
//        }
//        else
//        {
//          cell.youHuiQuanNameLab.text = [NSString stringWithFormat:@"仅限购买 %@ 使用",_youHuiQuanArr[indexPath.row][@"goods_type"]];
//        }
//    }
//    else
//    {
//        if ([_useType isEqualToString:@"0"])
//        {
//            if ([_youHuiQuanArr[indexPath.row][@"type"] isEqualToString:@"1"])
//            {
//                cell.youHuiQuanNameLab.text = [NSString stringWithFormat:@"%@ %@ 元优惠券",[ZXUD objectForKey:@"S_NAME"],_youHuiQuanArr[indexPath.row][@"money_discount"]];
//            }
//            else
//            {
//                if ([_youHuiQuanArr[indexPath.row][@"money_rate"] integerValue]%10)
//                {
//                     cell.youHuiQuanNameLab.text = [NSString stringWithFormat:@"%@ %.1f 折优惠券",[ZXUD objectForKey:@"S_NAME"],[_youHuiQuanArr[indexPath.row][@"money_rate"] floatValue]/10.0];
//                }
//                else
//                {
//                     cell.youHuiQuanNameLab.text = [NSString stringWithFormat:@"%@ %ld 折优惠券",[ZXUD objectForKey:@"S_NAME"],[_youHuiQuanArr[indexPath.row][@"money_rate"] integerValue]/10];
//                }
//            }
//        }
//        else
//        {
//            if ([_youHuiQuanArr[indexPath.row][@"discount_type"] isEqualToString:@"0"])
//            {
//                if ([_youHuiQuanArr[indexPath.row][@"type"] isEqualToString:@"1"])
//                {
//                    cell.youHuiQuanNameLab.text = [NSString stringWithFormat:@"全平台通用 %@ 元优惠券",_youHuiQuanArr[indexPath.row][@"money_discount"]];
//                }
//                else
//                {
//                    if ([_youHuiQuanArr[indexPath.row][@"money_rate"] integerValue]%10)
//                    {
//                        cell.youHuiQuanNameLab.text = [NSString stringWithFormat:@"全平台通用 %.1f 折优惠券",[_youHuiQuanArr[indexPath.row][@"money_rate"] floatValue]/10.0];
//                    }
//                    else
//                    {
//                        cell.youHuiQuanNameLab.text = [NSString stringWithFormat:@"全平台通用 %ldf 折优惠券",[_youHuiQuanArr[indexPath.row][@"money_rate"] integerValue]/10];
//                    }
//                }
//            }
//            else
//            {
//                if ([_youHuiQuanArr[indexPath.row][@"type"] isEqualToString:@"1"])
//                {
//                    cell.youHuiQuanNameLab.text = [NSString stringWithFormat:@"部分驾校适用 %@ 元优惠券",_youHuiQuanArr[indexPath.row][@"money_discount"]];
//                }
//                else
//                {
//                    if ([_youHuiQuanArr[indexPath.row][@"money_rate"] integerValue]%10)
//                    {
//                        cell.youHuiQuanNameLab.text = [NSString stringWithFormat:@"部分驾校适用 %.1f 折优惠券",[_youHuiQuanArr[indexPath.row][@"money_rate"] floatValue]/10.0];
//                    }
//                    else
//                    {
//                        cell.youHuiQuanNameLab.text = [NSString stringWithFormat:@"部分驾校适用 %ld 折优惠券",[_youHuiQuanArr[indexPath.row][@"money_rate"] integerValue]/10];
//                    }
//                    
//                }
//            }
//        }
//    }
    
    if ([_youHuiQuanArr[indexPath.row][@"type"] isEqualToString:@"1"])
    {
        cell.youHuiQuanShiYongYaoQiuLab.text = [NSString stringWithFormat:@"满 %@ 可用",_youHuiQuanArr[indexPath.row][@"moneny_line"]];
    }
    else
    {
        cell.youHuiQuanShiYongYaoQiuLab.text = @"无门槛使用";
    }
    
    if ([_list isEqualToString:@"1"] && [_useType isEqualToString:@"1"])
    {
        cell.youHuiQuanYouXiaoQiLab.text = @"卡券已过期";
    }
    else
    {
      cell.youHuiQuanYouXiaoQiLab.text = [NSString stringWithFormat:@"有效期限:%@",_youHuiQuanArr[indexPath.row][@"use_times"]];
    }
    
    if ([_list isEqualToString:@"1"] || [_useType isEqualToString:@"1"])
    {
        cell.youHuiQuanBtn.hidden = YES;
    }
    else
    {
        cell.youHuiQuanBtn.hidden = NO;
    }
    [cell.youHuiQuanBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];

    for (int i = 0; i < _youHuiQuanArr.count; i ++)
    {
        if ([_discount_id isEqualToString:_youHuiQuanArr[indexPath.row][@"discount_id"]])
        {
            [cell.youHuiQuanBtn setImage:[UIImage imageNamed:@"ic_choose"] forState:UIControlStateNormal];
        }
    }
    _youHuiQuanBtn = cell.youHuiQuanBtn;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (![_list isEqualToString:@"1"] && [_useType isEqualToString:@"0"])
    {
        if ([[_youHuiQuanBtn currentImage] isEqual:[UIImage imageNamed:@"ic_choose"]] && [_discount_id isEqualToString:_youHuiQuanArr[indexPath.row][@"discount_id"]])
        {
            _discount_id = nil;
            _money_discount = nil;
        }
        else
        {
            _discount_id = _youHuiQuanArr[indexPath.row][@"discount_id"];
            if ([_youHuiQuanArr[indexPath.row][@"type"] isEqualToString:@"1"])
            {
                _money_discount = _youHuiQuanArr[indexPath.row][@"money_discount"];
                _discount = @"1";
            }
            else
            {
                _discount = @"2";
                if ([_youHuiQuanArr[indexPath.row][@"money_rate"] integerValue]%10)
                {
                    _money_discount = [NSString stringWithFormat:@"%.1f",[_youHuiQuanArr[indexPath.row][@"money_rate"] floatValue]/10.0];
                }
                else
                {
                    _money_discount = [NSString stringWithFormat:@"%ld",[_youHuiQuanArr[indexPath.row][@"money_rate"] integerValue]/10];
                }
            }            
        }
        [_youHuiQuanTabV reloadData];
    }
}

//优惠券列表
- (void)getYouHuiQuanListData
{
    if (!_isRefresh)
    {
        _animationView=[[ZXAnimationView alloc]initWithFrame:CGRectMake(0, KTableView_Y, KScreenWidth, KScreenHeight-KTableView_Y)];
        [self.view addSubview:_animationView];
    }

    [[ZXNetDataManager manager] getYouHuiQuanListDataWithRndstring:[ZXDriveGOHelper getCurrentTimeStamp] andIdent_code:[ZXUD objectForKey:@"ident_code"] andId:_orderId andGoods_num:[NSString stringWithFormat:@"%ld",(long)_goodsNum] andGoods_type:_goodsType andPage:[NSString stringWithFormat:@"%ld",(long)_page] andUse_type:_useType andList:_list success:^(NSURLSessionDataTask *task, id responseObject)
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
         [_KongKaQuanView removeFromSuperview];
         //先判断是否成功接收到数据,如果成功分类型展示
         if([[ZXwangLuoDanLi WangLuoDanLi] resIsTrue:jsonDict andAlertView:self])
         {
             if ([jsonDict[@"exam_list"] isKindOfClass:[NSArray class]])
             {
                 if (!_youHuiQuanArr)
                 {
                     _youHuiQuanArr = [NSMutableArray arrayWithArray:jsonDict[@"exam_list"]];
                 }
                 else
                 {
                     [_youHuiQuanArr addObjectsFromArray:jsonDict[@"exam_list"]];
                 }
             }
         }
         [_youHuiQuanTabV reloadData];
         
         dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
             [_animationView removeFromSuperview];
         });
         
         _isRefresh = NO;
         [_youHuiQuanTabV.mj_header endRefreshing];
         [_youHuiQuanTabV.mj_footer endRefreshing];
     } failed:^(NSURLSessionTask *task, NSError *error)
     {
         [_animationView removeFromSuperview];
         [_youHuiQuanTabV.mj_header endRefreshing];
         [_youHuiQuanTabV.mj_footer endRefreshing];
     }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
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
