//
// UMComProgressHUD.m
// Version 0.9.2
// Created by Matej Bukovinski on 2.4.09.
//

#import "UMComProgressHUD.h"
#import <tgmath.h>


#ifndef kCFCoreFoundationVersionNumber_iOS_7_0
    #define kCFCoreFoundationVersionNumber_iOS_7_0 847.20
#endif

#ifndef kCFCoreFoundationVersionNumber_iOS_8_0
    #define kCFCoreFoundationVersionNumber_iOS_8_0 1129.15
#endif

#define UMComMainThreadAssert() NSAssert([NSThread isMainThread], @"UMComProgressHUD needs to be accessed on the main thread.");

CGFloat const UMComProgressMaxOffset = 1000000.f;

static const CGFloat UMComDefaultPadding = 4.f;
static const CGFloat UMComDefaultLabelFontSize = 16.f;
static const CGFloat UMComDefaultDetailsLabelFontSize = 12.f;


@interface UMComProgressHUD () {
    // Depricated
    UIColor *_activityIndicatorColor;
    CGFloat _opacity;
}

@property (nonatomic, assign) BOOL useAnimation;
@property (nonatomic, assign, getter=hasFinished) BOOL finished;
@property (nonatomic, strong) UIView *indicator;
@property (nonatomic, strong) NSTimer *graceTimer;
@property (nonatomic, strong) NSTimer *minShowTimer;
@property (nonatomic, strong) NSDate *showStarted;
@property (nonatomic, strong) NSArray *paddingConstraints;
@property (nonatomic, strong) NSArray *bezelConstraints;
@property (nonatomic, strong) UIView *topSpacer;
@property (nonatomic, strong) UIView *bottomSpacer;


@end


@interface UMComProgressHUDRoundedButton : UIButton
@end


@implementation UMComProgressHUD

#pragma mark - Class methods

+ (instancetype)showHUDAddedTo:(UIView *)view animated:(BOOL)animated {
    UMComProgressHUD *hud = [[self alloc] initWithView:view];
    hud.removeFromSuperViewOnHide = YES;
    [view addSubview:hud];
    [hud showAnimated:animated];
    return hud;
}

+ (BOOL)hideHUDForView:(UIView *)view animated:(BOOL)animated {
    UMComProgressHUD *hud = [self HUDForView:view];
    if (hud != nil) {
        hud.removeFromSuperViewOnHide = YES;
        [hud hideAnimated:animated];
        return YES;
    }
    return NO;
}

+ (UMComProgressHUD *)HUDForView:(UIView *)view {
    NSEnumerator *subviewsEnum = [view.subviews reverseObjectEnumerator];
    for (UIView *subview in subviewsEnum) {
        if ([subview isKindOfClass:self]) {
            return (UMComProgressHUD *)subview;
        }
    }
    return nil;
}

#pragma mark - Lifecycle

- (void)commonInit {
    // Set default values for properties
    _animationType = UMComProgressHUDAnimationFade;
    _mode = UMComProgressHUDModeIndeterminate;
    _margin = 20.0f;
    _opacity = 1.f;
    _defaultMotionEffectsEnabled = YES;

    // Default color, depending on the current iOS version
    BOOL isLegacy = kCFCoreFoundationVersionNumber < kCFCoreFoundationVersionNumber_iOS_7_0;
    _contentColor = isLegacy ? [UIColor whiteColor] : [UIColor colorWithWhite:0.f alpha:0.7f];
    // Transparent background
    self.opaque = NO;
    self.backgroundColor = [UIColor clearColor];
    // Make it invisible for now
    self.alpha = 0.0f;
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.layer.allowsGroupOpacity = NO;

    [self setupViews];
    [self updateIndicators];
    [self registerForNotifications];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super initWithCoder:aDecoder])) {
        [self commonInit];
    }
    return self;
}

- (id)initWithView:(UIView *)view {
    NSAssert(view, @"View must not be nil.");
    return [self initWithFrame:view.bounds];
}

- (void)dealloc {
    [self unregisterFromNotifications];
}

#pragma mark - Show & hide

- (void)showAnimated:(BOOL)animated {
    UMComMainThreadAssert();
    self.useAnimation = animated;
    self.finished = NO;
    // If the grace time is set postpone the HUD display
    if (self.graceTime > 0.0) {
        NSTimer *timer = [NSTimer timerWithTimeInterval:self.graceTime target:self selector:@selector(handleGraceTimer:) userInfo:nil repeats:NO];
        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
        self.graceTimer = timer;
    } 
    // ... otherwise show the HUD imediately 
    else {
        [self showUsingAnimation:self.useAnimation];
    }
}

