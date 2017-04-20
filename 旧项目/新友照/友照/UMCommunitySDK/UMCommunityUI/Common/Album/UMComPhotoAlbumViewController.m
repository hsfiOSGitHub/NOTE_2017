//
//  UMComPhotoAlbumViewController.m
//  UMCommunity
//
//  Created by umeng on 15/7/7.
//  Copyright (c) 2015年 Umeng. All rights reserved.
//

#import "UMComPhotoAlbumViewController.h"
#import "UMComImageView.h"
#import <UMComDataStorage/UMComAlbum.h>
#import "UMComGridViewerController.h"
#import "UIViewController+UMComAddition.h"
#import "UMComRefreshView.h"
#import <UMComDataStorage/UMComUser.h>
#import <UMComDataStorage/UMComImageUrl.h>
#import "UMComShowToast.h"
#import <UMCommunitySDK/UMComSession.h>
#import "UMComUserAlbumDataController.h"
#import <UMComFoundation/UMComKit+Color.h>

typedef void (^AlbumLoadCompletionHandler)(NSArray *data, NSError *error);

const CGFloat A_WEEK_SECONDES = 60*60*24*7;


@interface UMComPhotoAlbumViewController ()<UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *albumCollectionView;

@property (nonatomic, strong) UICollectionViewFlowLayout *layout;

@property (nonatomic, strong) NSArray *imageModelsArray;

@property (nonatomic, strong) UMComHeadView *headView;

@property (nonatomic, strong) UMComFootView *footView;

@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;

@property (nonatomic, strong) UILabel *noDataTipLabel;

@property (nonatomic,strong) UIView* emptyView;//无内容时候显示的view

-(void) createEmptyView;

@property(nonatomic,strong)UMComUserAlbumDataController* dataController;
@property(nonatomic,assign)BOOL isLoadFinish;

- (void)refreshData;

- (void)refreshDataFromServer;

- (void)loadMoreData;

@end

@implementation UMComPhotoAlbumViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitleViewWithTitle:UMComLocalizedString(@"um_com_album", @"相册")];
    
    self.isLoadFinish = YES;
    self.dataController = [UMComUserAlbumDataController userAlbumDataControllWithUser:self.user count:UMCom_Limit_Page_Count];
    
    if ([self.user.uid isEqualToString:[UMComSession sharedInstance].uid]) {
        self.dataController.isReadLoacalData = YES;
        self.dataController.isSaveLoacalData = YES;
    }
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.scrollDirection =UICollectionViewScrollDirectionVertical;
    layout.minimumInteritemSpacing = 2;
    layout.minimumLineSpacing = 2;
    self.layout = layout;
    self.albumCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) collectionViewLayout:layout];
    self.albumCollectionView.backgroundColor = [UIColor whiteColor];
    self.albumCollectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth |UIViewAutoresizingFlexibleHeight;
    [self.albumCollectionView registerClass:[UMComPhotoAlbumCollectionCell class] forCellWithReuseIdentifier:@"PhotoAlbumCollectionCell"];
    [self.view addSubview:self.albumCollectionView];

    self.indicatorView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.indicatorView.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
    self.indicatorView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.indicatorView];
    
    __weak typeof(self) weakSelf = self;
    self.headView = (UMComHeadView *)[UMComHeadView refreshControllViewWithScrollView:self.albumCollectionView block:^{
        [weakSelf refreshData];
    }];
    
    self.footView = (UMComFootView *)[UMComFootView refreshControllViewWithScrollView:self.albumCollectionView block:^{
        [weakSelf loadMoreData];
    }];
    
    [self createEmptyView];
    
    [self refreshData];
    
    // Do any additional setup after loading the view from its nib.
}


- (void)creatNoFeedTip
{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height/2-40, self.view.frame.size.width,40)];
    label.backgroundColor = [UIColor clearColor];
    label.text = UMComLocalizedString(@"um_com_emptyData", @"内容为空");
    label.font = UMComFontNotoSansLightWithSafeSize(17);
    label.textColor = UMComColorWithHexString(FontColorGray);
    label.textAlignment = NSTextAlignmentCenter;
    label.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    label.hidden = YES;
    [self.view addSubview:label];
    self.noDataTipLabel = label;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.albumCollectionView.delegate = self;
    self.albumCollectionView.dataSource = self;
    CGFloat itemWidth = (self.view.frame.size.width-8)/3;
    self.layout.itemSize = CGSizeMake(itemWidth, itemWidth);
    [self.albumCollectionView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}


- (NSArray *)imageModelsWithData:(NSArray *)data
{
    NSMutableArray *imageModels = [NSMutableArray array];
    for (UMComAlbum *album in data) {
        if (album.image_urls.count > 0) {
            [imageModels addObjectsFromArray:album.image_urls];
        }
    }
    return imageModels;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.imageModelsArray.count <=  0) {
        self.emptyView.hidden = NO;
    }
    else{
        self.emptyView.hidden = YES;
    }
    
    if (self.imageModelsArray.count < 20) {
        return 20;
    }
    return self.imageModelsArray.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UMComPhotoAlbumCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PhotoAlbumCollectionCell" forIndexPath:indexPath];
    if (indexPath.row < self.imageModelsArray.count) {
        UMComImageUrl *imageModel = self.imageModelsArray[indexPath.row];
        [cell.imageView setImageURL:imageModel.small_url_string placeHolderImage:UMComImageWithImageName(@"image-placeholder")];
    }else{
        cell.imageView.image = nil;
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row >= self.imageModelsArray.count) {
        return;
    }
    UMComGridViewerController *viewerController = [[UMComGridViewerController alloc] initWithArray:self.imageModelsArray index:indexPath.row];
    [viewerController setCacheSecondes:A_WEEK_SECONDES];
    [self presentViewController:viewerController animated:YES completion:nil];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat itemWidth = (self.view.frame.size.width-8)/3;
    CGSize itemSize = CGSizeMake(itemWidth, itemWidth);
    return itemSize;
}


