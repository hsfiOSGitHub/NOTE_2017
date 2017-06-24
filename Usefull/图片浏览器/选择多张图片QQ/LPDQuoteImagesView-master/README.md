# LPDQuoteImagesView

[![CI Status](http://img.shields.io/travis/Assuner-Lee/LPDQuoteImagesView.svg?style=flat)](https://travis-ci.org/Assuner-Lee/LPDQuoteImagesView)
[![Version](https://img.shields.io/cocoapods/v/LPDQuoteImagesView.svg?style=flat)](http://cocoapods.org/pods/LPDQuoteImagesView)
[![License](https://img.shields.io/cocoapods/l/LPDQuoteImagesView.svg?style=flat)](http://cocoapods.org/pods/LPDQuoteImagesView)
[![Platform](https://img.shields.io/cocoapods/p/LPDQuoteImagesView.svg?style=flat)](http://cocoapods.org/pods/LPDQuoteImagesView)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Installation

LPDQuoteImagesView is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "LPDQuoteImagesView"
```
# LPDQuoteImagesView

`iOS-imagePicker 仿 QQ 仿微信-- pickImage and quote`  本库封装于TZImagePicker  只需要几行简单的代码，就可以引入多选照片并引用照片的功能模块，贴上一个view，就获得了全部。所有的功能都集成到了黑盒里，你需要做的只是初始化 quoteview 和取得 quoteview 的已选择图片数组。
![这是贴上去的 quoteView (红框内)](https://github.com/Assuner-Lee/resource/blob/master/效果图（1）.jpg)

上图就是 quoteView 贴上去的效果，点击可以选择或预览照片，点击右上角删除，可以通过引用这个 view 的 selectedPhotos 属性得到 UIImage 数组，保存或上传!

## 用法简绍

#### 1. 引入头文件

```
#import "LPDQuoteImagesView.h"
```

#### 2. 初始化一个 quoteImagesView (UIview)

```
LPDQuoteImagesView *quoteImagesView =[[LPDQuoteImagesView alloc] initWithFrame:CGRectMake(x, y, width, hight) withCountPerRowInView:5 cellMargin:12];
//初始化view的frame, view里每行cell个数， cell间距（上方的图片1 即为quoteImagesView）
注：设置frame时，我们可以根据设计人员给的cell的宽度和最大个数、排列，间距去大致计算下quoteview的size.
quoteImagesView.maxSelectedCount = 6;
//最大可选照片数

quoteImagesView.collectionView.scrollEnabled = NO;
//view可否滑动

quoteImagesView.navcDelegate = self;    //self 至少是一个控制器。
//委托（委托controller弹出picker，且不用实现委托方法）

[Xview addSubview:quoteImagesView];
//把view加到某一个视图上，就什么都不用管了！！！！
```

#### 3. 获取引用图片

```
NSArray *imageArray = [NSArray arrayWithArray:quoteImagesView.selectedPhotos];
//即可
```
###### 注：quoteImagesView.selectedPhotos为NSArray属性，引用的数组会变化，您可以在需要用到照片的方法里去拿一次照片数组，不可初始化的时候直接引用数组(此时数组为nil)。。。selectedPhotos只能反映当前状态下已选中的照片(例如上传按钮绑定的方法里去拿一次)。

只需要贴上view，其他的在图库选照片，预览，保存，更新缩略图均不需要依赖新的对象参与，引入模块不需要额外代码，包括collect view ，一切处理响应都封在了quoteview及黑盒中。

## 详细介绍

参见：[简书](http://www.jianshu.com/p/2b9086d2c37b)

## 效果图

![选照片界面](https://github.com/Assuner-Lee/resource/blob/master/效果图2.PNG)|![预览功能](https://github.com/Assuner-Lee/resource/blob/master/效果图3.PNG)
:-------------------------:|:-------------------------:

选中照片，蓝色框还有动画效果。。。。

## 其他

导航栏自动适应 App 颜色，选中的视图排列可自由设置，删除带有动画效果，添加到最大数目没有➕，删除就出现。
[PS: 请在主工程配置 info.list NSPhotoLibraryUsageDescription键值
Localization native development region 设为China](http://www.jianshu.com/p/2b9086d2c37b)

## 感谢
本库封装于TZImagePicker,很多业务场景下使用很方便。
## 最后

别忘了点个星星哦，谢谢大家！

## Author

Assuner-Lee [assuner@foxmail.com](assuner@foxmail.com)

## License

LPDQuoteImagesView is available under the MIT license. See the LICENSE file for more info.
