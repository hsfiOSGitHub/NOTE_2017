//
//  PreviewPhotosVC.m
//  SuperCar
//
//  Created by JuZhenBaoiMac on 2017/5/26.
//  Copyright © 2017年 JuZhenBaoiMac. All rights reserved.
//

#import "PreviewPhotosVC.h"

//item
#import "PreviewPhotosCell.h"

@interface PreviewPhotosVC ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation PreviewPhotosVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //配置collectionView
    [self setUpCollectionView];
    self.navigationItem.title = @"宝贝靓照";
}
//配置collectionView
-(void)setUpCollectionView{
    //代理设置
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    //注册item
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([PreviewPhotosCell class]) bundle:nil] forCellWithReuseIdentifier:[PreviewPhotosCell getCellReuseIdentifier]];
}

#pragma mark -<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout
//item的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(kScreenWidth/3, kScreenWidth/3);
}
//配置item的边距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}
//最小行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}
//最小列间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}
//组数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
//行数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.img_arr.count;
}
//行内容
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    PreviewPhotosCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[PreviewPhotosCell getCellReuseIdentifier] forIndexPath:indexPath];
    cell.imgView.image = self.img_arr[indexPath.row];
    return cell;
}
//点击item
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    NSMutableArray *items = @[].mutableCopy;
    for (int i = 0; i < self.img_arr.count; i++) {
        UIImageView *imageView = [[UIImageView alloc]initWithImage:self.img_arr[i]];
        KSPhotoItem *item = [KSPhotoItem itemWithSourceView:imageView  image:self.img_arr[i]];
        [items addObject:item];
    }
    KSPhotoBrowser *browser = [KSPhotoBrowser browserWithPhotoItems:items selectedIndex:indexPath.row];
    [browser showFromViewController:self];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