- (void)hideAnimated:(BOOL)animated {
    UMComMainThreadAssert();
    self.useAnimation = animated;
    self.finished = YES;
    // If the minShow time is set, calculate how long the hud was shown,
    // and pospone the hiding operation if necessary
    if (self.minShowTime > 0.0 && self.showStarted) {
        NSTimeInterval interv = [[NSDate date] timeIntervalSinceDate:self.showStarted];
        if (interv < self.minShowTime) {
            NSTimer *timer = [NSTimer timerWithTimeInterval:(self.minShowTime - interv) target:self selector:@selector(handleMinShowTimer:) userInfo:nil repeats:NO];
            [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
            self.minShowTimer = timer;
            return;
        } 
    }
    // ... otherwise hide the HUD immediately
    [self hideUsingAnimation:self.useAnimation];
}

- (void)hideAnimated:(BOOL)animated afterDelay:(NSTimeInterval)delay {
    [self performSelector:@selector(hideDelayed:) withObject:[NSNumber numberWithBool:animated] afterDelay:delay];
}

- (void)hideDelayed:(NSNumber *)animated {
    [self hideAnimated:[animated boolValue]];
}

#pragma mark - Timer callbacks

- (void)handleGraceTimer:(NSTimer *)theTimer {
    // Show the HUD only if the task is still running
    if (!self.hasFinished) {
        [self showUsingAnimation:self.useAnimation];
    }
}

- (void)handleMinShowTimer:(NSTimer *)theTimer {
    [self hideUsingAnimation:self.useAnimation];
}

#pragma mark - View Hierrarchy

- (void)didMoveToSuperview {
    [self updateForCurrentOrientationAnimated:NO];
}

#pragma mark - Internal show & hide operations

- (void)showUsingAnimation:(BOOL)animated {
    // Cancel any scheduled hideDelayed: calls
    [NSObject cancelPreviousPerformRequestsWithTarget:self];

    self.showStarted = [NSDate date];
    self.alpha = 1.f;

    if (animated) {
        [self animateIn:YES withType:self.animationType completion:NULL];
    } else {
        self.backgroundView.alpha = 1.f;
    }
}

- (void)hideUsingAnimation:(BOOL)animated {
    if (animated && self.showStarted) {
        [self animateIn:NO withType:self.animationType completion:^(BOOL finished) {
            [self done];
        }];
    } else {
        self.bezelView.alpha = 0.f;
        self.backgroundView.alpha = 1.f;
        [self done];
    }
    self.showStarted = nil;
}

- (void)animateIn:(BOOL)animatingIn withType:(UMComProgressHUDAnimation)type completion:(void(^)(BOOL finished))completion {
    // Automatically determine the correct
    if (type == UMComProgressHUDAnimationZoom) {
        type = animatingIn ? UMComProgressHUDAnimationZoomIn : UMComProgressHUDAnimationZoomOut;
    }

    CGAffineTransform small = CGAffineTransformMakeScale(0.5f, 0.5f);
    CGAffineTransform large = CGAffineTransformMakeScale(1.5f, 1.5f);

    // Set starting state
    UIView *bezelView = self.bezelView;
    if (animatingIn && bezelView.alpha == 0.f && type == UMComProgressHUDAnimationZoomIn) {
        bezelView.transform = small;
    } else if (animatingIn && bezelView.alpha == 0.f && type == UMComProgressHUDAnimationZoomOut) {
        bezelView.transform = large;
    }

    // Perform animations
    dispatch_block_t animations = ^{
        if (animatingIn) {
            bezelView.transform = CGAffineTransformIdentity;
        } else if (!animatingIn && type == UMComProgressHUDAnimationZoomIn) {
            bezelView.transform = large;
        } else if (!animatingIn && type == UMComProgressHUDAnimationZoomOut) {
            bezelView.transform = small;
        }
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        bezelView.alpha = animatingIn ? _opacity : 0.f;
#pragma clang diagnostic pop
        self.backgroundView.alpha = animatingIn ? 1.f : 0.f;
    };

    // Spring animations are nicer, but only available on iOS 7+
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
    if (kCFCoreFoundationVersionNumber >= kCFCoreFoundationVersionNumber_iOS_7_0) {
        [UIView animateWithDuration:0.3 delay:0. usingSpringWithDamping:1.f initialSpringVelocity:0.f options:UIViewAnimationOptionBeginFromCurrentState animations:animations completion:completion];
        return;
    }
#endif
    [UIView animateWithDuration:0.3 delay:0. options:UIViewAnimationOptionBeginFromCurrentState animations:animations completion:completion];
}

- (void)done {
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    self.alpha = 0.0f;
    if (self.removeFromSuperViewOnHide) {
        [self removeFromSuperview];
    }

    id<UMComProgressHUDDelegate> delegate = self.delegate;
    if ([delegate respondsToSelector:@selector(hudWasHidden:)]) {
        [delegate performSelector:@selector(hudWasHidden:) withObject:self];
    }
}

#pragma mark - UI

- (void)setupViews {
    UIColor *defaultColor = self.contentColor;

    UMComBackgroundView *backgroundView = [[UMComBackgroundView alloc] initWithFrame:self.bounds];
    backgroundView.style = UMComProgressHUDBackgroundStyleSolidColor;
    backgroundView.backgroundColor = [UIColor clearColor];
    backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    backgroundView.alpha = 0.f;
    [self addSubview:backgroundView];
    _backgroundView = backgroundView;

    UMComBackgroundView *bezelView = [UMComBackgroundView new];
    bezelView.translatesAutoresizingMaskIntoConstraints = NO;
    bezelView.layer.cornerRadius = 5.f;
    bezelView.alpha = 0.f;
    [self addSubview:bezelView];
    _bezelView = bezelView;
    [self updateBezelMotionEffects];

    UILabel *label = [UILabel new];
    label.adjustsFontSizeToFitWidth = NO;
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = defaultColor;
    label.font = [UIFont boldSystemFontOfSize:UMComDefaultLabelFontSize];;
    _label = label;

    UILabel *detailsLabel = [UILabel new];
    detailsLabel.adjustsFontSizeToFitWidth = NO;
    detailsLabel.textAlignment = NSTextAlignmentCenter;
    detailsLabel.textColor = defaultColor;
    detailsLabel.numberOfLines = 0;
    detailsLabel.font = [UIFont boldSystemFontOfSize:UMComDefaultDetailsLabelFontSize];
    _detailsLabel = detailsLabel;

    UIButton *button = [UMComProgressHUDRoundedButton buttonWithType:UIButtonTypeCustom];
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    button.titleLabel.font = [UIFont boldSystemFontOfSize:UMComDefaultDetailsLabelFontSize];
    [button setTitleColor:defaultColor forState:UIControlStateNormal];
    _button = button;

    for (UIView *view in @[label, detailsLabel, button]) {
        view.translatesAutoresizingMaskIntoConstraints = NO;
        [view setContentCompressionResistancePriority:998.f forAxis:UILayoutConstraintAxisHorizontal];
        [view setContentCompressionResistancePriority:998.f forAxis:UILayoutConstraintAxisVertical];
        [bezelView addSubview:view];
    }

    UIView *topSpacer = [UIView new];
    topSpacer.translatesAutoresizingMaskIntoConstraints = NO;
    topSpacer.hidden = YES;
    [bezelView addSubview:topSpacer];
    _topSpacer = topSpacer;

    UIView *bottomSpacer = [UIView new];
    bottomSpacer.translatesAutoresizingMaskIntoConstraints = NO;
    bottomSpacer.hidden = YES;
    [bezelView addSubview:bottomSpacer];
    _bottomSpacer = bottomSpacer;
}

- (void)updateIndicators {
    UIView *indicator = self.indicator;
    BOOL isActivityIndicator = [indicator isKindOfClass:[UIActivityIndicatorView class]];
    BOOL isRoundIndicator = [indicator isKindOfClass:[UMComRoundProgressView class]];

    UMComProgressHUDMode mode = self.mode;
    if (mode == UMComProgressHUDModeIndeterminate) {
        if (!isActivityIndicator) {
            // Update to indeterminate indicator
            [indicator removeFromSuperview];
            indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
            [(UIActivityIndicatorView *)indicator startAnimating];
            [self.bezelView addSubview:indicator];
        }
    }
    else if (mode == UMComProgressHUDModeDeterminateHorizontalBar) {
        // Update to bar determinate indicator
        [indicator removeFromSuperview];
        indicator = [[UMComBarProgressView alloc] init];
        [self.bezelView addSubview:indicator];
    }
    else if (mode == UMComProgressHUDModeDeterminate || mode == UMComProgressHUDModeAnnularDeterminate) {
        if (!isRoundIndicator) {
            // Update to determinante indicator
            [indicator removeFromSuperview];
            indicator = [[UMComRoundProgressView alloc] init];
            [self.bezelView addSubview:indicator];
        }
        if (mode == UMComProgressHUDModeAnnularDeterminate) {
            [(UMComRoundProgressView *)indicator setAnnular:YES];
        }
    } 
    else if (mode == UMComProgressHUDModeCustomView && self.customView != indicator) {
        // Update custom view indicator
        [indicator removeFromSuperview];
        indicator = self.customView;
        [self.bezelView addSubview:indicator];
    }
    else if (mode == UMComProgressHUDModeText) {
        [indicator removeFromSuperview];
        indicator = nil;
    }
    indicator.translatesAutoresizingMaskIntoConstraints = NO;
    self.indicator = indicator;

    if ([indicator respondsToSelector:@selector(setProgress:)]) {
        [(id)indicator setValue:@(self.progress) forKey:@"progress"];
    }

    [indicator setContentCompressionResistancePriority:998.f forAxis:UILayoutConstraintAxisHorizontal];
    [indicator setContentCompressionResistancePriority:998.f forAxis:UILayoutConstraintAxisVertical];

    [self updateViewsForColor:self.contentColor];
    [self setNeedsUpdateConstraints];
}

- (void)updateViewsForColor:(UIColor *)color {
    if (!color) return;

    self.label.textColor = color;
    self.detailsLabel.textColor = color;
    [self.button setTitleColor:color forState:UIControlStateNormal];

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
//    if (self.activityIndicatorColor) {
//        color = self.activityIndicatorColor;
//    }
#pragma clang diagnostic pop

    UIView *indicator = self.indicator;
    if ([indicator isKindOfClass:[UIActivityIndicatorView class]]) {
        ((UIActivityIndicatorView *)indicator).color = color;
    } else if ([indicator isKindOfClass:[UMComRoundProgressView class]]) {
        ((UMComRoundProgressView *)indicator).progressTintColor = color;
        ((UMComRoundProgressView *)indicator).backgroundTintColor = [color colorWithAlphaComponent:0.1];
    } else if ([indicator isKindOfClass:[UMComBarProgressView class]]) {
        ((UMComBarProgressView *)indicator).progressColor = color;
        ((UMComBarProgressView *)indicator).lineColor = color;
    } else {
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
        if ([indicator respondsToSelector:@selector(setTintColor:)]) {
            [indicator setTintColor:color];
        }
#endif
    }
}

- (void)updateBezelMotionEffects {
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
    UMComBackgroundView *bezelView = self.bezelView;
    if (![bezelView respondsToSelector:@selector(addMotionEffect:)]) return;

    if (self.defaultMotionEffectsEnabled) {
        CGFloat effectOffset = 10.f;
        UIInterpolatingMotionEffect *effectX = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.x" type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
        effectX.maximumRelativeValue = @(effectOffset);
        effectX.minimumRelativeValue = @(-effectOffset);

        UIInterpolatingMotionEffect *effectY = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.y" type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
        effectY.maximumRelativeValue = @(effectOffset);
        effectY.minimumRelativeValue = @(-effectOffset);

        UIMotionEffectGroup *group = [[UIMotionEffectGroup alloc] init];
        group.motionEffects = @[effectX, effectY];

        [bezelView addMotionEffect:group];
    } else {
        NSArray *effects = [bezelView motionEffects];
        for (UIMotionEffect *effect in effects) {
            [bezelView removeMotionEffect:effect];
        }
    }
#endif
}

#pragma mark - Layout

- (void)updateConstraints {
    UIView *bezel = self.bezelView;
    UIView *topSpacer = self.topSpacer;
    UIView *bottomSpacer = self.bottomSpacer;
    CGFloat margin = self.margin;
    NSMutableArray *bezelConstraints = [NSMutableArray array];
    NSDictionary *metrics = @{@"margin": @(margin)};

    NSMutableArray *subviews = [NSMutableArray arrayWithObjects:self.topSpacer, self.label, self.detailsLabel, self.button, self.bottomSpacer, nil];
    if (self.indicator) [subviews insertObject:self.indicator atIndex:1];

    // Remove existing constraintes
    [self removeConstraints:self.constraints];
    [topSpacer removeConstraints:topSpacer.constraints];
    [bottomSpacer removeConstraints:bottomSpacer.constraints];
    if (self.bezelConstraints) {
        [bezel removeConstraints:self.bezelConstraints];
        self.bezelConstraints = nil;
    }

    // Center bezel in container (self), applying the offset if set
    CGPoint offset = self.offset;
    NSMutableArray *centeringConstraints = [NSMutableArray array];
    [centeringConstraints addObject:[NSLayoutConstraint constraintWithItem:bezel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.f constant:offset.x]];
    [centeringConstraints addObject:[NSLayoutConstraint constraintWithItem:bezel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.f constant:offset.y]];
    [self applyPriority:998.f toConstraints:centeringConstraints];
    [self addConstraints:centeringConstraints];

    // Ensure minimum side margin is kept
    NSMutableArray *sideConstraints = [NSMutableArray array];
    [sideConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"|-(>=margin)-[bezel]-(>=margin)-|" options:0 metrics:metrics views:NSDictionaryOfVariableBindings(bezel)]];
    [sideConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(>=margin)-[bezel]-(>=margin)-|" options:0 metrics:metrics views:NSDictionaryOfVariableBindings(bezel)]];
    [self applyPriority:999.f toConstraints:sideConstraints];
    [self addConstraints:sideConstraints];

    // Minimum bezel size, if set
    CGSize minimumSize = self.minSize;
    if (!CGSizeEqualToSize(minimumSize, CGSizeZero)) {
        NSMutableArray *minSizeConstraints = [NSMutableArray array];
        [minSizeConstraints addObject:[NSLayoutConstraint constraintWithItem:bezel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.f constant:minimumSize.width]];
        [minSizeConstraints addObject:[NSLayoutConstraint constraintWithItem:bezel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.f constant:minimumSize.height]];
        [self applyPriority:997.f toConstraints:minSizeConstraints];
        [bezelConstraints addObjectsFromArray:minSizeConstraints];
    }

    // Square aspect ratio, if set
    if (self.square) {
        NSLayoutConstraint *square = [NSLayoutConstraint constraintWithItem:bezel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:bezel attribute:NSLayoutAttributeWidth multiplier:1.f constant:0];
        square.priority = 997.f;
        [bezelConstraints addObject:square];
    }

    // Top and bottom spacing
    [topSpacer addConstraint:[NSLayoutConstraint constraintWithItem:topSpacer attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.f constant:margin]];
    [bottomSpacer addConstraint:[NSLayoutConstraint constraintWithItem:bottomSpacer attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.f constant:margin]];
    // Top and bottom spaces should be equal
    [bezelConstraints addObject:[NSLayoutConstraint constraintWithItem:topSpacer attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:bottomSpacer attribute:NSLayoutAttributeHeight multiplier:1.f constant:0.f]];

    // Layout subviews in bezel
    NSMutableArray *paddingConstraints = [NSMutableArray new];
    [subviews enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL *stop) {
        // Center in bezel
        [bezelConstraints addObject:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:bezel attribute:NSLayoutAttributeCenterX multiplier:1.f constant:0.f]];
        // Ensure the minimum edge margin is kept
        [bezelConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"|-(>=margin)-[view]-(>=margin)-|" options:0 metrics:metrics views:NSDictionaryOfVariableBindings(view)]];
        // Element spacing
        if (idx == 0) {
            // First, ensure spacing to bezel edge
            [bezelConstraints addObject:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:bezel attribute:NSLayoutAttributeTop multiplier:1.f constant:0.f]];
        } else if (idx == subviews.count - 1) {
            // Last, ensure spacigin to bezel edge
            [bezelConstraints addObject:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:bezel attribute:NSLayoutAttributeBottom multiplier:1.f constant:0.f]];
        }
        if (idx > 0) {
            // Has previous
            NSLayoutConstraint *padding = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:subviews[idx - 1] attribute:NSLayoutAttributeBottom multiplier:1.f constant:0.f];
            [bezelConstraints addObject:padding];
            [paddingConstraints addObject:padding];
        }
    }];

    [bezel addConstraints:bezelConstraints];
    self.bezelConstraints = bezelConstraints;
    
    self.paddingConstraints = [paddingConstraints copy];
    [self updatePaddingConstraints];
    
    [super updateConstraints];
}

