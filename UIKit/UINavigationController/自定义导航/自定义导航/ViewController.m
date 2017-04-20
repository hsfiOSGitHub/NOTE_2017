//
//  ViewController.m
//  自定义导航
//
//  Created by 可可家里 on 2017/4/7.
//  Copyright © 2017年 可可家里. All rights reserved.
//

#import "ViewController.h"
#import "NextViewController.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor =[UIColor whiteColor];
    
    // Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)pushNextViewController:(id)sender {
    UIStoryboard * s =[UIStoryboard storyboardWithName:@"Home" bundle:[NSBundle mainBundle]];
    
    NextViewController * homeViewController=[s instantiateViewControllerWithIdentifier:@"next"];
    [self.navigationController pushViewController:homeViewController animated:YES];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
