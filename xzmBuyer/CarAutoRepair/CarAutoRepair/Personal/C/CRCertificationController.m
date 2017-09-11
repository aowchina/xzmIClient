//
//  CRCertificationController.m
//  CarAutoRepair
//
//  Created by minfo019 on 17/5/19.
//  Copyright © 2017年 Tracy. All rights reserved.
//

#import "CRCertificationController.h"
#import "CRCertificationCell.h"
#import "CRCertificationFootView.h"

#import "CRSpecialtyController.h"

@interface CRCertificationController ()<UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *dataSource;

@property (nonatomic ,strong) NSString *companyStr;
/** 姓名 */
@property (nonatomic ,strong) NSString *nameStr;
/** 证件号 */
@property (nonatomic ,strong) NSString *IDStr;
/** 城市 */
@property (nonatomic ,strong) NSString *cityStr;
/** 范围 */
@property (nonatomic ,strong) NSString *scopeStr;
/** 专长 */
@property (nonatomic ,strong) NSString *specialtyStr;

@property (nonatomic, strong) NSMutableArray *imageArr;

@property (nonatomic ,strong) CRCertificationFootView *footView;

@property (nonatomic, strong) ISAddressProvinceModel *pmodel;
@property (nonatomic, strong) ISAddressCityModel *citymodel;
@property (nonatomic, strong) ISAddressCountryModel *coumodel;

@property (nonatomic, assign) NSInteger btn_tag;


@end

@implementation CRCertificationController

static NSString * const idenyifier = @"CRCertificationCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataSource = @[@{@"name":@"公司名称：",@"text":@"公司名称（个人商家）"},@{@"name":@"姓名：",@"text":@"姓名"},@{@"name":@"证件号：",@"text":@"身份证或营业执照号码"},@{@"name":@"城市：",@"text":@"城市"},@{@"name":@"范围：",@"text":@"经营范围或特点"},@{@"name":@"专长：",@"text":@"请选择专长"}];
    
    self.imageArr = [NSMutableArray array];
    
    [self setNav];
    [self createTableView];
    
    [self buildBottomView];
}

- (void)buildBottomView {
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, kScreenHeight - 44, kScreenWidth, 44);
    [btn setBackgroundImage:kImage(@"address_wdqb_tixiananniu") forState:UIControlStateNormal];
    [btn setTitle:@"确定申请" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(clickSubmitBtnAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:btn];
}

- (void)setNav {
    /** 设置标题 */
    self.controllerName = @"认证";
    
    /** 右按钮 */
    UIBarButtonItem *leftBarButtonItem = [UIBarButtonItem initWithNormalImage:@"qixiu_jiantouBackIcon" target:self action:@selector(leftBarButtonItemAction) width:11 height:21];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
}

- (void)leftBarButtonItemAction {
    
    [self.navigationController popViewControllerAnimated:YES];
}

/** 创建表格 */
- (void)createTableView {
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 44)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.view addSubview:self.tableView];
    
    //self.tableView.backgroundColor = kColor(234, 234, 236);
    /** 去tableview的线 */
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"CRCertificationCell" bundle:nil] forCellReuseIdentifier:idenyifier];
    
    _footView = [CRCertificationFootView viewFromXib];
    self.tableView.tableFooterView = _footView;
    
    
//    __weak typeof(self)wself = self;
    @weakify(self);
    _footView.footBlock = ^(NSInteger tag){
        
        weak_self.btn_tag = tag;
        
        [weak_self uploadHeaderImage];
    };
    
}

#pragma mark - UITableViewDelegate -
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CRCertificationCell *cell = [tableView dequeueReusableCellWithIdentifier:idenyifier forIndexPath:indexPath];
    
    cell.nameLabel.text = self.dataSource[indexPath.row][@"name"];
    cell.detailTextF.placeholder = self.dataSource[indexPath.row][@"text"];
    
    if (indexPath.row == 3) {
        cell.rightImageV.hidden = NO;
        cell.detailTextF.userInteractionEnabled = NO;
    } else {
        cell.detailTextF.userInteractionEnabled = YES;
        cell.rightImageV.hidden = YES;
    }
    
    switch (indexPath.row) {
        case 0:    // 公司名称
        {
            cell.block = ^(NSString *text){
                self.companyStr = text;
            };
            break;
        }
        case 1:    // 姓名
        {
            cell.block = ^(NSString *text){
                self.nameStr = text;
            };
            break;
        }
        case 2:    // 证件号
        {
            cell.block = ^(NSString *text){
                self.IDStr = text;
            };
            break;
        }
        case 4:    // 范围
        {
            cell.block = ^(NSString *text){
                self.scopeStr = text;
            };
            break;
        }
        case 5:    // 范围
        {
            cell.block = ^(NSString *text){
                self.specialtyStr = text;
            };
            break;
        }
            
        default:
            break;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 46;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CRCertificationCell *cell = [tableView dequeueReusableCellWithIdentifier:idenyifier forIndexPath:indexPath];
    if (indexPath.row == 3) {
        
        [self showAddressPickViewCell:cell Index:indexPath];
        
    } else if (indexPath.row == 5) {
        
//        CRSpecialtyController *specialtyVC = [[CRSpecialtyController alloc] init] ;
//        
//        specialtyVC.arrBlock = ^(NSMutableArray *pushaArr){
//            
//            NSMutableArray *arr = pushaArr;
//            
//            self.specialtyStr = [arr componentsJoinedByString:@","];
//            
//            cell.detailTextF.text = self.specialtyStr;
//            
//            NSIndexPath *indexPath=[NSIndexPath indexPathForRow:5 inSection:0];
//            [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
//        };
        
//        [self.navigationController pushViewController:specialtyVC animated:YES];
    }
}