- (void)layoutSubviews {
    [self updatePaddingConstraints];
    [super layoutSubviews];
}

- (void)updatePaddingConstraints {
    // Set padding dynamically, depending on whether the view is visible or not
    __block BOOL hasVisibleAncestors = NO;
    [self.paddingConstraints enumerateObjectsUsingBlock:^(NSLayoutConstraint *padding, NSUInteger idx, BOOL *stop) {
        UIView *firstView = (UIView *)padding.firstItem;
        UIView *secondView = (UIView *)padding.secondItem;
        BOOL firstVisible = !firstView.hidden && !CGSizeEqualToSize(firstView.intrinsicContentSize, CGSizeZero);
        BOOL secondVisible = !secondView.hidden && !CGSizeEqualToSize(secondView.intrinsicContentSize, CGSizeZero);
        // Set if both views are visible of if there's a visible view on top that yet doesn't have padding
        // added relative to the current view
        padding.constant = (firstVisible && (secondVisible || hasVisibleAncestors)) ? UMComDefaultPadding : 0.f;
        hasVisibleAncestors |= secondVisible;
    }];
}

- (void)applyPriority:(UILayoutPriority)priority toConstraints:(NSArray *)constraints {
    for (NSLayoutConstraint *constraint in constraints) {
        constraint.priority = priority;
    }
}

