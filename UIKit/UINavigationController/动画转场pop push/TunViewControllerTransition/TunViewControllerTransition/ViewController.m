//
//  ViewController.m
//  TunViewControllerTransition
//
//  Created by 涂育旺 on 2017/7/15.
//  Copyright © 2017年 Qianhai Jiutong. All rights reserved.
//

#import "ViewController.h"
#import "UIViewController+TunTransition.h"
#import "CollectionViewCell.h"
#import "FirstViewController.h"
#import "CircleCollectionViewCell.h"

@interface ViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation ViewController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.navigationController.delegate = self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 3;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 4;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *resuable = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"head" forIndexPath:indexPath];
    if (!resuable) {
        resuable = [[UICollectionReusableView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 50)];
        resuable.backgroundColor = [UIColor lightGrayColor];
    }
    return resuable;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell;
    
    if (indexPath.section == 1) {
        CircleCollectionViewCell *tcell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Circle" forIndexPath:indexPath];
        cell = tcell;
    }else
    {
        CollectionViewCell *tcell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
        cell = tcell;

    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //获取指定视图
    CollectionViewCell *cell = (CollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
     FirstViewController *firstVC = [sb instantiateViewControllerWithIdentifier:@"FirstViewController"];
    
    if (indexPath.section == 0) {
        [self animateTransitionFromView:cell.imageView toView:@"imageView"];
    }else if(indexPath.section == 1)
    {
        [self animateCircleTransitionFromView:cell.imageView];
        firstVC.circleTransition = YES;
    }else
    {
        [self animatePageTransition];
        firstVC.pageTransition = YES;
    }
    
    
    
    [self.navigationController pushViewController:firstVC animated:YES];
    
    

}

@end
