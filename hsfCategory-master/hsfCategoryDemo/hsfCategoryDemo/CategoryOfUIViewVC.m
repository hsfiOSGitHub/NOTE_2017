//
//  CategoryOfUIViewVC.m
//  hsfCategoryDemo
//
//  Created by monkey2016 on 17/2/24.
//  Copyright © 2017年 monkey2016. All rights reserved.
//

#import "CategoryOfUIViewVC.h"

#import "UIView+border.h"
#import "UIView+flag.h"
#import "UIControl+recurClick.h"//解决重复点击问题
#import "UIView+motionEffect.h"

@interface CategoryOfUIViewVC ()
@property (weak, nonatomic) IBOutlet UIView *testView;
@property (weak, nonatomic) IBOutlet UILabel *testViewTitle;
@property (weak, nonatomic) IBOutlet UIButton *testBtn;
@property (weak, nonatomic) IBOutlet UILabel *testLabel;

@end

@implementation CategoryOfUIViewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"CategoryOfUIViewVC";
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    // UIView+border
    [self.testView setBorderWithBorderWidth:10 borderColor:[UIColor redColor] cornerRadius:10];
    [self.testBtn setBorderWithBorderWidth:5 borderColor:[UIColor darkGrayColor] cornerRadius:10];
    [self.testLabel setBorderWithBorderWidth:1 borderColor:[UIColor lightGrayColor] cornerRadius:10];
    
    // UIView+flag
    self.testView.flag = @"testView";
    self.testBtn.flag = @"testBtn";
    self.testLabel.flag = @"testLabel";
    
    //解决重复点击问题
    self.testBtn.uxy_acceptEventInterval = 3.0;
    [self.testBtn addTarget:self action:@selector(testBtnACTION:) forControlEvents:UIControlEventTouchUpInside];

}
-(void)testBtnACTION:(UIButton *)sender{
    NSLog(@"点击了testBtn");
}

- (IBAction)getFlag:(UIButton *)sender {
    
    sender.backgroundColor = [UIColor lightGrayColor];
    sender.userInteractionEnabled = NO;
    self.testViewTitle.text = [NSString stringWithFormat:@"flag: %@",self.testView.flag];
    [self.testBtn setTitle:[NSString stringWithFormat:@"flag: %@",self.testBtn.flag] forState:UIControlStateNormal];
    self.testLabel.text = [NSString stringWithFormat:@"flag: %@",self.testLabel.flag];
    //还原
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.testViewTitle.text = @"View";
        [self.testBtn setTitle:@"Button" forState:UIControlStateNormal];
        self.testLabel.text = @"Label";
        
        sender.backgroundColor = [UIColor colorWithRed:65/255.0 green:174/255.0 blue:152/255.0 alpha:1];
        sender.userInteractionEnabled = YES;
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