#pragma mark - Properties

- (void)setMode:(UMComProgressHUDMode)mode {
    if (mode != _mode) {
        _mode = mode;
        [self updateIndicators];
    }
}

- (void)setCustomView:(UIView *)customView {
    if (customView != _customView) {
        _customView = customView;
        if (self.mode == UMComProgressHUDModeCustomView) {
            [self updateIndicators];
        }
    }
}

- (void)setOffset:(CGPoint)offset {
    if (!CGPointEqualToPoint(offset, _offset)) {
        _offset = offset;
        [self setNeedsUpdateConstraints];
    }
}

- (void)setMargin:(CGFloat)margin {
    if (margin != margin) {
        _margin = margin;
        [self setNeedsUpdateConstraints];
    }
}

- (void)setMinSize:(CGSize)minSize {
    if (!CGSizeEqualToSize(minSize, _minSize)) {
        _minSize = minSize;
        [self setNeedsUpdateConstraints];
    }
}

- (void)setSquare:(BOOL)square {
    if (square != _square) {
        _square = square;
        [self setNeedsUpdateConstraints];
    }
}

- (void)setProgress:(float)progress {
    if (progress != _progress) {
        _progress = progress;
        UIView *indicator = self.indicator;
        if ([indicator respondsToSelector:@selector(setProgress:)]) {
            [(id)indicator setValue:@(self.progress) forKey:@"progress"];
        }
    }
}

