//
//  CRCertificationFootView.m
//  CarAutoRepair
//
//  Created by minfo019 on 17/5/19.
//  Copyright © 2017年 Tracy. All rights reserved.
//

#import "CRCertificationFootView.h"

@interface CRCertificationFootView ()

@end

@implementation CRCertificationFootView


#pragma mark - 个人头像
- (IBAction)headBtnAction:(UIButton *)sender
{
    if (self.footBlock)
    {
        self.footBlock(1000);
    }
    /*
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
     */
}

- (IBAction)clickBtnAction:(UIButton *)sender {
    
    
    if (self.footBlock)
    {
        self.footBlock(sender.tag);
    }
    
}


/*
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
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"该设备没有摄像头" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
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
    //    UIImagePickerControllerOriginalImage
    _workImage.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [_workImage setImage:image forState:UIControlStateNormal];
    
    //转Base64
    
    NSData *data = UIImageJPEGRepresentation(image, 0.2f);
    
    
    //    NSData *data = UIImageJPEGRepresentation(image, 0.5f);
    
    
    NSData *baseData = [data base64EncodedDataWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    
    NSString *strPath = [[NSString alloc] initWithData:baseData encoding:NSASCIIStringEncoding];
    
    _encodedImageStr = strPath;
    
}
*/

@end
