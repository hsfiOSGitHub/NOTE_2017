//
//  ViewController.m
//  AYMenuList
//
//  Created by Andy on 2017/4/26.
//  Copyright © 2017年 Andy. All rights reserved.
//

#import "ViewController.h"
#import "AYMenuItem.h"
#import "AYMenuData.h"
#import "AYMenuView.h"

@interface ViewController ()<AYMenuViewDelegate>


@property (nonatomic , strong)NSMutableArray *dataArray;



@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    AYMenuView *munuView = [[AYMenuView alloc] initWithFrame:CGRectMake(0, 10, self.view.frame.size.width, self.view.frame.size.height - 10)];
    munuView.delegate = self;
    [self.view addSubview:munuView];
    
    _dataArray = [NSMutableArray array];
    
    for (int i = 0 ; i < 5; i++) {
        AYMenuItem *rootItem = [[AYMenuItem alloc] init];
        rootItem.title = [NSString stringWithFormat:@"第一级菜单：%d",i];
        rootItem.level = 1;
        rootItem.isSubCascadeOpen = NO;
        rootItem.isSubItemsOpen = NO;
        NSMutableArray *subArray = [NSMutableArray array];
        for (int j = 0; j < 7 ; j++) {
            AYMenuItem *item = [[AYMenuItem alloc] init];
            item.title = [NSString stringWithFormat:@"第二级菜单：%d",j];
            item.level = 2;
            item.isSubCascadeOpen = NO;
            item.isSubItemsOpen = NO;
           
            NSMutableArray *level3Arr = [NSMutableArray array];
            for (int k = 0; k < 7 ; k++) {
                AYMenuItem *item3 = [[AYMenuItem alloc] init];
                item3.title = [NSString stringWithFormat:@"第三级菜单：%d",k];
                item3.level = 3;
                item3.subItems = nil;
                item3.isSubCascadeOpen = NO;
                item3.isSubItemsOpen = NO;
                [level3Arr addObject:item3];
            }
            item.subItems = [level3Arr copy];
            [subArray addObject:item];

        }
        rootItem.subItems = [subArray copy];
        
        [_dataArray addObject:rootItem];
    }
    
}

#pragma mark -AYMenuViewDelegate
-(void)ay_menuView:(AYMenuView *)menuView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"XXXXXXXXX%@",indexPath);
}

- (void)ay_menuView:(AYMenuView *)menuView didDeselectRowAtIndexPath:(NSIndexPath *)indexPaths{
    NSLog(@"======%@",indexPaths);
}

- (NSMutableArray *)ay_dataArrayInMenuView:(AYMenuView *)menuView{
    return self.dataArray;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
