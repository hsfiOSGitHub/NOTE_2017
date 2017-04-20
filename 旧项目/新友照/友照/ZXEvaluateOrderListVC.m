//
//  ZXEvaluateOrderListVC.m
//  ZXJiaXiao
//
//  Created by yujian on 16/5/21.
//  Copyright © 2016年 ZX. All rights reserved.
//

#import "ZXEvaluateOrderListVC.h"


@interface ZXEvaluateOrderListVC ()<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *pingjia;
//九个标签
@property (weak, nonatomic) IBOutlet UIButton *lhaojiaolian;
@property (weak, nonatomic) IBOutlet UIButton *chekuanglianghao;
@property (weak, nonatomic) IBOutlet UIButton *shangchekuai;
@property (weak, nonatomic) IBOutlet UIButton *jiangjiebuhao;
@property (weak, nonatomic) IBOutlet UIButton *jiageheli;
@property (weak, nonatomic) IBOutlet UIButton *suiyijiadui;
@property (weak, nonatomic) IBOutlet UIButton *chekuangcha;
@property (weak, nonatomic) IBOutlet UIButton *taiducha;
@property (weak, nonatomic) IBOutlet UIButton *youbangzhu;
//选择1到5星的btn
@property (weak, nonatomic) IBOutlet UIButton *btn1;
@property (weak, nonatomic) IBOutlet UIButton *btn2;
@property (weak, nonatomic) IBOutlet UIButton *btn3;
@property (weak, nonatomic) IBOutlet UIButton *btn4;
@property (weak, nonatomic) IBOutlet UIButton *btn5;

@end

@implementation ZXEvaluateOrderListVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor=[UIColor whiteColor];
    self.title = @"评价";
    [self creatRightBarButtonItem];
    //适配
    self.edgesForExtendedLayout = UIRectEdgeNone;
    //设置评价下面的按钮边框和边框颜色
    [self shezhibiankuangyanse];
    //创建选择星级5个按钮的点击事件
    [_btn1 addTarget:self action:@selector(selectedStar:) forControlEvents:UIControlEventTouchDown];
    [_btn2 addTarget:self action:@selector(selectedStar:) forControlEvents:UIControlEventTouchDown];
    [_btn3 addTarget:self action:@selector(selectedStar:) forControlEvents:UIControlEventTouchDown];
    [_btn4 addTarget:self action:@selector(selectedStar:) forControlEvents:UIControlEventTouchDown];
    [_btn5 addTarget:self action:@selector(selectedStar:) forControlEvents:UIControlEventTouchDown];
    [_btn1 setBackgroundImage:[UIImage imageNamed:@"star_normal"] forState:UIControlStateNormal];
    [_btn2 setBackgroundImage:[UIImage imageNamed:@"star_normal"] forState:UIControlStateNormal];
    [_btn3 setBackgroundImage:[UIImage imageNamed:@"star_normal"] forState:UIControlStateNormal];
    [_btn4 setBackgroundImage:[UIImage imageNamed:@"star_normal"] forState:UIControlStateNormal];
    [_btn5 setBackgroundImage:[UIImage imageNamed:@"star_normal"] forState:UIControlStateNormal];
    _btn1.tag = 1231;
    _btn2.tag = 1232;
    _btn3.tag = 1233;
    _btn4.tag = 1234;
    _btn5.tag = 1235;
    self.pingjia.text=[NSString stringWithFormat:@"  中国好教练"];
    self.pingjia.delegate = self;
}

