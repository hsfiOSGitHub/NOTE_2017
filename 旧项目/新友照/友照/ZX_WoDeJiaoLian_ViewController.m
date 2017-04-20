//
//  ZX_WoDeJiaoLian_ViewController.m
//  友照
//
//  Created by cleloyang on 2017/1/6.
//  Copyright © 2017年 ZX_XPH. All rights reserved.
//

#import "ZX_WoDeJiaoLian_ViewController.h"
//教练列表
#import "CoachViewController.h"
//去上课
#import "ZX_QuShangKe_ViewController.h"
//评论
#import "ZXEvaluateOrderListVC.h"
@interface ZX_WoDeJiaoLian_ViewController ()

@end

@implementation ZX_WoDeJiaoLian_ViewController

-(void)viewWillAppear:(BOOL)animated
{
    [self shezhi];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"我的教练";
    [self shezhi];
}

-(void)shezhi
{
    if ([[ZXUD objectForKey:@"usersubject"] isEqualToString:@"0"] || [[ZXUD objectForKey:@"usersubject"] isEqualToString:@"1"])
    {
        _keErJiaoLianNameLab.hidden = YES;
        _keErSelectJiaoLianLab.hidden = NO;
        _keErSelectJiaoLianLab.text = @"立即选择";
        _keErSelectJiaoLianLab.textColor = [UIColor colorWithRed:85/255.0 green:188/255.0 blue:173/255.0 alpha:1.0];
        _keSanJiaoLianNameLab.hidden = YES;
        _keSanSelectJiaoLianLab.hidden = NO;
        _keSanSelectJiaoLianLab.text = @"立即选择";
        _keSanSelectJiaoLianLab.textColor = [UIColor colorWithRed:85/255.0 green:188/255.0 blue:173/255.0 alpha:1.0];
    }
    else if ([[ZXUD objectForKey:@"usersubject"] isEqualToString:@"2"])
    {
        _keSanJiaoLianNameLab.hidden = YES;
        _keSanSelectJiaoLianLab.hidden = NO;
        _keSanSelectJiaoLianLab.text = @"立即选择";
        _keSanSelectJiaoLianLab.textColor = [UIColor colorWithRed:85/255.0 green:188/255.0 blue:173/255.0 alpha:1.0];
        if ([[ZXUD objectForKey:@"T_NAME2"] length]>0)
        {
            _keErJiaoLianNameLab.text = [ZXUD objectForKey:@"T_NAME2"];
            _keErJiaoLianNameLab.textColor = [UIColor grayColor];
            _keErSelectJiaoLianLab.hidden = YES;
        }
        else
        {
            _keErJiaoLianNameLab.hidden = YES;
            _keErSelectJiaoLianLab.hidden = NO;
            _keErSelectJiaoLianLab.text = @"立即选择";
            _keErSelectJiaoLianLab.textColor = [UIColor colorWithRed:85/255.0 green:188/255.0 blue:173/255.0 alpha:1.0];
        }
    }
    else if ([[ZXUD objectForKey:@"usersubject"] isEqualToString:@"3"])
    {
        _keErJiaoLianNameLab.hidden = YES;
        _keErSelectJiaoLianLab.hidden = NO;
        
        if ([[ZXUD objectForKey:@"T_C2"] isEqualToString:@"2"])
        {
            _keErSelectJiaoLianLab.text = @"已评价";
        }
        else
        {
            _keErSelectJiaoLianLab.text = @"赶快去给教练评分吧";
        }
        NSLog(@"%@",[ZXUD objectForKey:@"T_ID3"]);
        if ([[ZXUD objectForKey:@"T_NAME3"] length]>0)
        {
            _keSanJiaoLianNameLab.text = [ZXUD objectForKey:@"T_NAME3"];
            _keSanJiaoLianNameLab.textColor = [UIColor grayColor];
            _keSanSelectJiaoLianLab.hidden = YES;
        }
        else
        {
            _keSanJiaoLianNameLab.hidden = YES;
            _keSanSelectJiaoLianLab.hidden = NO;
            _keSanSelectJiaoLianLab.text = @"立即选择";
            _keSanSelectJiaoLianLab.textColor = [UIColor colorWithRed:85/255.0 green:188/255.0 blue:173/255.0 alpha:1.0];
        }
    }
    else 
    {
        _keErJiaoLianNameLab.hidden = YES;
        _keErSelectJiaoLianLab.hidden = NO;
        _keSanJiaoLianNameLab.hidden = YES;
        _keSanSelectJiaoLianLab.hidden = NO;
        if ([[ZXUD objectForKey:@"T_C2"] isEqualToString:@"2"])
        {
            _keErSelectJiaoLianLab.text = @"已评价";
        }
        else
        {
            _keErSelectJiaoLianLab.text = @"赶快去给教练评分吧";
        }
        if ([[ZXUD objectForKey:@"T_C3"] isEqualToString:@"2"])
        {
            _keSanSelectJiaoLianLab.text = @"已评价";
        }
        else
        {
            _keSanSelectJiaoLianLab.text = @"赶快去给教练评分吧";
        }
    }
    
    _keMuErJiaoLianBtn.tag = 100;
    _keMuSanJiaoLianBtn.tag = 101;
    [_keMuErJiaoLianBtn addTarget:self action:@selector(woDeJiaoLian:) forControlEvents:UIControlEventTouchDown];
    [_keMuSanJiaoLianBtn addTarget:self action:@selector(woDeJiaoLian:) forControlEvents:UIControlEventTouchDown];

}

