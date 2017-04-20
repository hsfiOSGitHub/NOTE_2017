//
//  UMComLocationTableViewController1.m
//  UMCommunity
//
//  Created by umeng on 15/8/7.
//  Copyright (c) 2015年 Umeng. All rights reserved.
//

#import "UMComLocationListController.h"
#import <CoreLocation/CoreLocation.h>
#import "UMComLocationTableViewCell.h"
#import "UMComShowToast.h"
#import <UMComFoundation/UMUtils.h>
#import "UIViewController+UMComAddition.h"
#import <UMComDataStorage/UMComLocation.h>
#import "UMComLocationListDataController.h"
#import <UMComFoundation/UMComKit+Color.h>


@interface UMComLocationListController ()<CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLLocation *location;

@property (nonatomic, copy) void (^complectionBlock)(UMComLocation *locationModel);

@property(nonatomic,strong)UMComLocationListDataController* locationListDataController;

@end

@implementation UMComLocationListController
- (void)viewDidLoad {
    [super viewDidLoad];
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusRestricted
        || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
        [[[UIAlertView alloc] initWithTitle:nil message:UMComLocalizedString(@"um_com_location_authority_prompt",@"此应用程序没有权限访问地理位置信息，请在隐私设置里启用") delegate:nil cancelButtonTitle:UMComLocalizedString(@"um_com_ok", @"好的") otherButtonTitles:nil, nil] show];
    }
    if (NO==[CLLocationManager locationServicesEnabled]) {
        UMLog(@"---------- 未开启定位");
    }
    [self setTitleViewWithTitle:UMComLocalizedString(@"um_com_myLocationTitle",@"我的位置")];
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.distanceFilter = 15.0f;
    
    [_locationManager startUpdatingLocation];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"UMComLocationTableViewCell" bundle:nil] forCellReuseIdentifier:@"LocationTableViewCell"];
    
    if (!([CLLocationManager locationServicesEnabled] == YES  && [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorized)){
        
        if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0f) {
            [self.locationManager requestAlwaysAuthorization];
        }
    }
    self.tableView.rowHeight = LocationCellHeight;
    
    self.locationListDataController = [[UMComLocationListDataController alloc] initWithCount:UMCom_Limit_Page_Count withLocation:nil];
    self.isAutoStartLoadData = NO;//该界面需要获得定位后，才触发请求
}

- (id)initWithLocationSelectedComplectionBlock:(void (^)(UMComLocation *locationModel))block
{
    self = [super init];
    if (self) {
        self.complectionBlock = block;
    }
    return self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.dataController.dataArray.count == 0) {
        return 0;
    }
    return self.dataController.dataArray.count + 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *cellIdentifier = @"LocationTableViewCell";
    UMComLocationTableViewCell *cell = (UMComLocationTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row == 0) {
        cell.locationName.center = CGPointMake(cell.locationName.center.x, tableView.rowHeight/2);
        cell.locationName.text = UMComLocalizedString(@"um_com_hideLocation", @"不显示位置");
        cell.locationDetail.hidden = YES;
        cell.locationName.textColor = UMComColorWithHexString(FontColorBlue);
    }else{
        UMComLocation *locationModel = self.dataController.dataArray[indexPath.row-1];
        cell.locationName.textColor = [UIColor blackColor];
        cell.locationName.center = CGPointMake(cell.locationName.center.x, (tableView.rowHeight-cell.locationDetail.frame.size.height)/2);
        cell.locationDetail.hidden = NO;
        [cell reloadFromLocationModel:locationModel];
    }
    return cell;
}

#pragma mark - locationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations
{
//    self.fetchRequest = [[UMComLocationRequest alloc]initWithLocation:manager.location];
//    [self refreshNewDataFromServer:nil];
    
    self.locationListDataController.location = manager.location;
    self.dataController = self.locationListDataController;
    [self refreshData];
    
    
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    [UMComShowToast fetchFailWithNoticeMessage:UMComLocalizedString(@"um_com_failToLocation",@"定位失败")];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row > 0) {
        UMComLocation *locationModel = self.dataController.dataArray[indexPath.row-1];
//        self.editViewModel.locationDescription = locationModel.name;
        if (self.complectionBlock) {
            self.complectionBlock(locationModel);
        }
    }else{
//        self.editViewModel.locationDescription = @"";
        if (self.complectionBlock) {
            self.complectionBlock(nil);
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}

@end
