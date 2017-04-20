//
//  ScreenShotVC.m
//  hsfCategoryDemo
//
//  Created by monkey2016 on 17/2/24.
//  Copyright © 2017年 monkey2016. All rights reserved.
//

#import "ScreenShotVC.h"

#import "ImgResultVC.h"
#import "UIView+screenshot.h"

@interface ScreenShotVC ()
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UIButton *screenshotBtn;

@end

@implementation ScreenShotVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"UIView+screenshot";
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
}
- (IBAction)screenshotBtnACTION:(id)sender {
    
    ImgResultVC *imgResult_VC = [[ImgResultVC alloc]init];
    UIImage *image = [self.view screenshot];   //关键在这
    imgResult_VC.image = image;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self presentViewController:imgResult_VC animated:YES completion:nil];
    });
    
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
