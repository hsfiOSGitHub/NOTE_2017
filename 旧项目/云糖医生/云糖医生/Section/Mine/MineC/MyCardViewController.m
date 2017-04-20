//
//  MyCardViewController.m
//  yuntangyi
//
//  Created by yuntangyi on 16/8/30.
//  Copyright © 2016年 yuntangyi. All rights reserved.
//

#import "MyCardViewController.h"

@interface MyCardViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *erWeiCodeImageV;

@end

@implementation MyCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我的名片";
     self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"返回"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(goToBack)];
    // Do any additional setup after loading the view from its nib.
    NSString *str;
    if ( [[ZXUD objectForKey:@"activity_id"] isKindOfClass:[NSString class]] && ! [[ZXUD objectForKey:@"activity_id"] isEqualToString:@""]) {
        str = [ZXUD objectForKey:@"activity_id"];
    }else {
        str = @"0";
    }
    self.erWeiCodeImageV.image = [UIImage imageOfQRFromURL:[NSString stringWithFormat:@"%@,%@", [ZXUD objectForKey:@"ids"], @"0"]];
}
- (void)goToBack {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:20],NSForegroundColorAttributeName:KRGB(0, 172, 204, 1.0)}];
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