- (void)creatRightBarButtonItem
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"提交" style:UIBarButtonItemStyleDone target:self action:@selector(commitComment)];
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor whiteColor]];
}
//选择星级的按钮事件
- (void)selectedStar:(UIButton *)btn
{
    
    if(btn.tag == 1231)
    {
        [_btn1 setBackgroundImage:[UIImage imageNamed:@"star_hd"] forState:UIControlStateNormal];
        [_btn2 setBackgroundImage:[UIImage imageNamed:@"star_normal"] forState:UIControlStateNormal];
        [_btn3 setBackgroundImage:[UIImage imageNamed:@"star_normal"] forState:UIControlStateNormal];
        [_btn4 setBackgroundImage:[UIImage imageNamed:@"star_normal"] forState:UIControlStateNormal];
        [_btn5 setBackgroundImage:[UIImage imageNamed:@"star_normal"] forState:UIControlStateNormal];
        _star_hd = @"1";
    }
    else if (btn.tag == 1232)
    {
        [_btn1 setBackgroundImage:[UIImage imageNamed:@"star_hd"] forState:UIControlStateNormal];
        [_btn2 setBackgroundImage:[UIImage imageNamed:@"star_hd"] forState:UIControlStateNormal];
        [_btn3 setBackgroundImage:[UIImage imageNamed:@"star_normal"] forState:UIControlStateNormal];
        [_btn4 setBackgroundImage:[UIImage imageNamed:@"star_normal"] forState:UIControlStateNormal];
        [_btn5 setBackgroundImage:[UIImage imageNamed:@"star_normal"] forState:UIControlStateNormal];
        _star_hd = @"2";
    }
    else if ( btn.tag == 1233)
    {
        [_btn1 setBackgroundImage:[UIImage imageNamed:@"star_hd"] forState:UIControlStateNormal];
        [_btn2 setBackgroundImage:[UIImage imageNamed:@"star_hd"] forState:UIControlStateNormal];
        [_btn3 setBackgroundImage:[UIImage imageNamed:@"star_hd"] forState:UIControlStateNormal];
        [_btn4 setBackgroundImage:[UIImage imageNamed:@"star_normal"] forState:UIControlStateNormal];
        [_btn5 setBackgroundImage:[UIImage imageNamed:@"star_normal"] forState:UIControlStateNormal];
        _star_hd = @"3";
    }
    else if (btn.tag == 1234)
    {
        [_btn1 setBackgroundImage:[UIImage imageNamed:@"star_hd"] forState:UIControlStateNormal];
        [_btn2 setBackgroundImage:[UIImage imageNamed:@"star_hd"] forState:UIControlStateNormal];
        [_btn3 setBackgroundImage:[UIImage imageNamed:@"star_hd"] forState:UIControlStateNormal];
        [_btn4 setBackgroundImage:[UIImage imageNamed:@"star_hd"] forState:UIControlStateNormal];
        [_btn5 setBackgroundImage:[UIImage imageNamed:@"star_normal"] forState:UIControlStateNormal];
        _star_hd = @"4";
    }
    else
    {
        [_btn1 setBackgroundImage:[UIImage imageNamed:@"star_hd"] forState:UIControlStateNormal];
        [_btn2 setBackgroundImage:[UIImage imageNamed:@"star_hd"] forState:UIControlStateNormal];
        [_btn3 setBackgroundImage:[UIImage imageNamed:@"star_hd"] forState:UIControlStateNormal];
        [_btn4 setBackgroundImage:[UIImage imageNamed:@"star_hd"] forState:UIControlStateNormal];
        [_btn5 setBackgroundImage:[UIImage imageNamed:@"star_hd"] forState:UIControlStateNormal];
        _star_hd = @"5";
    }
    
}

//提交评论
-(void)commitComment
{
    [self getNetData];
}

