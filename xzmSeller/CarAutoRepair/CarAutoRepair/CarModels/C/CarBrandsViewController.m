//
//  CarBrandsViewController.m
//  CarAutoRepair
//
//  Created by minfo019 on 17/5/23.
//  Copyright © 2017年 Tracy. All rights reserved.
//

#import "CarBrandsViewController.h"
#import "LJCollectionViewFlowLayout.h"
#import "CollectionViewHeaderView.h"
#import "KTProductCell.h"
#import "CarBrandsCollectionViewCell.h"
#import "CRCarBrandModel.h"
#import "CRCarInfoModel.h"

@interface CarBrandsViewController ()<UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate,
UICollectionViewDataSource> {
    NSInteger _selectIndex;
    BOOL _isScrollDown;
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray <CRCarBrandModel *>*dataSource;

@property (nonatomic, strong) NSMutableArray *collectionDatas;

@end

@implementation CarBrandsViewController

static NSString * const proIdentifier = @"productCell";

static NSString * const identifier = @"carBrandsCollectionViewCell";

- (void)viewDidLoad {
    [super viewDidLoad];

    _selectIndex = 0;
    _isScrollDown = YES;
    
    [self.view addSubview:self.tableView];
    
    [self.view addSubview:self.collectionView];
    
    [self requestData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNoti:) name:@"ScrollNoti" object:nil];
}

- (void)receiveNoti:(NSNotification *)noti {
    
    if ([noti.object[@"scrollType"] isEqualToString:@"1"]) {
        
        [self collectionView:self.collectionView didSelectItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
    }
}

- (void)requestData {
    
    NSString *carBrandsUrl = [BaseURL stringByAppendingString:@"car/Brand.php"];
    
    [self showHud];
    
    self.collectionView.hidden = YES;
    
    [self.netWork asyncAFNPOST:carBrandsUrl Param:@[kHDUserId] Success:^(id responseObjc, NSError *codeErr) {
        [self endHud];
        
        if (!codeErr) {
            
            NSLog(@"%@",responseObjc);
            
            self.collectionView.hidden = NO;
            
            for (NSDictionary *dic in responseObjc[@"brandlist"]) {
                
                CRCarBrandModel *model = [CRCarBrandModel mj_objectWithKeyValues:dic];
                
                [self.dataSource addObject:model];
            }

            [self.tableView reloadData];
            
            [self.collectionView reloadData];
            
            [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
            
        } else {
            NSInteger code = codeErr.code;
            if (code == 10 || code == 11 || code == 12) {
                /** 跳转登录 */
                [UIApplication sharedApplication].keyWindow.rootViewController = self.loginNav;
            } else {
//                [MBProgressHUD buildHudWithtitle:@"服务器繁忙，请稍后重试!" superView:self.view];
            }
        }
    } Failure:^(NSError *netErr) {
        [self endHud];
        [MBProgressHUD buildHudWithtitle:@"无法连接到网络，请稍后再试!" superView:self.view];
    }];
}

#pragma mark - tableView -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    KTProductCell *cell = [tableView dequeueReusableCellWithIdentifier:proIdentifier];
    
        if (indexPath.row < self.dataSource.count) {
   
           CRCarBrandModel *listModel = self.dataSource[indexPath.row];
   
            cell.titleLabel.text = listModel.fname;
        }

    return cell;
}

#pragma mark    BUG!!!!!!!!!!
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    _selectIndex = indexPath.row;
    
    //防止headView遮盖UIcollectionView
    //向下移动30像素
    
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:_selectIndex] atScrollPosition:UICollectionViewScrollPositionTop animated:YES];
    //   [self.collectionView scrollRectToVisible:CGRectMake(0,30, 1, 1) animated:YES];
    
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_selectIndex inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

