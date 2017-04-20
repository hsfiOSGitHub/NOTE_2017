
//
//  NextViewController.m
//  自定义导航
//
//  Created by 可可家里 on 2017/4/7.
//  Copyright © 2017年 可可家里. All rights reserved.
//

#import "NextViewController.h"
#import "NextTViewController.h"
@interface NextViewController ()



@end

@implementation NextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
}
- (IBAction)pushNextViewController:(id)sender {
    
    NextTViewController * homeViewController=[[NextTViewController alloc] init];
    [self.navigationController pushViewController:homeViewController animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation
 in a storyboard -based application， you will often want to da a little preparation before  

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
