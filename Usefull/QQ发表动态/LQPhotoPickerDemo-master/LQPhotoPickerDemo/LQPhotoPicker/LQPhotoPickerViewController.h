//
//  LQPhotoPickerViewController.h
//  LQPhotoPicker
//
//  Created by lawchat on 15/9/22.
//  Copyright (c) 2015年 Fillinse. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol LQPhotoPickerViewDelegate <NSObject>

@optional
- (void)LQPhotoPicker_pickerViewFrameChanged;

@end

@interface LQPhotoPickerViewController : UIViewController

@property(nonatomic,assign) id<LQPhotoPickerViewDelegate> LQPhotoPicker_delegate;

//选择的图片数据(ALAsset)
@property(nonatomic,strong) NSMutableArray *LQPhotoPicker_selectedAssetArray;

//方形压缩图image 数组
@property(nonatomic,strong) NSMutableArray * LQPhotoPicker_smallImageArray;
//方形压缩图data 数组
@property(nonatomic,strong,readonly) NSMutableArray * LQPhotoPicker_smallDataImageArray;

//大图image 数组
@property(nonatomic,strong) NSMutableArray * LQPhotoPicker_bigImageArray;
//大图data 数组
@property(nonatomic,strong,readonly) NSMutableArray * LQPhotoPicker_bigImgDataArray;


//pickerView所在view
@property(nonatomic,strong) UIView *LQPhotoPicker_superView;

//图片总数量限制
@property(nonatomic,assign) NSInteger LQPhotoPicker_imgMaxCount;


//初始化collectionView
- (void)LQPhotoPicker_initPickerView;
//修改collectionView 的位置
- (void)LQPhotoPicker_updatePickerViewFrameY:(CGFloat)Y;
//获得collectionView 的 Frame
- (CGRect)LQPhotoPicker_getPickerViewFrame;

//获取选中的所有图片信息
- (NSMutableArray*)LQPhotoPicker_getSmallImageArray;
- (NSMutableArray*)LQPhotoPicker_getSmallDataImageArray;
- (NSMutableArray*)LQPhotoPicker_getBigImageArray;
- (NSMutableArray*)LQPhotoPicker_getBigImageDataArray;
- (NSMutableArray*)LQPhotoPicker_getALAssetArray;

@end