#pragma mark - UICollectionView DataSource Delegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.dataSource.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    CRCarBrandModel*model = self.dataSource[section];
    return model.info.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CarBrandsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
   
    CRCarInfoModel *model = self.dataSource[indexPath.section].info[indexPath.row];
    
   // CRCarBrandModel*model = self.dataSource[indexPath.section];
    //CRCarInfoModel *InfoModel = model.info[indexPath.row];
    
    cell.model = model;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CRCarInfoModel *model = self.dataSource[indexPath.section].info[indexPath.row];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CarBrandNoti" object:@{@"brandid":model.brandid,@"contentx":@"1",@"bname":model.bname}];
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((kScreenWidth - 70)* 0.25 - 20, (kScreenWidth - 70) * 0.25 + 10);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    NSString *reuseIdentifier;
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]){ // header
        reuseIdentifier = @"CollectionViewHeaderView";
    }
    CollectionViewHeaderView *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]){
        CRCarBrandModel *model = self.dataSource[indexPath.section];
        view.title.text = model.fname;
    }
    return view;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(kScreenWidth - 70, 25);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(0, 10, 10, 10);
}

// CollectionView分区标题即将展示
- (void)collectionView:(UICollectionView *)collectionView willDisplaySupplementaryView:(UICollectionReusableView *)view forElementKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath
{
    // 当前CollectionView滚动的方向向上，CollectionView是用户拖拽而产生滚动的（主要是判断CollectionView是用户拖拽而滚动的，还是点击TableView而滚动的）
    if (!_isScrollDown && collectionView.dragging)
    {
        [self selectRowAtIndexPath:indexPath.section];
    }
}

// CollectionView分区标题展示结束
- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingSupplementaryView:(nonnull UICollectionReusableView *)view forElementOfKind:(nonnull NSString *)elementKind atIndexPath:(nonnull NSIndexPath *)indexPath
{
    // 当前CollectionView滚动的方向向下，CollectionView是用户拖拽而产生滚动的（主要是判断CollectionView是用户拖拽而滚动的，还是点击TableView而滚动的）
    if (_isScrollDown && collectionView.dragging)
    {
        [self selectRowAtIndexPath:indexPath.section + 1];
    }
}

// 当拖动CollectionView的时候，处理TableView
- (void)selectRowAtIndexPath:(NSInteger)index
{
    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] animated:YES scrollPosition:UITableViewScrollPositionMiddle];
}

#pragma mark - UIScrollView Delegate
// 标记一下CollectionView的滚动方向，是向上还是向下
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    static float lastOffsetY = 0;
    
    if (self.collectionView == scrollView)
    {
        _isScrollDown = lastOffsetY < scrollView.contentOffset.y;
        lastOffsetY = scrollView.contentOffset.y;
    }
    
}

#pragma mark - Getters

- (NSMutableArray *)dataSource
{
    if (!_dataSource)
    {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (NSMutableArray *)collectionDatas
{
    if (!_collectionDatas)
    {
        _collectionDatas = [NSMutableArray array];
    }
    return _collectionDatas;
}

- (UITableView *)tableView
{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, 70, kScreenHeight - 64)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.rowHeight = 40;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = ColorForRGB(0xf5f5f5);
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([KTProductCell class]) bundle:nil] forCellReuseIdentifier:proIdentifier];
    }
    return _tableView;
}

- (UICollectionView *)collectionView
{
    if (!_collectionView)
    {
        LJCollectionViewFlowLayout *flowlayout = [[LJCollectionViewFlowLayout alloc] init];
        //        UICollectionViewFlowLayout *flowlayout = [[UICollectionViewFlowLayout alloc]init];
        //设置滚动方向
        [flowlayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        //左右间距
        flowlayout.minimumInteritemSpacing = 10;
        //上下间距
        flowlayout.minimumLineSpacing = 10;

        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(70, 64, kScreenWidth - 70, kScreenHeight - 64) collectionViewLayout:flowlayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView setBackgroundColor:[UIColor clearColor]];
        
        //注册cell
        [_collectionView registerNib:[UINib nibWithNibName:@"CarBrandsCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:identifier];
        //注册分区头标题
        [_collectionView registerClass:[CollectionViewHeaderView class]
            forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"CollectionViewHeaderView"];
    }
    return _collectionView;
}


@end
