//
//  UMComUserNearbyViewController.m
//  UMCommunity
//
//  Created by wyq.Cloudayc on 3/24/16.
//  Copyright © 2016 Umeng. All rights reserved.
//

#import "UMComUserNearbyViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "UIViewController+UMComAddition.h"
#import "UMComResouceDefines.h"
#import "UMComShowToast.h"
#import "UMComUserListDataController.h"
#import <UMComFoundation/UMComKit+Color.h>

@interface UMComUserNearbyViewController ()
<CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic) CLLocation* location;

@property (nonatomic, strong) UILabel *noLocationTip;

@end

@implementation UMComUserNearbyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.showDistance = YES;
    
    [self setForumUITitle:self.title];
    self.title = nil;
    if (!self.location) {
        if ([self checkNoLocationAuth]) {
//            [[[UIAlertView alloc] initWithTitle:nil message:UMComLocalizedString(@"No location",@"此应用程序没有权限访问地理位置信息，请在隐私设置里启用") delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil] show];
            
            [self showNoLocationAuthTip];
        }
        if (NO==[CLLocationManager locationServicesEnabled]) {
//            YZLog(@"---------- 未开启定位");
        }
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        self.locationManager.distanceFilter = 50.0f;
        
        [_locationManager startUpdatingLocation];
        
        if (!([CLLocationManager locationServicesEnabled] == YES  && [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorized)){
            
            if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0f) {
                [self.locationManager requestAlwaysAuthorization];
            }
        }
    }
    // Do any additional setup after loading the view.
    
    self.dataController = [[UMComUserNearbyDataController alloc] initWithCount:UMCom_Limit_Page_Count location:self.location];
    if (self.location) {
        self.isAutoStartLoadData = YES;
    }
    else
    {
        self.isAutoStartLoadData = NO;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)checkNoLocationAuth
{
    return ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusRestricted
            || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied);
}

- (void)showNoLocationAuthTip
{
    if (!_noLocationTip) {
        UILabel *tip = [[UILabel alloc] init];
        [tip setText:UMComLocalizedString(@"cannotGetLocation_checkGPS", @"无法获取您的位置信息\n请检查GPS设置")];
        [tip setTextColor:UMComColorWithHexString(@"#A5A5A5")];
        [tip setFont:[UIFont systemFontOfSize:15.f]];
        tip.numberOfLines = 2;
        tip.textAlignment = NSTextAlignmentCenter;
        CGSize tipSize = [tip.text sizeWithFont:tip.font constrainedToSize:self.view.bounds.size lineBreakMode:NSLineBreakByWordWrapping];
        [tip setFrame:CGRectMake(0.f, 0.f, tipSize.width, tipSize.height)];
        tip.center = CGPointMake(self.view.bounds.size.width / 2.f, self.view.bounds.size.height / 2.f - 50.f);
        self.noLocationTip = tip;
    }
    [self.view addSubview:_noLocationTip];
}

- (void)updateLocationAuthTip
{
    if ([self checkNoLocationAuth]) {
        [self showNoLocationAuthTip];
    } else {
        [self.noLocationTip removeFromSuperview];
    }
}

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations
{
    self.tableView.scrollEnabled = YES;
    
    ((UMComUserNearbyDataController*)self.dataController).location = manager.location;
    [self refreshData];
    
    [self updateLocationAuthTip];    
}


- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    [self.dataController.dataArray removeAllObjects];;
    [self.tableView reloadData];
    
    self.tableView.scrollEnabled = NO;
    
    [UMComShowToast fetchFailWithNoticeMessage:UMComLocalizedString(@"fail to location",@"定位失败")];
    
    [self updateLocationAuthTip];
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