- (void)dealloc
{
    self.albumCollectionView.delegate = nil;
    self.albumCollectionView.dataSource = nil;
    self.albumCollectionView = nil;
    self.headView = nil;
    self.footView = nil;
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

-(void) createEmptyView
{
    self.emptyView = [[UIView alloc] initWithFrame:self.view.bounds];

    UILabel *noticellabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.emptyView.bounds.size.width, 40)];
    noticellabel.text = UMComLocalizedString(@"um_com_emptyData", @"暂时没有内容哦!");
    noticellabel.center = CGPointMake(self.emptyView.frame.size.width/2, self.emptyView.frame.size.height/2 );
    noticellabel.textAlignment = NSTextAlignmentCenter;
    noticellabel.font = UMComFontNotoSansLightWithSafeSize(20);
    noticellabel.textColor = UMComColorWithHexString(@"#A5A5A5");
    noticellabel.backgroundColor = [UIColor whiteColor];
    noticellabel.alpha = 1;
    [self.emptyView addSubview:noticellabel];
    
    [self.albumCollectionView addSubview:self.emptyView];
    
    self.emptyView.hidden = YES;
}


#pragma mark - data request

- (void)handleLocalData:(NSArray *)data error:(NSError *)error
{
    self.dataController.haveNextPage = NO;
    self.dataController.canVisitNextPage = NO;
    self.dataController.nextPageUrl = nil;
    [self.dataController.dataArray removeAllObjects];
    if ([data isKindOfClass:[NSArray class]] && data.count >0) {
        [self.dataController.dataArray addObjectsFromArray:data];
    }
    
    if (!error) {
        NSMutableArray *tempArr = [NSMutableArray arrayWithArray:self.imageModelsArray];
        [tempArr addObjectsFromArray:[self imageModelsWithData:data]];
        self.imageModelsArray = tempArr;
        [self.albumCollectionView reloadData];
    }
}

- (void) fetchLocalData
{
    __weak typeof(self) weakSelf = self;
    [self.dataController fetchLocalDataWithCompletion:^(NSArray *dataArray, NSError *error) {
        
        if (dataArray && [dataArray isKindOfClass:[NSArray class]] && dataArray.count > 0) {
            
            [weakSelf handleLocalData:dataArray error:error];

        }
        [weakSelf refreshDataFromServer];
    }];
}

-(void) refreshData
{
    if (self.dataController.isReadLoacalData) {
        //设置NO只会第一次下拉刷新取本地数据
        self.dataController.isReadLoacalData = NO;
        //取本地数据的话，就不需要显示loadMoreStatusView的views
        [self fetchLocalData];
    }
    else{
        [self refreshDataFromServer];
    }
}

-(void)refreshDataFromServer
{
    if (self.isLoadFinish == NO) {
        return;
    }
    self.isLoadFinish = NO;
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    __weak typeof(self) weakSelf = self;
    [self.dataController refreshNewDataCompletion:^(NSArray *data, NSError *error) {
        [UMComShowToast showFetchResultTipWithError:error];
        if (!error && [data isKindOfClass:[NSArray class]] && data.count <= 0) {
            weakSelf.emptyView.hidden = NO;
        }
        else{
            weakSelf.emptyView.hidden = YES;
        }
        [weakSelf.indicatorView stopAnimating];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        if (!error && [data isKindOfClass:[NSArray class]]) {
            weakSelf.imageModelsArray = [weakSelf imageModelsWithData:data];
        }
        weakSelf.isLoadFinish = YES;
        [weakSelf.headView endLoading];
        //如果没有下一页 则不显示下拉刷新
        if (weakSelf.dataController.haveNextPage) {
            [weakSelf.footView endLoading];
        }else{
            [weakSelf.footView noMoreData];
        }
        [weakSelf.albumCollectionView reloadData];
    }];

}

- (void)loadMoreData
{
    if (self.isLoadFinish == NO) {
        return;
    }
    if (!self.dataController.haveNextPage) {
        [self.footView noMoreData];
        return;
    }
    self.isLoadFinish = NO;
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    __weak typeof(self) weakSelf = self;
    [self.dataController loadNextPageDataWithCompletion:^(NSArray *data, NSError *error) {
        [UMComShowToast showFetchResultTipWithError:error];
        if (!error) {
            NSMutableArray *tempArr = [NSMutableArray arrayWithArray:weakSelf.imageModelsArray];
            [tempArr addObjectsFromArray:[weakSelf imageModelsWithData:data]];
            weakSelf.imageModelsArray = tempArr;
        }
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        weakSelf.isLoadFinish = YES;
        if (weakSelf.dataController.haveNextPage) {
            [weakSelf.footView endLoading];
        }else{
            [weakSelf.footView noMoreData];
        }
        [weakSelf.albumCollectionView reloadData];
    }];
}

@end




@implementation UMComPhotoAlbumCollectionCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat imageWidth = frame.size.width;
        self.imageView = [[[UMComImageView imageViewClassName] alloc] initWithFrame:CGRectMake(0, 0, imageWidth, imageWidth)];
        self.imageView.needCutOff = YES;
        [self.contentView addSubview:self.imageView];
    }
    return self;
}

@end