- (void)setContentColor:(UIColor *)contentColor {
    if (contentColor != _contentColor && ![contentColor isEqual:_contentColor]) {
        _contentColor = contentColor;
        [self updateViewsForColor:contentColor];
    }
}

- (void)setDefaultMotionEffectsEnabled:(BOOL)defaultMotionEffectsEnabled {
    if (defaultMotionEffectsEnabled != _defaultMotionEffectsEnabled) {
        _defaultMotionEffectsEnabled = defaultMotionEffectsEnabled;
        [self updateBezelMotionEffects];
    }
}

#pragma mark - Notifications

- (void)registerForNotifications {
#if !TARGET_OS_TV
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];

    [nc addObserver:self selector:@selector(statusBarOrientationDidChange:)
               name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
#endif
}

- (void)unregisterFromNotifications {
#if !TARGET_OS_TV
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc removeObserver:self name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
#endif
}

#if !TARGET_OS_TV
- (void)statusBarOrientationDidChange:(NSNotification *)notification {
    UIView *superview = self.superview;
    if (!superview) {
        return;
    } else {
        [self updateForCurrentOrientationAnimated:YES];
    }
}
#endif

- (void)updateForCurrentOrientationAnimated:(BOOL)animated {
    // Stay in sync with the superview in any case
    if (self.superview) {
        self.bounds = self.superview.bounds;
    }

    // Not needed on iOS 8+, compile out when the deployment target allows,
    // to avoid sharedApplication problems on extension targets
#if __IPHONE_OS_VERSION_MIN_REQUIRED < 80000
    // Only needed pre iOS 8 when added to a window
    BOOL iOS8OrLater = kCFCoreFoundationVersionNumber >= kCFCoreFoundationVersionNumber_iOS_8_0;
    if (iOS8OrLater || ![self.superview isKindOfClass:[UIWindow class]]) return;

    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    CGFloat radians = 0;
    if (UIInterfaceOrientationIsLandscape(orientation)) {
        radians = orientation == UIInterfaceOrientationLandscapeLeft ? -(CGFloat)M_PI_2 : (CGFloat)M_PI_2;
        // Window coordinates differ!
        self.bounds = CGRectMake(0, 0, self.bounds.size.height, self.bounds.size.width);
    } else {
        radians = orientation == UIInterfaceOrientationPortraitUpsideDown ? (CGFloat)M_PI : 0.f;
    }

    if (animated) {
        [UIView animateWithDuration:0.3 animations:^{
            self.transform = CGAffineTransformMakeRotation(radians);
        }];
    } else {
        self.transform = CGAffineTransformMakeRotation(radians);
    }
#endif
}

