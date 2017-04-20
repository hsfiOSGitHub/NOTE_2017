//
//  UMComFeedImageCollectionView.m
//  UMCommunity
//
//  Created by umeng on 16/5/15.
//  Copyright © 2016年 Umeng. All rights reserved.
//

#import "UMComFeedImageCollectionView.h"
#import "UMComFeedImageCollectionViewCell.h"
#import <UMComDataStorage/UMComImageUrl.h>
#import "UMComImageView.h"

static NSString *kUMCom_FeedCell_ID = @"UMComFeedImageCollectionViewCell";

static NSString *kUMCom_Image_Url = @"image_url";
static NSString *kUMCom_Image_Size = @"load_image_size";
static NSString *kUMCom_Image_HasLoaded = @"hasLoaded";



@interface UMComFeedImageCollectionView()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UMComImageViewDelegate>

@property (nonatomic, strong) NSMutableDictionary *imageCacheInfo;


@end

@implementation UMComFeedImageCollectionView

@synthesize currentViewHeight = _currentViewHeight;

- (instancetype)initWithFrame:(CGRect)frame
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    CGFloat imageWidth = (frame.size.width -(layout.minimumInteritemSpacing*2))/3;
    layout.itemSize = CGSizeMake(imageWidth, imageWidth);
    self = [self initWithFrame:frame collectionViewLayout:layout];
    if (self) {
    }
    return self;
}

- (void)awakeFromNib
{
    [self initData];
}

- (void)initData
{
    [self registerNib:[UINib nibWithNibName:@"UMComFeedImageCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:kUMCom_FeedCell_ID];
    self.delegate = self;
    self.dataSource = self;
    self.scrollEnabled = NO;
    self.imageCacheInfo = [NSMutableDictionary dictionary];
    self.defualtImageHeight = self.frame.size.height;
    self.column = 1;
}

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(nonnull UICollectionViewLayout *)layout
{
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        [self initData];
    }
    return self;
}

- (void)setImageArray:(NSArray *)imageArray
{
    _imageArray = imageArray;
    for (UMComImageUrl *imageUrl in _imageArray) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setValue:imageUrl.large_url_string forKey:kUMCom_Image_Url];
        CGFloat itemWidth = self.frame.size.width;
        if (self.column > 1) {
            itemWidth = (self.frame.size.width)/3;
        }
        CGSize size = CGSizeMake(itemWidth, itemWidth);
        [dict setValue:[NSValue valueWithCGSize:size] forKey:kUMCom_Image_Size];
        [self.imageCacheInfo setValue:dict forKey:imageUrl.large_url_string];
    }
    [self reloadData];
    if (self.collectionRefreshBlock) {
        self.collectionRefreshBlock(self.currentViewHeight);
    }
}

- (void)setCurrentViewHeight:(CGFloat)currentViewHeight
{
    _currentViewHeight = currentViewHeight;
}

- (CGFloat)currentViewHeight
{
    for (NSString *key in self.imageCacheInfo) {
        NSDictionary *dict = [self.imageCacheInfo valueForKey:key];
        NSValue *value = [dict valueForKey:kUMCom_Image_Size];
        CGSize size = [value CGSizeValue];
        _currentViewHeight += size.height;
    }
    return _currentViewHeight;
}

#pragma mark - dataSource and deleagte
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.imageArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UMComFeedImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kUMCom_FeedCell_ID forIndexPath:indexPath];
    UMComImageUrl *imageUrl = self.imageArray[indexPath.row];
    cell.backgroundColor = [UIColor redColor];
    cell.umcomImageView.backgroundColor = [UIColor greenColor];
    [self resetImageViewWithImageUrl:imageUrl.large_url_string placeholder:nil cell:cell];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath;
{

    UMComImageUrl *imageUrl = self.imageArray[indexPath.row];
    CGSize itemSize = CGSizeMake(collectionView.frame.size.width, collectionView.frame.size.width);
    for (NSString *key in self.imageCacheInfo) {
        if ([imageUrl.large_url_string isEqualToString:key]) {
            NSDictionary *dict = [self.imageCacheInfo valueForKey:key];;
            NSValue *value = [dict valueForKey:kUMCom_Image_Size];
            itemSize = [value CGSizeValue];
        } ;

    }
    return itemSize;
}

- (void)resetImageViewWithImageUrl:(NSString *)imageUrl placeholder:(UIImage *)placeholder cell:(UMComFeedImageCollectionViewCell *)cell
{
    cell.feedImageView.frame = cell.bounds;
    cell.umcomImageView.frame = cell.feedImageView.bounds;
    cell.umcomImageView.imageLoaderDelegate = self;
    [cell.umcomImageView setImageURL:imageUrl placeHolderImage:placeholder];
}

- (void)umcomImageViewLoadedImage:(UMComImageView *)imageView
{
    UIImage *image = imageView.image;
    CGSize imageSize = image.size;
    
    if (imageSize.width > self.frame.size.width) {
        imageSize.height = imageSize.height * self.frame.size.width/imageSize.height;
        imageSize.width = self.frame.size.width;
    }
    
    NSDictionary *dict = [self.imageCacheInfo valueForKey:[imageView.imageURL absoluteString]];
    if (![dict valueForKey:kUMCom_Image_HasLoaded]) {
        [dict setValue:@(1) forKey:kUMCom_Image_HasLoaded];
        [dict setValue:[NSValue valueWithCGSize:imageSize] forKey:kUMCom_Image_Size];
        
        [self reloadData];
        if (self.collectionRefreshBlock) {
            self.collectionRefreshBlock(self.currentViewHeight);
        }
    }
}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
