
//
//  CRSalePeijianController.m
//  CarAutoRepair
//
//  Created by minfo019 on 17/5/27.
//  Copyright © 2017年 Tracy. All rights reserved.
//

#import "CRSalePeijianController.h"
#import "UITextView+YLTextView.h"
#import "CarModelsViewController.h"
#import "CRSubCarTypeController.h"
#import "CRSubImageViewController.h"
#import "CRProDetailModel.h"

@interface CRSalePeijianController ()<MBProgressHUDDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *carTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *carCateLabel;

@property (weak, nonatomic) IBOutlet UITextField *moneyF;
@property (weak, nonatomic) IBOutlet UITextField *phoneF;
@property (weak, nonatomic) IBOutlet UITextView *proDetailTextV;

@property (weak, nonatomic) IBOutlet UIImageView *carImageV;
@property (weak, nonatomic) IBOutlet UIImageView *typeImageV;



@property (weak, nonatomic) IBOutlet UIButton *subImageBtn;



@property (nonatomic, strong) NSMutableArray *imageArr;

@property (nonatomic, strong) NSMutableArray *imageDataAry;

@property (nonatomic, strong) NSString *typeID;

@property (nonatomic, strong) NSString *typeIDBig;

@property (nonatomic, strong) CRProDetailModel *model;

@property (nonatomic, strong) NSMutableArray *deletaArray;

@property (nonatomic, strong) NSString *carID;

@end

@implementation CRSalePeijianController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.imageArr = [NSMutableArray array];
    self.imageDataAry = [NSMutableArray array];
    self.deletaArray = [NSMutableArray array];
    
    [self setNav];
    
    if (self.peijianType == 2) {
        
        [self requestData];
    }
    
    if (self.peijianType == 7) {
        
        self.bianmaF.text = self.bianmaStr;
        self.nameF.text = self.nameStr;
        
        self.carTypeLabel.text = [NSString stringWithFormat:@"已选择%lu款车型",(unsigned long)self.carArray.count];
    }
}

- (void)requestData {
    
    NSString *goodListUrl = [BaseURL stringByAppendingString:@"goods/Detail.php"];
    
    [self showHud];
    
    [self.netWork asyncAFNPOST:goodListUrl Param:@[kHDUserId,self.goodid] Success:^(id responseObjc, NSError *codeErr) {
        
        [self endHud];
        
        NSLog(@"%@",responseObjc);
        
        if (!codeErr) {
            
            NSLog(@"%@",responseObjc);
            
            self.imageArr = [NSMutableArray arrayWithArray:responseObjc[@"info"][@"img"]];
            
            CRProDetailModel *model = [CRProDetailModel mj_objectWithKeyValues:responseObjc[@"info"]];
            
            self.model = model;
            
            self.nameF.text = model.name;
            self.carTypeLabel.text = model.car_name;
            self.carCateLabel.text = model.tname;
            self.moneyF.text = model.price;
            self.phoneF.text = model.tel;
            self.bianmaF.text = model.oem;
            self.proDetailTextV.text = model.detail;

            self.typeID = model.typeiD;
            
            self.typeIDBig = model.ptid;
            
            self.carID = model.carid;
            
            UIImageView *imageV = [[UIImageView alloc] init];
            [imageV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",EditImageURL,self.imageArr.firstObject]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                
                [self.subImageBtn setBackgroundImage:image forState:UIControlStateNormal];
            }];
            
        } else {
            NSInteger code = codeErr.code;
            if (code == 10 || code == 11 || code == 12) {
                //跳转登录
                [UIApplication sharedApplication].keyWindow.rootViewController = self.loginNav;
            } else {
                [MBProgressHUD buildHudWithtitle:@"服务器繁忙，请稍后重试!" superView:self.view];
            }
        }
    } Failure:^(NSError *netErr) {
        [self endHud];
        [MBProgressHUD buildHudWithtitle:@"无法连接到网络，请稍后再试!" superView:self.view];
    }];
}


- (void)setNav {
    /** 设置标题 */
    self.controllerName = @"发布配件";
//    self.proDetailTextV.placeholder = @"简单描述您的商品。";
    /** 左按钮 */
    UIBarButtonItem *leftBarButtonItem = [UIBarButtonItem initWithNormalImage:@"qixiu_jiantouBackIcon" target:self action:@selector(leftBarButtonItemAction) width:11 height:21];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    
    UITapGestureRecognizer *carTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(carTapAction)];

    [self.carImageV addGestureRecognizer:carTap];


    UITapGestureRecognizer *typeTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(typeTapAction)];
    [self.typeImageV addGestureRecognizer:typeTap];
}

