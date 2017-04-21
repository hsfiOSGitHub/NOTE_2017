// For License please refer to LICENSE file in the root of YALAnimatingTabBarController project

#import <UIKit/UIKit.h>

//view
#import "YALFoldingTabBar.h"

NS_ASSUME_NONNULL_BEGIN

@interface YALFoldingTabBarController : UITabBarController

@property (nonatomic, copy) NSArray *leftBarItems;
@property (nonatomic, copy) NSArray *rightBarItems;
@property (nonatomic, strong) UIImage *centerButtonImage;

@property (nonatomic, assign) CGFloat tabBarViewHeight;

@property (nonatomic, strong) YALFoldingTabBar *tabBarView;

@end

NS_ASSUME_NONNULL_END