@end


@implementation UMComRoundProgressView

#pragma mark - Lifecycle

- (id)init {
    return [self initWithFrame:CGRectMake(0.f, 0.f, 37.f, 37.f)];
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.opaque = NO;
        _progress = 0.f;
        _annular = NO;
        _progressTintColor = [[UIColor alloc] initWithWhite:1.f alpha:1.f];
        _backgroundTintColor = [[UIColor alloc] initWithWhite:1.f alpha:.1f];
    }
    return self;
}

#pragma mark - Layout

- (CGSize)intrinsicContentSize {
    return CGSizeMake(37.f, 37.f);
}

#pragma mark - Properties

- (void)setProgress:(float)progress {
    if (progress != _progress) {
        _progress = progress;
        [self setNeedsDisplay];
    }
}

- (void)setProgressTintColor:(UIColor *)progressTintColor {
    NSAssert(progressTintColor, @"The color should not be nil.");
    if (progressTintColor != _progressTintColor && ![progressTintColor isEqual:_progressTintColor]) {
        _progressTintColor = progressTintColor;
        [self setNeedsDisplay];
    }
}

- (void)setBackgroundTintColor:(UIColor *)backgroundTintColor {
    NSAssert(backgroundTintColor, @"The color should not be nil.");
    if (backgroundTintColor != _backgroundTintColor && ![backgroundTintColor isEqual:_backgroundTintColor]) {
        _backgroundTintColor = backgroundTintColor;
        [self setNeedsDisplay];
    }
}

#pragma mark - Drawing

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    BOOL isPreiOS7 = kCFCoreFoundationVersionNumber < kCFCoreFoundationVersionNumber_iOS_7_0;

    if (_annular) {
        // Draw background
        CGFloat lineWidth = isPreiOS7 ? 5.f : 2.f;
        UIBezierPath *processBackgroundPath = [UIBezierPath bezierPath];
        processBackgroundPath.lineWidth = lineWidth;
        processBackgroundPath.lineCapStyle = kCGLineCapButt;
        CGPoint center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
        CGFloat radius = (self.bounds.size.width - lineWidth)/2;
        CGFloat startAngle = - ((float)M_PI / 2); // 90 degrees
        CGFloat endAngle = (2 * (float)M_PI) + startAngle;
        [processBackgroundPath addArcWithCenter:center radius:radius startAngle:startAngle endAngle:endAngle clockwise:YES];
        [_backgroundTintColor set];
        [processBackgroundPath stroke];
        // Draw progress
        UIBezierPath *processPath = [UIBezierPath bezierPath];
        processPath.lineCapStyle = isPreiOS7 ? kCGLineCapRound : kCGLineCapSquare;
        processPath.lineWidth = lineWidth;
        endAngle = (self.progress * 2 * (float)M_PI) + startAngle;
        [processPath addArcWithCenter:center radius:radius startAngle:startAngle endAngle:endAngle clockwise:YES];
        [_progressTintColor set];
        [processPath stroke];
    } else {
        // Draw background
        CGFloat lineWidth = 2.f;
        CGRect allRect = self.bounds;
        CGRect circleRect = CGRectInset(allRect, lineWidth/2.f, lineWidth/2.f);
        CGPoint center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
        [_progressTintColor setStroke];
        [_backgroundTintColor setFill];
        CGContextSetLineWidth(context, lineWidth);
        if (isPreiOS7) {
            CGContextFillEllipseInRect(context, circleRect);
        }
        CGContextStrokeEllipseInRect(context, circleRect);
        // 90 degrees
        CGFloat startAngle = - ((float)M_PI / 2.f);
        // Draw progress
        if (isPreiOS7) {
            CGFloat radius = (CGRectGetWidth(self.bounds) / 2.f) - lineWidth;
            CGFloat endAngle = (self.progress * 2.f * (float)M_PI) + startAngle;
            [_progressTintColor setFill];
            CGContextMoveToPoint(context, center.x, center.y);
            CGContextAddArc(context, center.x, center.y, radius, startAngle, endAngle, 0);
            CGContextClosePath(context);
            CGContextFillPath(context);
        } else {
            UIBezierPath *processPath = [UIBezierPath bezierPath];
            processPath.lineCapStyle = kCGLineCapButt;
            processPath.lineWidth = lineWidth * 2.f;
            CGFloat radius = (CGRectGetWidth(self.bounds) / 2.f) - (processPath.lineWidth / 2.f);
            CGFloat endAngle = (self.progress * 2.f * (float)M_PI) + startAngle;
            [processPath addArcWithCenter:center radius:radius startAngle:startAngle endAngle:endAngle clockwise:YES];
            // Ensure that we don't get color overlaping when _progressTintColor alpha < 1.f.
            CGContextSetBlendMode(context, kCGBlendModeCopy);
            [_progressTintColor set];
            [processPath stroke];
        }
    }
}