- (void)woDeJiaoLian:(UIButton *)btn
{
    switch (btn.tag)
    {
        case 100:
            if ([[ZXUD objectForKey:@"usersubject"] isEqualToString:@"0"] || [[ZXUD objectForKey:@"usersubject"] isEqualToString:@"1"])
            {
                [MBProgressHUD showSuccess:@"您还没有学到科二哦"];
                return ;
            }
            if ([[ZXUD objectForKey:@"T_NAME2"] isEqualToString:@""])
            {
                CoachViewController *coachVC = [[CoachViewController alloc]init];
                coachVC.sid = [ZXUD objectForKey:@"S_ID"];
                coachVC.cityName = [ZXUD objectForKey:@"city"];
                coachVC.subject = @"2";
                coachVC.CoachType = @"科目二教练";
                [self.navigationController pushViewController:coachVC animated:YES];
            }
            else
            {
                ZX_QuShangKe_ViewController *quShangKeVC = [[ZX_QuShangKe_ViewController alloc]init];
                if ([[ZXUD objectForKey:@"usersubject"] isEqualToString:@"2"])
                {
                    quShangKeVC.subId = [ZXUD objectForKey:@"T_ID2"];
                    quShangKeVC.subject = @"2";
                    quShangKeVC.goods_type = @"12";
                    quShangKeVC.jiaoLianName = [ZXUD objectForKey:@"T_NAME2"];
                    [self.navigationController pushViewController:quShangKeVC animated:YES];
                }
                else
                {
                    if ([[ZXUD objectForKey:@"T_C2"] isEqualToString:@"1"])
                    {
                        //评价科二教练
                        ZXEvaluateOrderListVC *vc = [[ZXEvaluateOrderListVC alloc]init];
                        vc.tid=[ZXUD objectForKey:@"T_ID2"];
                        [self.navigationController pushViewController:vc animated:YES];
                        return ;
                    }
                    else
                    {
                        [MBProgressHUD showSuccess:@"您已评论过教练了"];
   
                    }
                }
            }
            break;
            
        case 101:
            if ([[ZXUD objectForKey:@"usersubject"] isEqualToString:@"0"] || [[ZXUD objectForKey:@"usersubject"] isEqualToString:@"1"] || [[ZXUD objectForKey:@"usersubject"] isEqualToString:@"2"])
            {
                [MBProgressHUD showSuccess:@"您还没有学到科三哦"];
                return ;
            }
           
            if ([[ZXUD objectForKey:@"T_NAME3"] isEqualToString:@""])
            {
                CoachViewController *coachVC = [[CoachViewController alloc]init];
                coachVC.sid = [ZXUD objectForKey:@"S_ID"];
                coachVC.cityName = [ZXUD objectForKey:@"city"];
                coachVC.subject = @"3";
                coachVC.CoachType = @"科目三教练";
                [self.navigationController pushViewController:coachVC animated:YES];
            }
            else
            {
                ZX_QuShangKe_ViewController *quShangKeVC = [[ZX_QuShangKe_ViewController alloc]init];
                if ([[ZXUD objectForKey:@"usersubject"] isEqualToString:@"3"])
                {
                    quShangKeVC.subId = [ZXUD objectForKey:@"T_ID3"];
                    quShangKeVC.subject = @"3";
                    quShangKeVC.goods_type = @"13";
                    quShangKeVC.jiaoLianName = [ZXUD objectForKey:@"T_NAME3"];
                    [self.navigationController pushViewController:quShangKeVC animated:YES];
                }
                else
                {
                    if ([[ZXUD objectForKey:@"T_C3"] isEqualToString:@"1"])
                    {
                        //评价科三教练
                        ZXEvaluateOrderListVC *vc = [[ZXEvaluateOrderListVC alloc]init];
                        vc.tid=[ZXUD objectForKey:@"T_ID3"];;
                        [self.navigationController pushViewController:vc animated:YES];
                        return ;
                    }
                    else
                    {
                        [MBProgressHUD showSuccess:@"您已评论过教练了"];
                    }
                }
            }
            break;
            
        default:
            break;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
