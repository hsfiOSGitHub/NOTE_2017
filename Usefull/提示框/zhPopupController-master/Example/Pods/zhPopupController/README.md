# zhPopupController

[![Language](https://img.shields.io/badge/Language-%20Objective--C%20-orange.svg)](https://travis-ci.org/snail-z/zhPopupController)
[![Version](https://img.shields.io/badge/pod-v0.1.7-brightgreen.svg)](http://cocoapods.org/pods/zhPopupController)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](http://cocoapods.org/pods/zhPopupController)
[![Platform](https://img.shields.io/badge/platform-%20iOS7.0+%20-lightgrey.svg)](http://cocoapods.org/pods/zhPopupController)

Popup your custom view is easy, support custom mask style, transition effects and gesture to drag.



## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

- Requires iOS 7.0 or later
- Requires Automatic Reference Counting (ARC)

## Installation

zhPopupController is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
platform :ios, '7.0'
use_frameworks!

target 'You Project' do
    
	pod 'zhPopupController', '~> 0.1.7'
    
end
```

## Preview   

<img src="https://github.com/snail-z/zhPopupController/blob/master/Preview/_zhPopupController.gif?raw=true" width="204px" height="365px">



## Usage

* Direct use of zh_popupController popup your  custom view.
``` objc
    [self.zh_popupController presentContentView:customView];
```
* Customize.
```objc
    self.zh_popupController = [zhPopupController popupControllerWithMaskType:zhPopupMaskTypeWhiteBlur];
    self.zh_popupController.layoutType = zhPopupLayoutTypeLeft;
    self.zh_popupController.allowPan = YES;
    // ...
    [self.zh_popupController presentContentView:customView];
```

## Notes

- New methods, Support dismiss automatically.  **(September 11, 2017 v0.1.6)**

```objc
/**
 present your content view.
 @param contentView This is the view that you want to appear in popup. / 弹出自定义的contentView
 @param duration Popup animation time. / 弹出动画时长
 @param isSpringAnimated if YES, Will use a spring animation. / 是否使用弹性动画
 @param sView  Displayed on the sView. if nil, Displayed on the window. / 显示在sView上
 @param displayTime The view will disappear after `displayTime` seconds. / 视图将在displayTime后消失
 */
- (void)presentContentView:(nullable UIView *)contentView
                  duration:(NSTimeInterval)duration
            springAnimated:(BOOL)isSpringAnimated
                    inView:(nullable UIView *)sView
               displayTime:(NSTimeInterval)displayTime;
```

- Update  **(September 13, 2017 v0.1.7)**

  - Content layout fixes

  - Observe to keyboard changes will change contentView layout

  - New **`offsetSpacingOfKeyboard`** properties.   You can through it adjust the spacing relative to the keyboard when the keyboard appears. default is 0

    >  The pan gesture will be invalid when the keyboard appears.

<img src="https://github.com/snail-z/zhPopupController/blob/master/Preview/_zhPopupController_up.gif?raw=true" width="204px" height="365px">

## Author

snail-z, haozhang0770@163.com

## License

zhPopupController is available under the MIT license. See the LICENSE file for more info.