@end


@implementation UMComBarProgressView

#pragma mark - Lifecycle

- (id)init {
    return [self initWithFrame:CGRectMake(.0f, .0f, 120.0f, 20.0f)];
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _progress = 0.f;
        _lineColor = [UIColor whiteColor];
        _progressColor = [UIColor whiteColor];
        _progressRemainingColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
        self.opaque = NO;
    }
    return self;
}

#pragma mark - Layout

- (CGSize)intrinsicContentSize {
    BOOL isPreiOS7 = kCFCoreFoundationVersionNumber < kCFCoreFoundationVersionNumber_iOS_7_0;
    return CGSizeMake(120.f, isPreiOS7 ? 20.f : 10.f);
}

#pragma mark - Properties

- (void)setProgress:(float)progress {
    if (progress != _progress) {
        _progress = progress;
        [self setNeedsDisplay];
    }
}

- (void)setProgressColor:(UIColor *)progressColor {
    NSAssert(progressColor, @"The color should not be nil.");
    if (progressColor != _progressColor && ![progressColor isEqual:_progressColor]) {
        _progressColor = progressColor;
        [self setNeedsDisplay];
    }
}

- (void)setProgressRemainingColor:(UIColor *)progressRemainingColor {
    NSAssert(progressRemainingColor, @"The color should not be nil.");
    if (progressRemainingColor != _progressRemainingColor && ![progressRemainingColor isEqual:_progressRemainingColor]) {
        _progressRemainingColor = progressRemainingColor;
        [self setNeedsDisplay];
    }
}

#pragma mark - Drawing

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(context, 2);
    CGContextSetStrokeColorWithColor(context,[_lineColor CGColor]);
    CGContextSetFillColorWithColor(context, [_progressRemainingColor CGColor]);
    
    // Draw background
    CGFloat radius = (rect.size.height / 2) - 2;
    CGContextMoveToPoint(context, 2, rect.size.height/2);
    CGContextAddArcToPoint(context, 2, 2, radius + 2, 2, radius);
    CGContextAddLineToPoint(context, rect.size.width - radius - 2, 2);
    CGContextAddArcToPoint(context, rect.size.width - 2, 2, rect.size.width - 2, rect.size.height / 2, radius);
    CGContextAddArcToPoint(context, rect.size.width - 2, rect.size.height - 2, rect.size.width - radius - 2, rect.size.height - 2, radius);
    CGContextAddLineToPoint(context, radius + 2, rect.size.height - 2);
    CGContextAddArcToPoint(context, 2, rect.size.height - 2, 2, rect.size.height/2, radius);
    CGContextFillPath(context);
    
    // Draw border
    CGContextMoveToPoint(context, 2, rect.size.height/2);
    CGContextAddArcToPoint(context, 2, 2, radius + 2, 2, radius);
    CGContextAddLineToPoint(context, rect.size.width - radius - 2, 2);
    CGContextAddArcToPoint(context, rect.size.width - 2, 2, rect.size.width - 2, rect.size.height / 2, radius);
    CGContextAddArcToPoint(context, rect.size.width - 2, rect.size.height - 2, rect.size.width - radius - 2, rect.size.height - 2, radius);
    CGContextAddLineToPoint(context, radius + 2, rect.size.height - 2);
    CGContextAddArcToPoint(context, 2, rect.size.height - 2, 2, rect.size.height/2, radius);
    CGContextStrokePath(context);
    
    CGContextSetFillColorWithColor(context, [_progressColor CGColor]);
    radius = radius - 2;
    CGFloat amount = self.progress * rect.size.width;
    
    // Progress in the middle area
    if (amount >= radius + 4 && amount <= (rect.size.width - radius - 4)) {
        CGContextMoveToPoint(context, 4, rect.size.height/2);
        CGContextAddArcToPoint(context, 4, 4, radius + 4, 4, radius);
        CGContextAddLineToPoint(context, amount, 4);
        CGContextAddLineToPoint(context, amount, radius + 4);
        
        CGContextMoveToPoint(context, 4, rect.size.height/2);
        CGContextAddArcToPoint(context, 4, rect.size.height - 4, radius + 4, rect.size.height - 4, radius);
        CGContextAddLineToPoint(context, amount, rect.size.height - 4);
        CGContextAddLineToPoint(context, amount, radius + 4);
        
        CGContextFillPath(context);
    }
    
    // Progress in the right arc
    else if (amount > radius + 4) {
        CGFloat x = amount - (rect.size.width - radius - 4);

        CGContextMoveToPoint(context, 4, rect.size.height/2);
        CGContextAddArcToPoint(context, 4, 4, radius + 4, 4, radius);
        CGContextAddLineToPoint(context, rect.size.width - radius - 4, 4);
        CGFloat angle = -acos(x/radius);
        if (isnan(angle)) angle = 0;
        CGContextAddArc(context, rect.size.width - radius - 4, rect.size.height/2, radius, M_PI, angle, 0);
        CGContextAddLineToPoint(context, amount, rect.size.height/2);

        CGContextMoveToPoint(context, 4, rect.size.height/2);
        CGContextAddArcToPoint(context, 4, rect.size.height - 4, radius + 4, rect.size.height - 4, radius);
        CGContextAddLineToPoint(context, rect.size.width - radius - 4, rect.size.height - 4);
        angle = acos(x/radius);
        if (isnan(angle)) angle = 0;
        CGContextAddArc(context, rect.size.width - radius - 4, rect.size.height/2, radius, -M_PI, angle, 1);
        CGContextAddLineToPoint(context, amount, rect.size.height/2);
        
        CGContextFillPath(context);
    }
    
    // Progress is in the left arc
    else if (amount < radius + 4 && amount > 0) {
        CGContextMoveToPoint(context, 4, rect.size.height/2);
        CGContextAddArcToPoint(context, 4, 4, radius + 4, 4, radius);
        CGContextAddLineToPoint(context, radius + 4, rect.size.height/2);

        CGContextMoveToPoint(context, 4, rect.size.height/2);
        CGContextAddArcToPoint(context, 4, rect.size.height - 4, radius + 4, rect.size.height - 4, radius);
        CGContextAddLineToPoint(context, radius + 4, rect.size.height/2);
        
        CGContextFillPath(context);
    }
}