#pragma mark - 选择地址
- (void)showAddressPickViewCell:(CRCertificationCell *)cell Index:(NSIndexPath *)index
{
    HDPickViewController *pickVC = [[HDPickViewController alloc] init];
    self.definesPresentationContext = YES;
    pickVC.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.4];
    pickVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
    pickVC.block = ^(ISAddressProvinceModel *isPmodel,ISAddressCityModel *isCitymodel,ISAddressCountryModel *isCoumodel) {
        self.pmodel = isPmodel;
        self.citymodel = isCitymodel;
        self.coumodel = isCoumodel;
        NSString *areaName;
        if (self.coumodel.name == nil) {
            areaName = @"";
        } else {
            areaName = self.coumodel.name;
        }
        
        NSString *str = [NSString stringWithFormat:@"%@ %@ %@",self.pmodel.name,self.citymodel.name,areaName];
        
        if (index.row == 3)
        {
            cell.detailTextF.text = str;
            self.cityStr = str;
            NSIndexPath *indexPath=[NSIndexPath indexPathForRow:3 inSection:0];
            
            [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
        }
    };
    [self presentViewController:pickVC animated:YES completion:^{
        
    }];
}

#pragma mark - 确定申请
- (void)clickSubmitBtnAction {
    
    NSLog(@"%@,%@,%@,%@,%@,%@",self.companyStr,self.nameStr,self.IDStr,self.cityStr,self.scopeStr,self.specialtyStr);
    
    if (self.companyStr.length == 0)
    {
        [MBProgressHUD alertHUDInView:self.view Text:@"请填写公司名称"];
        return;
    }
    if (self.nameStr.length == 0)
    {
        [MBProgressHUD alertHUDInView:self.view Text:@"请填写姓名"];
        return;
    }
    if (self.IDStr.length == 0)
    {
        [MBProgressHUD alertHUDInView:self.view Text:@"请填写证件号"];
        return;
    }
    if (self.pmodel.id.length == 0 || self.self.citymodel.id.length == 0 || self.coumodel.id.length == 0)
    {
        [MBProgressHUD alertHUDInView:self.view Text:@"请选择城市"];
        return;
    }
    if (self.scopeStr.length == 0)
    {
        [MBProgressHUD alertHUDInView:self.view Text:@"请填写范围"];
        return;
    }
    if (self.specialtyStr.length == 0)
    {
        [MBProgressHUD alertHUDInView:self.view Text:@"请选择专长"];
        return;
    }
    
    NSString *Main_Url = [self.baseUrl stringByAppendingString:@"user/Auth.php"];
    
    NSArray *arr = @[kHDUserId,[SuperHelper changeStringUTF:self.companyStr],[SuperHelper changeStringUTF:self.nameStr],self.IDStr,self.pmodel.id,self.citymodel.id,self.coumodel.id,[SuperHelper changeStringUTF:self.scopeStr],[SuperHelper changeStringUTF:self.specialtyStr]];
    
    [self showHud];
    
    [self.netWork asyncPhotoListForPersonWithImageArray:self.imageArr parameterArray:arr url:Main_Url success:^(id responseObjc) {
        [self endHud];
        
        NSLog(@"%@",responseObjc);
        
        NSInteger code = [responseObjc[@"errorcode"] integerValue];
        
        if (!code)
        {
            
        }
        else if (code == 13)
        {
            [MBProgressHUD alertHUDInView:self.view Text:@"证件号非法"];
        }
        else if (code == 36)
        {
            [MBProgressHUD alertHUDInView:self.view Text:@"姓名非法"];
        }
        else if (code == 37)
        {
            [MBProgressHUD alertHUDInView:self.view Text:@"公司名称非法"];
        }
        else if (code == 38)
        {
            [MBProgressHUD alertHUDInView:self.view Text:@"范围非法"];
        }
        else
        {
            [MBProgressHUD alertHUDInView:self.view Text:kServerError];
        }
        
    }];
}