- (void)leftBarButtonItemAction {
    
    if (self.peijianType == 1 || self.peijianType == 2 || self.peijianType == 7) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
}

- (IBAction)submitBtnAction:(UIButton *)sender {
    
    NSString *goods_AddUrl = [BaseURL stringByAppendingString:@"goods/Add.php"];
    
    if (self.peijianType == 2) {
        
        goods_AddUrl = [BaseURL stringByAppendingString:@"goods/Update.php"];
    }
    
    if ([SuperHelper isEmpty:self.nameF.text]) {
        [MBProgressHUD buildHudWithtitle:@"请输入配件名称" superView:self.view];
        return;
    }
    
//    if (self.imageDataAry.count == 0) {
//        [MBProgressHUD buildHudWithtitle:@"请上传配件图片" superView:self.view];
//        return;
//    }
    
    if (self.peijianType != 2) {
        
        if (self.carArray.count == 0) {
            [MBProgressHUD buildHudWithtitle:@"请选择车型" superView:self.view];
            return;
        }
    }
    
    if ([SuperHelper isEmpty:self.typeID]) {
        [MBProgressHUD buildHudWithtitle:@"请选择配件分类" superView:self.view];
        return;
    }
    
    if ([SuperHelper isEmpty:self.bianmaF.text]) {
        [MBProgressHUD buildHudWithtitle:@"请填写配件编码" superView:self.view];
        return;
    }
    
    if (![SuperHelper isPrice:self.moneyF.text]) {
        [MBProgressHUD buildHudWithtitle:@"请输入正确金额" superView:self.view];
        return;
    }
    
    if ([SuperHelper isEmpty:self.phoneF.text]) {
        [MBProgressHUD buildHudWithtitle:@"请输入正确的电话号码" superView:self.view];
        return;
    }
    
    if ([SuperHelper isEmpty:self.proDetailTextV.text]) {
        [MBProgressHUD buildHudWithtitle:@"请填写产品详情" superView:self.view];
        return;
    }
    
    NSString *str = [self.carArray componentsJoinedByString:@","];

    if (self.carArray.count == 0) {

        str = self.carID;
    }
    NSArray *array = @[kHDUserId,str,self.typeIDBig,self.bianmaF.text,self.moneyF.text,self.phoneF.text,[SuperHelper changeStringUTF:self.proDetailTextV.text],[SuperHelper changeStringUTF:self.nameF.text],self.typeID];
    
    if (self.peijianType == 2) {
        
        NSString *str1 = [self.deletaArray componentsJoinedByString:@","];
        
        array = @[kHDUserId,str,self.typeIDBig,self.bianmaF.text,self.moneyF.text,self.phoneF.text,[SuperHelper changeStringUTF:self.proDetailTextV.text],[SuperHelper changeStringUTF:self.nameF.text],self.goodid,str1,self.typeID];
        
    }
    
    [self showHud];
    
    [self.netWork asynAFNPOSTImage:goods_AddUrl Param:array ImageArray:self.imageDataAry TagArray:nil Success:^(id responseObjc, NSError *codeErr) {
        
        [self endHud];
        
        NSInteger code = codeErr.code;
        
        if (!code)
        {
            [MBProgressHUD alertHUDInView:self.view Text:@"上传成功" Delegate:self];
        }
        else if (code == 49)
        {
            [MBProgressHUD alertHUDInView:self.view Text:@"请输入配件名称"];
        }
        else if (code == 50)
        {
            [MBProgressHUD alertHUDInView:self.view Text:@"请重新选择车型"];
        }
        else if (code == 51)
        {
            [MBProgressHUD alertHUDInView:self.view Text:@"请填写正确的OEM号"];
        }
        else if (code == 52)
        {
            [MBProgressHUD alertHUDInView:self.view Text:@"请重新选择类别"];
        }
        else if (code == 53)
        {
            [MBProgressHUD alertHUDInView:self.view Text:@"请重新填写价格"];
        }
        else if (code == 54)
        {
            [MBProgressHUD alertHUDInView:self.view Text:@"电话填写不正确"];
        }
        else if (code == 55)
        {
            [MBProgressHUD alertHUDInView:self.view Text:@"请填写详情"];
        }
        else if (code == 90 || code == 92)
        {
            [MBProgressHUD alertHUDInView:self.view Text:@"请重新上传图片"];
        }
        else if (code == 56)
        {
            [MBProgressHUD alertHUDInView:self.view Text:@"您没有上传商品的权限"];
        }
        else
        {
            [MBProgressHUD alertHUDInView:self.view Text:kServerError];
        }
  
    } Failure:^(NSError *netErr) {
        [self endHud];
        [MBProgressHUD alertHUDInView:self.view Text:kNetError];
    }];
}

