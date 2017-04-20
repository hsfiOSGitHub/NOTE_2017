//
//  ANBlurredImageView.h
//
//  Created by Aaron Ng on 1/4/14.
//  Copyright (c) 2014 Delve. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ANBlurredImageView : UIImageView

/**
 Our base image, stored because we replace self.image when blurring in and out.
 需要模糊化的图片 这里不要设置，请直接设置image属性，这个不要设置
 */
@property (strong, nonatomic) UIImage *baseImage;


/**
 The array of blurred images to cycle through.
 模糊化的顺序图片 不建议用户访问
 */
@property (strong) NSMutableArray *framesArray;

/**
 A reversed version of framesArray. Populates by inserting at 0 each time the normal framesArray is generated.
 模糊化的逆序图片 不建议用户访问
 */
@property (strong) NSMutableArray *framesReverseArray;

/**
 Number of frames, default value is 5. Increasing this can cause your app to have huge memory issues. Lower is better, especially when dealing with really fast animations. Nobody will notice!
 *缓存模糊渐变过程中的帧总数，越大越占内存，默认是5帧
 */
@property (assign) NSInteger framesCount;

/**
 The blur amount. Default amount is 0.1f A CGFloat from 0.0f to 1.0f.
  *模糊比例，默认为0.1，即低度模糊，范围（0.1-0.9）
 */
@property (nonatomic) CGFloat blurAmount;

/**
 The blur's tint color. Fades the tint in with the blur. Set the alpha as the final blur alpha.
 *蒙版颜色，同时在这里可控制透明度
 */
@property (strong) UIColor *blurTintColor;


/**
 Regenerates your frames. Only call this manually when absolutely necessary, since all frames are already pre-calculated on load. This doubles the amount of work but is necessary if the values aren't configured immediately on load.
 渐变实现  不建议用户访问
 */
-(void)generateBlurFramesWithCompletion:(void(^)())completion;

/**
 Blur in your image with the specificed duration. blurAmount isn't settable here because the frames need to be preloaded. Blur is set in a background thread, if blur isn't ready then nothing happens.
 @param duration A specified duration in a float.
 模糊化过程
 */
-(void)blurInAnimationWithDuration:(CGFloat)duration;


/**
 Blur out your image with the specificed duration. blurAmount isn't settable here because the frames need to be preloaded. Blur is set in a background thread, if blur isn't ready then nothing happens.
 @param duration A specified duration in a float.
 清晰化过程
 */
-(void)blurOutAnimationWithDuration:(CGFloat)duration;


/**
 Blur in an image with a duration and a callback.
 @param duration A specified duration in a float.
 @param completion A codeblock timed to the single-run animationTime.
 模糊化过程+完成后执行block
 */
-(void)blurInAnimationWithDuration:(CGFloat)duration completion:(void(^)())completion;


/**
 Blur out an image with a duration and a callback.
 @param duration A specified duration in a float.
 @param completion A codeblock timed to the single-run animationTime.
 模糊化过程+完成后执行block
 */
-(void)blurOutAnimatioxnWithDuration:(CGFloat)duration completion:(void(^)())completion;


/**这四个函数是模糊化的显示和清晰化的显示，最后一个是内存清除，当内存不足时，可以调用来清除内存，在下次动画展现时就需要生成模糊化图片了。若不删除则不需要创建直接展示
 */
-(void)blurredImageViewDefault;
-(void)blurredImageViewOutConfigDefault;
-(void)blurredImageViewInConfigWithBlurAmount:(NSInteger)blurAmount showTime:(CGFloat)time;
-(void)blurredImageFinishAnimation;


-(UIImage *)blurredLastestImage;
-(ANBlurredImageView *)initWithBlurAmount:(CGFloat)amount withTintColor:(UIColor *)color;

@end