@end


@interface UMComBackgroundView ()

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000
@property UIVisualEffectView *effectView;
#endif
@property UIToolbar *toolbar;

@end


@implementation UMComBackgroundView

#pragma mark - Lifecycle

- (instancetype)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        if (kCFCoreFoundationVersionNumber >= kCFCoreFoundationVersionNumber_iOS_7_0) {
            _style = UMComProgressHUDBackgroundStyleBlur;
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000
            _color = [UIColor colorWithWhite:0.8f alpha:0.6f];
#else
            _color = [UIColor colorWithWhite:0.95f alpha:0.6f];
#endif
        } else {
            _style = UMComProgressHUDBackgroundStyleSolidColor;
            _color = [[UIColor blackColor] colorWithAlphaComponent:0.8];
        }

        self.clipsToBounds = YES;

        [self updateForBackgroundStyle];
    }
    return self;
}

#pragma mark - Layout

- (CGSize)intrinsicContentSize {
    // Smallest size possible. Content pushes against this.
    return CGSizeZero;
}

#pragma mark - Appearance

- (void)setStyle:(UMComProgressHUDBackgroundStyle)style {
    if (style == UMComProgressHUDBackgroundStyleBlur && kCFCoreFoundationVersionNumber < kCFCoreFoundationVersionNumber_iOS_7_0) {
        style = UMComProgressHUDBackgroundStyleSolidColor;
    }
    if (_style != style) {
        _style = style;
        [self updateForBackgroundStyle];
    }
}

- (void)setColor:(UIColor *)color {
    NSAssert(color, @"The color should not be nil.");
    if (color != _color && ![color isEqual:_color]) {
        _color = color;
        [self updateViewsForColor:color];
    }
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Views

- (void)updateForBackgroundStyle {
    UMComProgressHUDBackgroundStyle style = self.style;
    if (style == UMComProgressHUDBackgroundStyleBlur) {
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000
        UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
        [self addSubview:effectView];
        effectView.frame = self.bounds;
        effectView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        self.backgroundColor = self.color;
        self.layer.allowsGroupOpacity = NO;
        self.effectView = effectView;
#else
        UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectInset(self.bounds, -100.f, -100.f)];
        toolbar.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        toolbar.barTintColor = self.color;
        toolbar.translucent = YES;
        toolbar.barTintColor = color;
        [self addSubview:toolbar];
        self.toolbar = toolbar;
#endif
    } else {
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000
        [self.effectView removeFromSuperview];
        self.effectView = nil;
#else
        [self.toolbar removeFromSuperview];
        self.toolbar = nil;
#endif
        self.backgroundColor = self.color;
    }
}

- (void)updateViewsForColor:(UIColor *)color {
    if (self.style == UMComProgressHUDBackgroundStyleBlur) {
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000
        self.backgroundColor = self.color;
#else
        self.toolbar.barTintColor = color;
#endif
    } else {
        self.backgroundColor = self.color;
    }
}

@end




@implementation UMComProgressHUDRoundedButton

#pragma mark - Lifecycle

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        CALayer *layer = self.layer;
        layer.borderWidth = 1.f;
    }
    return self;
}

#pragma mark - Layout

- (void)layoutSubviews {
    [super layoutSubviews];
    // Fully rounded corners.
    CGFloat height = CGRectGetHeight(self.bounds);
    self.layer.cornerRadius = ceil(height / 2.f);
}

- (CGSize)intrinsicContentSize {
    // Only show, if we have associated control events.
    if (self.allControlEvents == 0) return CGSizeZero;
    CGSize size = [super intrinsicContentSize];
    // Add some side padding.
    size.width += 20.f;
    return size;
}

#pragma mark - Color

- (void)setTitleColor:(UIColor *)color forState:(UIControlState)state {
    [super setTitleColor:color forState:state];
    // Update related colors.
    [self setHighlighted:self.highlighted];
    self.layer.borderColor = color.CGColor;
}

- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    UIColor *baseColor = [self titleColorForState:UIControlStateSelected];
    self.backgroundColor = highlighted ? [baseColor colorWithAlphaComponent:0.1f] : [UIColor clearColor];
}

@end