- (BOOL)stringContainsEmoji:(NSString *)string
{
    __block BOOL returnValue = NO;
    
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length])
                               options:NSStringEnumerationByComposedCharacterSequences
                            usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop)
    {
                                const unichar hs = [substring characterAtIndex:0];
                                if (0xd800 <= hs && hs <= 0xdbff)
                                {
                                    if (substring.length > 1)
                                    {
                                        const unichar ls = [substring characterAtIndex:1];
                                        const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                                        if (0x1d000 <= uc && uc <= 0x1f77f)
                                        {
                                            returnValue = YES;
                                        }
                                    }
                                }
                                else if (substring.length > 1)
                                {
                                    const unichar ls = [substring characterAtIndex:1];
                                    if (ls == 0x20e3)
                                    {
                                        returnValue = YES;
                                    }
                                }
                                else
                                {
                                    if (0x2100 <= hs && hs <= 0x27ff)
                                    {
                                        returnValue = YES;
                                    }
                                    else if (0x2B05 <= hs && hs <= 0x2b07)
                                    {
                                        returnValue = YES;
                                    }
                                    else if (0x2934 <= hs && hs <= 0x2935)
                                    {
                                        returnValue = YES;
                                    }
                                    else if (0x3297 <= hs && hs <= 0x3299)
                                    {
                                        returnValue = YES;
                                    }
                                    else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50)
                                    {
                                        returnValue = YES;
                                    }
                                }
                            }];
    
    return returnValue;
}

//获取网络数据
-(void)getNetData
{
    if ([self stringContainsEmoji:self.pingjia.text])
    {
        [MBProgressHUD showSuccess:@"您的评论含有表情，不能提交"];
        return;
    }
    
    if ( self.pingjia.text.length == 0 || self.star_hd.length == 0)
    {
        [MBProgressHUD showSuccess:@"评论内容不能为空"];
        return;
    }
    // 把评分，教练编号，评论内容，订单号返回给服务器(缺少订单编号和tid) 把汉语转码
    [[ZXNetDataManager manager] getPingLunDataWithRndStrng:[ZXDriveGOHelper getCurrentTimeStamp] andIdent_code:[ZXUD objectForKey:@"ident_code"] andSid:_sid  andTid:_tid andScore:_star_hd andContent:self.pingjia.text success:^(NSURLSessionDataTask *task, id responseObject)
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
         
        [self creatRightBarButtonItem];
         
         if([[ZXwangLuoDanLi WangLuoDanLi] resIsTrue:jsonDict andAlertView:self])
         {
             if([_tid isEqualToString:[ZXUD objectForKey:@"T_ID2"]])
             {
                 [ZXUD setObject:@"2" forKey:@"T_C2"];

             }
             else if([_tid isEqualToString:[ZXUD objectForKey:@"T_ID3"]])
             {
                 [ZXUD setObject:@"2" forKey:@"T_C3"];

             }
             if ([_sid isEqualToString:[ZXUD objectForKey:@"S_ID"]]) {
                 
                 [ZXUD setObject:@"2" forKey:@"S_C"];
             }
             
             [MBProgressHUD showSuccess:jsonDict[@"msg"]];
             [self.navigationController popViewControllerAnimated:YES];
         }
     }
    failed:^(NSURLSessionTask *task, NSError *error)
     {
         [MBProgressHUD showSuccess:@"网络不好，请稍后重试。"];         
     }];
}
//设置评价下面的按钮边框和边框颜色
-(void)shezhibiankuangyanse
{
    //中国好教练
    [self.lhaojiaolian.layer setMasksToBounds:YES];
    [self.lhaojiaolian.layer setCornerRadius:4]; //设置矩形四个圆角半径
    [self.lhaojiaolian.layer setBorderWidth:1]; //边框宽度
    [self.lhaojiaolian.layer setBorderColor:[[UIColor lightGrayColor] CGColor] ];//边框颜色
    //车况良好
    [self.chekuanglianghao.layer setMasksToBounds:YES];
    [self.chekuanglianghao.layer setCornerRadius:4]; //设置矩形四个圆角半径
    [self.chekuanglianghao.layer setBorderWidth:1]; //边框宽度
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 49/255.0, 190/255.0, 151/255.0, 1 });
    CGColorRef colorreff = CGColorCreate(colorSpace,(CGFloat[]){ 203/255.0, 115/255.0, 126/255.0, 1 });
    [self.chekuanglianghao.layer setBorderColor:colorref] ;//边框颜色
    //上车快
    [self.shangchekuai.layer setMasksToBounds:YES];
    [self.shangchekuai.layer setCornerRadius:4]; //设置矩形四个圆角半径
    [self.shangchekuai.layer setBorderWidth:1]; //边框宽度
    [self.shangchekuai.layer setBorderColor:colorref] ;//边框颜色
    //教练讲解不好
    [self.jiangjiebuhao.layer setMasksToBounds:YES];
    [self.jiangjiebuhao.layer setCornerRadius:4]; //设置矩形四个圆角半径
    [self.jiangjiebuhao.layer setBorderWidth:1]; //边框宽度
    [self.jiangjiebuhao.layer setBorderColor:colorreff] ;//边框颜色
    //价格比较合理
    [self.jiageheli.layer setMasksToBounds:YES];
    [self.jiageheli.layer setCornerRadius:4]; //设置矩形四个圆角半径
    [self.jiageheli.layer setBorderWidth:1]; //边框宽度
    [self.jiageheli.layer setBorderColor:colorref] ;//边框颜色
    //随意加队
    [self.suiyijiadui.layer setMasksToBounds:YES];
    [self.suiyijiadui.layer setCornerRadius:4]; //设置矩形四个圆角半径
    [self.suiyijiadui.layer setBorderWidth:1]; //边框宽度
    [self.suiyijiadui.layer setBorderColor:colorreff] ;//边框颜色
    //车况较差
    [self.chekuangcha.layer setMasksToBounds:YES];
    [self.chekuangcha.layer setCornerRadius:4]; //设置矩形四个圆角半径
    [self.chekuangcha.layer setBorderWidth:1]; //边框宽度
    [self.chekuangcha.layer setBorderColor:colorreff] ;//边框颜色
    //态度差
    [self.taiducha.layer setMasksToBounds:YES];
    [self.taiducha.layer setCornerRadius:4]; //设置矩形四个圆角半径
    [self.taiducha.layer setBorderWidth:1]; //边框宽度
    [self.taiducha.layer setBorderColor:colorreff] ;//边框颜色
    
    //对考试过关很有帮助
    [self.youbangzhu.layer setMasksToBounds:YES];
    [self.youbangzhu.layer setCornerRadius:4]; //设置矩形四个圆角半径
    [self.youbangzhu.layer setBorderWidth:1]; //边框宽度
    [self.youbangzhu.layer setBorderColor:colorref] ;//边框颜色
}

