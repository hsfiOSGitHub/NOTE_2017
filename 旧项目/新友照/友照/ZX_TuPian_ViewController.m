//
//  ZX_TuPian_ViewController.m
//  友照
//
//  Created by cleloyang on 2016/12/12.
//  Copyright © 2016年 ZX_XPH. All rights reserved.
//

#import "ZX_TuPian_ViewController.h"
#import "ZXpicCollectionViewCell.h"
#import "ZXBiaoZhiCollectionViewCell.h"

@interface ZX_TuPian_ViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic) UICollectionView *collectionView;
@property (nonatomic)UILabel *lable;
@property(nonatomic)BOOL one;
@end

@implementation ZX_TuPian_ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self  showUI];
}

- (void)showUI
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumInteritemSpacing = 1;
    layout.minimumLineSpacing = 0;
    
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    if (_isJiaXiaoTuPian)
    {
        _collectionView  = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0 , KScreenWidth, KScreenHeight) collectionViewLayout:layout];
        [_collectionView registerNib:[UINib nibWithNibName:@"ZXpicCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"cellID"];
    }
    else
    {
        _collectionView  = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
        [_collectionView registerNib:[UINib nibWithNibName:@"ZXBiaoZhiCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"cellID"];
    }
    
    _collectionView.backgroundColor =[UIColor whiteColor];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.pagingEnabled = YES;
    _collectionView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_collectionView];
    [_collectionView scrollToItemAtIndexPath:_contentIndexPath atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(self.view.bounds.size.width,self.view.bounds.size.height/1.4);
}

//几组
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
//    if (_isJiaXiaoTuPian)
//    {
        return 1;
        
//    }
//    else
//    {
//        return [_dataSourceDic[@"biaozhilist"] count];
//    }
}

// 每组多少个
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (_isJiaXiaoTuPian)
    {
        return _imgsArr.count;
        
    }
    else
    {
        return [_dataSourceDic[@"biaozhilist"] count];
    }
}





- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (_isJiaXiaoTuPian)
    {
        ZXpicCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellID" forIndexPath:indexPath];
        [cell.imageV sd_setImageWithURL:[NSURL URLWithString:_imgsArr[indexPath.row]] placeholderImage:[UIImage imageNamed:@"jiaxiaobg.jpg"]];
        cell.lab.text = _fenShuArr[indexPath.row];
        cell.tit.text=_titleArr[indexPath.row];
        
        cell.bounds = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height/1.05);
        //捏合手势
        UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(handlePinch:)];
        [cell.imageV addGestureRecognizer:pinch];
        //双击手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handlePinch:)];
        tap.numberOfTouchesRequired = 2;
        [cell.imageV addGestureRecognizer:tap];
        return cell;
    }
    else
    {
        ZXBiaoZhiCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellID" forIndexPath:indexPath];
        //标志
        NSDictionary *dict = _dataSourceDic[@"biaozhilist"][indexPath.row];
        UIImage *BZimage = [UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg", dict[@"imageurl"]]];
        cell.imageurlImageView.image = BZimage;
//        cell.titleLabel.text = dict[@"title"];
        cell.descLabel.text = dict[@"desc"];
        cell.bounds = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height/1.05);
        //捏合手势
        UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(handlePinch:)];
        [cell.imageurlImageView addGestureRecognizer:pinch];
        return cell;
    }
}

//捏合手势
- (void)handlePinch:(UIPinchGestureRecognizer *)pinch
{
    pinch.view.transform = CGAffineTransformScale(pinch.view.transform, pinch.scale, pinch.scale);
    //将之前的比例还原成1;
    pinch.scale = 1.0;
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
