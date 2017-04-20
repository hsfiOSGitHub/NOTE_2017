//
//  UMComConstraintCache.h
//  UMCommunity
//
//  Created by wyq.Cloudayc on 5/26/16.
//  Copyright © 2016 Umeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UMComConstraintCache : NSObject

@property (nonatomic, strong, nonnull) NSArray<__kindof NSLayoutConstraint *> *constraints;
@property (nonatomic, strong, nonnull) NSArray<__kindof NSLayoutConstraint *> *superConstraints;
@property (nonatomic, strong, nonnull) NSArray<__kindof UMComConstraintCache *> *subviewsCache;
@property (nonatomic, strong, nonnull) UIView *superView;
@property (nonatomic, strong, nonnull) UIView *view;

@end


@interface UMComConstraintCacheManager : NSObject

@property (nonatomic, strong, nonnull) NSMutableDictionary* cacheContainer;
@property (nonatomic, assign) BOOL alwaysCache;

- (BOOL)cacheViewConstraints:(UIView * _Nonnull)view forKey:(NSString * _Nonnull)key;

- (BOOL)restoreViewConstraintsToSuperView:(UIView * _Nonnull)view forKey:(NSString * _Nonnull)key;

@end
