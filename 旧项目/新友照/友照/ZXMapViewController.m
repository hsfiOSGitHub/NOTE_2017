//
//  ZXMapViewController.m
//  ZXJiaXiao
//
//  Created by yummy on 16/3/15.
//  Copyright © 2016年 ZX. All rights reserved.
//

#import "ZXMapViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>


@interface ZXMapViewController ()<MKMapViewDelegate>

@property(nonnull,strong) MKMapView *mapView;
@property(nonatomic)double haha;
@property(nonatomic)double enen;

@end

@implementation ZXMapViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=self.schoolName;
    _mapView=[[MKMapView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
    _mapView.mapType=MKMapTypeStandard;
    _mapView.delegate=self;
    [self.view addSubview:_mapView];
    [self bd_decrypt:[self.locations[0] doubleValue] and:[self.locations[1] doubleValue]];

    //添加大头针
    [self addAnnotation];

}
-(void) bd_decrypt:(double) bd_lat and:(double) bd_lon
{
    double x_pi = 3.14159265358979324 * 3000.0 / 180.0;
    double x = bd_lon - 0.0065, y = bd_lat - 0.006;
    double z = sqrt(x * x + y * y) - 0.00002 * sin(y * x_pi);
    double theta = atan2(y, x) - 0.000003 * cos(x * x_pi);
    _haha = z * cos(theta);
    _enen = z * sin(theta);
    
}
#pragma mark 添加大头针


-(void)addAnnotation{
    
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    annotation.coordinate = CLLocationCoordinate2DMake(_haha,_enen);
    annotation.title =self.schoolName;
    annotation.subtitle = self.deatilInfo;
    //指定新的显示区域
    [self.mapView setRegion:MKCoordinateRegionMake(CLLocationCoordinate2DMake(_haha,_enen), MKCoordinateSpanMake(0.01, 0.01)) animated:YES];
    //设置中心点
    [_mapView setCenterCoordinate: CLLocationCoordinate2DMake(_haha,_enen) animated:YES];
    //添加大头针
    [_mapView addAnnotation:annotation];
    // 选中标注
    [self.mapView selectAnnotation:annotation animated:YES];
    
}

@end
