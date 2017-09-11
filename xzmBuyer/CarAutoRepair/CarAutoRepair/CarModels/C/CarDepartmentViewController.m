//
//  CarDepartmentViewController.m
//  CarAutoRepair
//
//  Created by minfo019 on 17/5/23.
//  Copyright © 2017年 Tracy. All rights reserved.
//

#import "CarDepartmentViewController.h"
#import "CarDepartmentCollectionViewCell.h"
#import "CRSerialModel.h"

@interface CarDepartmentViewController () <UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UILabel *headLabel;

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, assign) NSInteger requType;

@end

@implementation CarDepartmentViewController

static NSString * const identifier = @"carDepartmentCollectionViewCell";

- (void)viewWillAppear:(BOOL)animated {
    
    if (self.requType != 1) {
        [MBProgressHUD buildHudWithtitle:@"请先选择品牌" superView:self.view];
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self buildHeadLabel];
    [self buildCollectionView];
        
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNoti:) name:@"CarBrandNoti" object:nil];
}

- (void)receiveNoti:(NSNotification *)noti {
    
    NSLog(@"%@",noti.object[@"brandid"]);
    
    if ([noti.object[@"contentx"] integerValue] != 1) {
        return;
    }
    
    self.requType = 1;
    
    self.dataSource = [NSMutableArray array];
    
    self.headLabel.text = noti.object[@"bname"];
    
    NSString *carSerialUrl = [BaseURL stringByAppendingString:@"car/Serial.php"];
    
    [self showHud];
    
    self.collectionView.hidden = YES;
    
    [self.netWork asyncAFNPOST:carSerialUrl Param:@[kHDUserId,noti.object[@"brandid"]] Success:^(id responseObjc, NSError *codeErr) {
        
        [self endHud];
        
        if (!codeErr) {
            
            NSLog(@"%@",responseObjc);
            
            self.collectionView.hidden = NO;
            
            for (NSDictionary *dic in responseObjc[@"serialinfo"]) {
                
                CRSerialModel *model = [CRSerialModel mj_objectWithKeyValues:dic];
                
                [self.dataSource addObject:model];
            }
     
            [self.collectionView reloadData];
            
//            if (self.dataSource.count == 0) {
//                
//                [MBProgressHUD buildHudWithtitle:@"请先选择品牌" superView:self.view];
//            }

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

- (void)buildHeadLabel {
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 64, kScreenWidth, 50)];
    label.font = KFont(16);
    [self.view addSubview:label];
    self.headLabel = label;
}

- (void)buildCollectionView {
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64 + 40, kScreenWidth, kScreenHeight - 64 - 40) collectionViewLayout:flowLayout];
    
    collectionView.delegate = self;
    collectionView.dataSource = self;
    
    [self.view addSubview:collectionView];
    
    collectionView.backgroundColor = [UIColor clearColor];
    
    [collectionView registerNib:[UINib nibWithNibName:@"CarDepartmentCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:identifier];
    
    self.collectionView = collectionView;
}

#pragma mark - delegate and datasource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CarDepartmentCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    if (indexPath.row < self.dataSource.count) {
    
        CRSerialModel *proModel = self.dataSource[indexPath.row];
    
        cell.model = proModel;
    }

    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake(kScreenWidth * 0.25 - 20, kScreenWidth * 0.25 + 10);
}



- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(10, 10, 10, 10);
    
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    return 10.0;
    
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    
    return 10.0;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    CRSerialModel *model = self.dataSource[indexPath.row];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CarBrandNoti" object:@{@"serialid":model.serialid,@"contentx":@"2",@"sname":model.sname}];
}

@end
