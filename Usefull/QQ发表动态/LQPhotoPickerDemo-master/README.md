# LQ系列--UI

#### LQPhotoPickerDemo - https://github.com/XZTLLQ/LQClass （可节约项目大量细节调控时间，体验好！）
#### LQPhotoPickerDemo - https://github.com/XZTLLQ/LQPhotoPickerDemo （选择图片上传）
#### LQIMInputView - https://github.com/XZTLLQ/LQIMInputView （聊天页面工具栏）

# LQPhotoPickerDemo
一个功能强大的图片选择器（类似QQ图片选择器），支持即时拍照存储立即选择，本地相册图片选择，图片个数自定义上限，图片选择记忆选择的图片，十分完美，还支持点击查看放大图片，获取图片的data数据时，对原图片进行保真压缩，大小为1M以内，方便大多数项目可以直接使用，提供源码欢迎大家提出问题和一起优化，该工具是根据一些开源项目的优秀代码筛选和自己的处理，做的一套能够满足绝大部分需求的选择图片并上传服务器的工具，该项目是对工具的使用

![](https://raw.githubusercontent.com/XZTLLQ/LQPhotoPickerDemo/master/REDMEIMG/IMG_0683.PNG)
![](https://raw.githubusercontent.com/XZTLLQ/LQPhotoPickerDemo/master/REDMEIMG/IMG_0684.PNG)
![](https://raw.githubusercontent.com/XZTLLQ/LQPhotoPickerDemo/master/REDMEIMG/IMG_0685.PNG)
![](https://raw.githubusercontent.com/XZTLLQ/LQPhotoPickerDemo/master/REDMEIMG/IMG_0711.PNG)
![](https://raw.githubusercontent.com/XZTLLQ/LQPhotoPickerDemo/master/REDMEIMG/IMG_0712.PNG)
![](https://raw.githubusercontent.com/XZTLLQ/LQPhotoPickerDemo/master/REDMEIMG/IMG_0713.PNG)
![](https://raw.githubusercontent.com/XZTLLQ/LQPhotoPickerDemo/master/REDMEIMG/IMG_0714.PNG)

## 使用方法
  例子中使用的是storyboard方式加载，可以直接拷贝storyboard使用，然后调用:
```
  UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"StoryboardName" bundle:nil];  
  VCClassName *VC = [storyBoard instantiateViewControllerWithIdentifier:@"VCClassName"];
  //跳转
```
 
## Demo中的选择图片是个collectonView主要相关代码是：
 ```
     /**
     *  依次设置
     */
    self.LQPhotoPicker_superView = _scrollView;
    
    self.LQPhotoPicker_imgMaxCount = 10;
    
    [self LQPhotoPicker_initPickerView];
    
    self.LQPhotoPicker_delegate = self;//LQPhotoPickerViewDelegate
    
    //photoPicker
    [self LQPhotoPicker_updatePickerViewFrameY:200];
```
LQPhotoPickerViewDelegate:
```
    - (void)LQPhotoPicker_pickerViewFrameChanged{
        //[self LQPhotoPicker_updatePickerViewFrameY:200];
    }
```