/** 车型选择 */
- (void)carTapAction {
    
    CarModelsViewController *carModelsC = [[CarModelsViewController alloc] init];
    carModelsC.subType = 1;
    carModelsC.returnCarIDBlock = ^(NSMutableArray *array){
        
        self.carArray = [NSMutableArray array];
        
        self.carArray = array;
        
        self.carTypeLabel.text = [NSString stringWithFormat:@"已选择%lu款车型",(unsigned long)array.count];
        
        self.carTypeLabel.textColor = [UIColor blackColor];
        
    };
    [self.navigationController pushViewController:carModelsC animated:YES];
}

/** 配件分类 */
- (void)typeTapAction {
    
    if (self.peijianType != 2) {
        
        if (self.carArray.count == 0) {
            [MBProgressHUD buildHudWithtitle:@"请选择车型" superView:self.view];
            return;
        }
    }
    
    NSString *str = [self.carArray componentsJoinedByString:@","];
    
    if (self.carArray.count == 0) {
        
        str = self.carID;
        
        if (!self.carID || self.carID == nil || [self.carID isEqualToString:@""]) {
            [MBProgressHUD buildHudWithtitle:@"请选择车型" superView:self.view];
            return;
        }
    }

    CRSubCarTypeController *carTypeC = [[CRSubCarTypeController alloc] init];
    
    carTypeC.carStr = str;
    
    carTypeC.returnTypeBlock = ^(NSString *str,NSString *iD,NSString *typeID) {
        
        self.carCateLabel.text = [NSString stringWithFormat:@"%@",str];
        self.carCateLabel.textColor = [UIColor blackColor];
        
        self.typeID = iD;
        self.typeIDBig = typeID;
    };
    [self.navigationController pushViewController:carTypeC animated:YES];
}

- (IBAction)subImageAction:(UIButton *)sender {
    
    CRSubImageViewController *subImageViewC = [[CRSubImageViewController alloc] init];
    
    subImageViewC.imageArr = self.imageArr;
    subImageViewC.imageDataAry = self.imageDataAry;
    subImageViewC.editArray = self.imageArr;
    
    subImageViewC.editType = 1;
    
    subImageViewC.returnImageBlock = ^(NSMutableArray *imageArr,NSMutableArray *imageDataAry,NSMutableArray *deleteArray) {
        
        self.imageArr = imageArr;
//        self.imageDataAry
        
        for (id objc in imageArr) {
            
            if ([objc isKindOfClass:[NSData class]]) {
                [self.imageDataAry addObject:objc];
            }
        }
        
        for (NSString *str in deleteArray) {
            
            [self.deletaArray addObject:str];
        }

        
        if ([imageArr.firstObject isKindOfClass:[NSData class]]) {
            
            [self.subImageBtn setBackgroundImage:[UIImage imageWithData:imageArr.lastObject] forState:UIControlStateNormal];
        } else {
            
            UIImageView *imageV = [[UIImageView alloc] init];
            [imageV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",EditImageURL,self.imageArr.firstObject]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                
                [self.subImageBtn setBackgroundImage:image forState:UIControlStateNormal];
            }];
            
        }
        
        NSLog(@"%@----%d---%d",self.deletaArray,imageArr.count,imageDataAry.count);
        
//        [self.subImageBtn setBackgroundImage:imageArr.lastObject forState:UIControlStateNormal];
//        
//        NSLog(@"%d---%d",imageArr.count,imageDataAry.count);
        
        
    };
    [self.navigationController pushViewController:subImageViewC animated:YES];

}

- (void)hudWasHidden:(MBProgressHUD *)hud {
    
    if (self.peijianType == 1 || self.peijianType == 7 || self.peijianType == 2) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

@end
