//
//  ZHScanView.m
//  sasasas
//
//  Created by WZH on 16/3/8.
//  Copyright © 2016年 lyj. All rights reserved.
//



#define ScreenHight self.frame.size.height
#define ScreenWidth self.frame.size.width

#import "ZHScanView.h"
#import <AVFoundation/AVFoundation.h>

@interface ZHScanView()<AVCaptureMetadataOutputObjectsDelegate>
{
    int _num;
    BOOL _upOrdown;
    NSTimer * _timer;
    
}

@property (nonatomic, copy) resultBlock outresult;

@property ( strong , nonatomic ) AVCaptureDevice * device;
@property ( strong , nonatomic ) AVCaptureDeviceInput * input;
@property ( strong , nonatomic ) AVCaptureMetadataOutput * output;
@property ( strong , nonatomic ) AVCaptureSession * session;
@property ( strong , nonatomic ) AVCaptureVideoPreviewLayer * preview;

@property (nonatomic, retain) UIImageView *line;
@property (nonatomic, weak) UIImageView *codeIV;
@property (nonatomic, weak) UILabel *promptLabel;

@end

@implementation ZHScanView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        UIImageView *codeIV = [[UIImageView alloc]init];
        codeIV.userInteractionEnabled = YES;
        codeIV.image = [UIImage imageNamed:@"scan.png"];
        [self addSubview:codeIV];
        self.codeIV = codeIV;
        
        UILabel *label = [[UILabel alloc]init];
        label.font = [UIFont systemFontOfSize:16];
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];
        self.promptLabel = label;
        
        UIImageView *line = [[UIImageView alloc] init];
        line.image = [UIImage imageNamed:@"scan_1.png"];
        [self addSubview:line];
        self.line = line;
        
        _upOrdown = NO;
        _num =0;
        
    }
    
    return self;
}
#pragma mark --------------------------publicFunc-----------------------------------------
+(instancetype)scanView
{
    ZHScanView *scanView = [[ZHScanView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
    
    return scanView;
}

+(instancetype)scanViewWithFrame:(CGRect)frame
{
    ZHScanView *scanView = [[ZHScanView alloc] initWithFrame:frame];
    
    return scanView;
}

- (void)startScaning
{
    [self startcScanningQrcord];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:.02 target:self selector:@selector(scanAnimation) userInfo:nil repeats:YES];
}

- (void)outPutResult:(resultBlock)result
{
    self.outresult = result;
}
#pragma mark --------------------------setter----------------------------------------
/**
 *  setter
 */
- (void)setPromptMessage:(NSString *)promptMessage
{
    _promptMessage = promptMessage;
    
    _promptLabel.text = promptMessage;
    
}


#pragma mark --------------------------privateFunc-----------------------------------------

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat codeIVh = ScanWidth;
    CGFloat codeIVw = codeIVh;
    CGFloat codeIVx = (ScreenWidth - codeIVw)/2;
    CGFloat codeIVy = ScanY;
    self.codeIV.frame = CGRectMake(0, 0, codeIVw, codeIVh);
    self.codeIV.center = CGPointMake(KScreenWidth / 2, KScreenHeight / 2);
    
    CGFloat labelx = 20;
    CGFloat labely = CGRectGetMaxY(self.codeIV.frame) + 20;
    CGFloat labelw = ScreenWidth - 2*labelx;
    NSDictionary *attrs = @{NSFontAttributeName : self.promptLabel.font};
    CGFloat labelh = [self.promptLabel.text boundingRectWithSize:CGSizeMake(labelw, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size.height;
    self.promptLabel.frame = CGRectMake(labelx, labely, labelw, labelh);
    
    CGFloat linex = codeIVx;
    CGFloat liney = codeIVy;
    CGFloat linew = codeIVw;
    CGFloat lineh = 3;
    self.line.frame = CGRectMake(linex, liney, linew, lineh);
    
}

//开始扫描二维码
-(void)startcScanningQrcord{
    // Device
    _device = [ AVCaptureDevice defaultDeviceWithMediaType: AVMediaTypeVideo];
    // Input
    _input = [ AVCaptureDeviceInput deviceInputWithDevice : self .device error : nil ];
    if (_input == nil) {
        UIAlertView *aler = [[UIAlertView alloc] initWithTitle:@"提示" message:@"设备不可用" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [self addSubview:aler];
        [aler show];
        return;
    }
    
    // Output
    _output = [[ AVCaptureMetadataOutput alloc ] init ];
    [ _output setMetadataObjectsDelegate : self queue : dispatch_get_main_queue ()];
    _output.rectOfInterest= CGRectMake(ScanY/ScreenHight,(ScreenWidth - ScanWidth)/(2*ScreenWidth),ScanWidth/ScreenHight, ScanWidth/ScreenWidth);
    /**
    rectOfInterest （0，0，1，1）按照比例来的
    （y/self.height,x/self.width,height/self.height,width/self.height）
     （y,x,h,w）至于为什么这样  苹果规定  - -！！！ 
     */
    // Session
    _session = [[ AVCaptureSession alloc ] init ];
    [ _session setSessionPreset : AVCaptureSessionPresetHigh ];
    if ([ _session canAddInput : self . input ])
    {
        [ _session addInput : self . input ];
    }
    if ([ _session canAddOutput : self . output ])
    {
        [ _session addOutput : self . output ];
    }
    
    // 条码类型 AVMetadataObjectTypeQRCode
    _output . metadataObjectTypes = [NSArray arrayWithObject:AVMetadataObjectTypeQRCode];
    // Preview
    _preview =[ AVCaptureVideoPreviewLayer layerWithSession : _session ];
    _preview.frame = CGRectMake(0, 0, ScreenWidth, ScreenHight);
    _preview . videoGravity = AVLayerVideoGravityResizeAspectFill ;
    [self.layer insertSublayer:_preview atIndex:0];
    
    //    最上部view
    UIView* upView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth,ScanY)];//80
    upView.alpha = 0.5;
    upView.backgroundColor = [UIColor blackColor];
    [self addSubview:upView];
    //左侧的view
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(upView.frame),(ScreenWidth - ScanWidth)/2,ScreenHight - ScanY)];
    leftView.alpha = 0.5;
    leftView.backgroundColor = [UIColor blackColor];
    [self addSubview:leftView];
    
    //右侧的view
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(leftView.frame)+ScanWidth, CGRectGetMaxY(upView.frame), (ScreenWidth - ScanWidth)/2, ScreenHight - ScanY)];
    rightView.alpha = 0.5;
    rightView.backgroundColor = [UIColor blackColor];
    [self addSubview:rightView];
    
    //底部view
    UIView *downView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(leftView.frame),  ScanY + ScanWidth , ScreenWidth-CGRectGetWidth(leftView.frame) * 2, ScreenHight -ScanY - ScanWidth)];
    downView.alpha = 0.5;
    downView.backgroundColor = [UIColor blackColor];
    [self addSubview:downView];
    
    [_session startRunning];
    
}

#pragma mark - 扫描动画
-(void)scanAnimation
{
    if (_upOrdown == NO) {
        _num ++;
        _line.frame = CGRectMake((ScreenWidth - ScanWidth)/2, ScanY + 2*_num, ScanWidth, 3);
        if ((2*_num == ScanWidth )||(2*_num == ScanWidth-1)) {
            _upOrdown = YES;
        }
    }
    else {
        _num --;
        _line.frame = CGRectMake((ScreenWidth - ScanWidth)/2, ScanY+ScanWidth-2*_num, ScanWidth, 3);
        if (_num == 0) {
            _upOrdown = NO;
        }
    }
}

#pragma mark 输出
- ( void )captureOutput:( AVCaptureOutput *)captureOutput didOutputMetadataObjects:( NSArray *)metadataObjects fromConnection:( AVCaptureConnection *)connection
{
    NSString *stringValue;
    if ([metadataObjects count ] > 0 )
    {
        // 停止扫描
        [ _session stopRunning];
        AVMetadataMachineReadableCodeObject *metadataObject = [metadataObjects objectAtIndex : 0 ];
        stringValue = metadataObject.stringValue ;
        
        if (self.outresult) {
            self.outresult(stringValue);
            
        }
    }
}
@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com