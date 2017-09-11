//
//  CREditInfoViewController.m
//  CarAutoRepair
//
//  Created by minfo019 on 17/5/31.
//  Copyright © 2017年 Tracy. All rights reserved.
//

#import "CREditInfoViewController.h"

@interface CREditInfoViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate,MBProgressHUDDelegate>


@property (weak, nonatomic) IBOutlet UIImageView *headImageV;
@property (weak, nonatomic) IBOutlet UITextField *nickNameTextF;
/** 原用户名 */
@property (nonatomic ,strong) NSString *oldName;

@property (nonatomic ,strong) NSMutableArray *imgArr;


@end

@implementation CREditInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setNav];
    
    self.imgArr = [NSMutableArray array];
    
    _oldName = kUserName;
    
    [self.headImageV sd_setImageWithURL:[NSURL URLWithString:kUserImage] placeholderImage:kImage(@"qixiu_touxiang")];
    
    _nickNameTextF.placeholder = _oldName;
    
    /** 添加手势 */
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageView)];
    
    [self.headImageV addGestureRecognizer:tap];
    
    [_nickNameTextF setValue:ColorForRGB(0x828282) forKeyPath:@"_placeholderLabel.textColor"];
}

/** 换头像 */
- (void)tapImageView {
    
    UIAlertController *alertSheet = [UIAlertController alertControllerWithTitle:@"请您选择上传图片的来源？" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
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

- (void)setNav {
    /** 设置标题 */
    self.controllerName = @"修改个人信息";
    
    /** 右按钮 */
    UIBarButtonItem *leftBarButtonItem = [UIBarButtonItem initWithNormalImage:@"qixiu_jiantouBackIcon" target:self action:@selector(leftBarButtonItemAction) width:11 height:21];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
}


/** 提交 */
- (IBAction)submitBtnAction:(UIButton *)sender {
    
    if (self.nickNameTextF.text.length == 0)
    {
        self.nickNameTextF.text = self.oldName;
    }
    
    NSString *Main_Url = [self.baseUrl stringByAppendingString:@"user/EditName.php"];
    
    NSArray *arr = @[kHDUserId,[SuperHelper changeStringUTF:self.nickNameTextF.text]];
    
    [self showHud];
    
    [self.netWork asynAFNPOSTImage:Main_Url Param:arr ImageArray:self.imgArr TagArray:nil Success:^(id responseObjc, NSError *codeErr) {
        
        [self endHud];
        
        NSInteger code = codeErr.code;
        
        if (!code)
        {
            
            [MBProgressHUD alertHUDInView:self.view Text:@"修改成功!" Delegate:self];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshInfo" object:nil];
        }
        else if (code == 36)
        {
            [MBProgressHUD alertHUDInView:self.view Text:@"昵称不正确"];
        }
        else
        {
            [MBProgressHUD alertHUDInView:self.view Text:kServerError];
        }
        
    } Failure:^(NSError *netErr) {
        [self endHud];
        [MBProgressHUD alertHUDInView:self.view Text:kNetError];
    }];

/*
    [self.netWork asyncPhotoListForPersonWithImageArray:self.imgArr parameterArray:arr url:Main_Url success:^(id responseObjc) {
        [self endHud];
        
        NSLog(@"%@",responseObjc);
        
        NSInteger code = [responseObjc[@"errorcode"] integerValue];
        
        if (!code)
        {
            [MBProgressHUD alertHUDInView:self.view Text:@"修改成功!" Delegate:self];
        }
        else
        {
            [MBProgressHUD alertHUDInView:self.view Text:kServerError];
        }
        
    }];
*/
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
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"你没有摄像头" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
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

    NSData *data = [self changeImageWithImage:image];
    
    _headImageV.image = image;

    [self.imgArr addObject:data];
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

- (void)leftBarButtonItemAction {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)hudWasHidden:(MBProgressHUD *)hud
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