//点击添加特定的标签
- (IBAction)dianjishijian:(UIButton *)sender
{
    //首先获取当前的内容，然后在后面追加上标签上的内容，最后设置UITextView的文本内容即可
    NSString* str=self.pingjia.text;
    switch (sender.tag)
    {
        //中国好教练
        case 1:
            self.pingjia.text=[NSString stringWithFormat:@"%@ 中国好教练",str];
            break;
        //车况良好
        case 2:
            self.pingjia.text=[NSString stringWithFormat:@"%@ 车况良好",str];
            break;
        //上车快
        case 3:
            self.pingjia.text=[NSString stringWithFormat:@"%@ 上车快",str];
            break;
        //教练讲解不好
        case 4:
            self.pingjia.text=[NSString stringWithFormat:@"%@ 教练讲解不好",str];
            break;
        //价格比较合理
        case 5:
            self.pingjia.text=[NSString stringWithFormat:@"%@ 价格比较合理",str];
            break;
        //随意加队
        case 6:
            self.pingjia.text=[NSString stringWithFormat:@"%@ 随意加队",str];
            break;
        //车况较差
        case 7:
            self.pingjia.text=[NSString stringWithFormat:@"%@ 车况较差",str];
            break;
        //态度差
        case 8:
            self.pingjia.text=[NSString stringWithFormat:@"%@ 态度差",str];
            break;
        //对考试过关很有帮助
        case 9:
            self.pingjia.text=[NSString stringWithFormat:@"%@ 对考试过关很有帮助",str];
            break;
        default:
            break;
    }
}

//换行
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString*)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event  {
    [self.view endEditing:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