#pragma mark - 上传头像
- (void)uploadHeaderImage
{
    UIAlertController *alertSheet = [UIAlertController alertControllerWithTitle:@"请您选择上传的图片" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alertSheet addAction:[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self cameraButtonClickedPersonVC];
    }]];
    [alertSheet addAction:[UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self pickImageFromAlbumPersonVC];
    }]];
    [alertSheet addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [self presentViewController:alertSheet animated:YES completion:nil];
}

#pragma mark - 相机相册
-(void)cameraButtonClickedPersonVC
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
        
        imagePicker.delegate = self;
        imagePicker.allowsEditing = YES;
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        imagePicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        
        [self presentViewController:imagePicker animated:YES completion:nil];
    }else{
        //如果没有提示用户
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"该设备没有摄像头" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }
}

//进相册
- (void)pickImageFromAlbumPersonVC
{
    UIImagePickerController * imagePicker = [[UIImagePickerController alloc] init];
    
    imagePicker.delegate = self;
    
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    imagePicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    
    imagePicker.allowsEditing = YES;
    
    [self presentViewController:imagePicker animated:YES completion:nil];
}

//点击完成执行方法,储存图片
- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    //    _footView.headImageV.contentMode = UIViewContentModeScaleToFill;
    //    _footView.headImageV.image = image;
    
    
    NSData *data = [self changeImageWithImage:image];
    
    if (self.btn_tag == 1000) {
        
        _footView.headImageV.image = image;
        
    } else if (self.btn_tag == 1001) {
        
        [_footView.topHeadView setImage:image forState:UIControlStateNormal];
        
    } else if (self.btn_tag == 1002) {
        
        [_footView.secHeadView setImage:image forState:UIControlStateNormal];
        
    } else if (self.btn_tag == 1003) {
        
        [_footView.thirView setImage:image forState:UIControlStateNormal];
        
    } else if (self.btn_tag == 1004) {
        
        [_footView.forthView setImage:image forState:UIControlStateNormal];
    }
    
    
    
    //    [self.imageDataAry addObject:data];
    //
    [self.imageArr addObject:data];
    //
    //    [self.collectionView reloadData];
    
}

- (NSData *)changeImageWithImage:(UIImage *)image {
    
    CGFloat originaWidth = image.size.width;
    CGFloat originaHeight = image.size.height;
    //12-02
    //设置image的尺寸
    CGSize imagesize = image.size;
    imagesize.width = 300;
    imagesize.height = 300 * originaHeight / originaWidth;
    
    //对图片大小进行压缩--
    image = [self imageWithImage:image scaledToSize:imagesize];
    
    [self saveImage:image withName:@"icon.png"];
    //    self.fileName = @"icon.png";
    NSString *fullPath =[[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"icon.png"];
    NSData *dataimg = [NSData dataWithContentsOfFile:fullPath];
    return dataimg;
}

//对图片尺寸进行压缩--
- (UIImage*)imageWithImage:(UIImage*)originalImage scaledToSize:(CGSize)size {
    // 开启上下文
    UIGraphicsBeginImageContextWithOptions(size, YES, 0);
    
    CGFloat originalScale = originalImage.size.width / originalImage.size.height; // 原始的比例
    CGFloat targetScale = size.width / size.height;// 目标的比例
    CGRect  targetRect;// 目标frame
    
    // 第一种情况
    if (originalScale > targetScale) { // 如果原始比例 > 目标比例 即 新图在imageView不设置的话 不会为原比例
        
        targetRect.size.width = size.width; // 宽度为imageview的宽度
        targetRect.size.height = size.height * targetScale / originalScale; // 高度为 imageView高度 * 比例
        
        targetRect.origin.x = 0.0f;
        targetRect.origin.y = (size.height - targetRect.size.height) * 0.5; // 位于中‘心’
        
    } else if (originalScale < targetScale) {
        
        targetRect.size.height = size.height; // 高度为imageView的高度
        targetRect.size.width = size.width * originalScale / targetScale;
        targetRect.origin.x = (size.width - targetRect.size.width) * 0.5;
        targetRect.origin.y = 0.0f;
        
    } else {
        targetRect = CGRectMake(0, 0, size.width, size.height);
    }
    // 渲染
    [originalImage drawInRect:targetRect];
    // 得到效果图
    UIImage *finalImage = UIGraphicsGetImageFromCurrentImageContext();
    // 关闭上下文
    UIGraphicsEndImageContext();
    
    return finalImage;
}

//存到本地
- (void)saveImage:(UIImage*)currentImage withName:(NSString *)imageName{
    
    NSData *imageData = UIImageJPEGRepresentation(currentImage, 0.5);
    
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:imageName];
    
    [imageData writeToFile:fullPath atomically:NO];
    
}





@end
