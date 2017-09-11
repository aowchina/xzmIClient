//
//  TracyPicCollectionView.m
//  CarAutoRepair
//
//  Created by minfo019 on 17/6/5.
//  Copyright © 2017年 Tracy. All rights reserved.
//

#import "TracyPicCollectionView.h"
#import "CTAssetsPickerController.h"
#import "CRChooseImageCell.h"
#import "CRChooseBtnCell.h"
#import "LLPhotoBrowser.h"

@interface TracyPicCollectionView ()<UICollectionViewDelegate,
UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,CTAssetsPickerControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,LLPhotoBrowserDelegate>



@end

@implementation TracyPicCollectionView

static NSString * const identifier = @"chooseImageCell";

static NSString * const identifier_btn = @"chooseBtnCell";

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self == [super initWithFrame:frame]) {
        
        self.imageArr = [NSMutableArray array];
//        self.imageDataAry = [NSMutableArray array];
        self.deleteArray = [NSMutableArray array];
        
        [self addSubview:self.collectionView];
    }
    
    return self;
}

#pragma mark - UICollectionView DataSource Delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    //CollectionCategoryModel *model = self.dataSource[section];
    //return model.subcategories.count;
    
    return self.imageArr.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == self.imageArr.count) {
        
        
        
        CRChooseBtnCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier_btn forIndexPath:indexPath];
        
        if (self.cantEdit == YES) {
            [cell.canmraBtn setImage:kImage(@"") forState:UIControlStateNormal];
        } else {
            
            [cell.canmraBtn setImage:kImage(@"qixiu_xiangji_camera") forState:UIControlStateNormal];
        }
        
        /** 点击相机 */
        cell.clickCameraBlock = ^() {
            
            if (self.cantEdit == YES) {
                return;
            }
            
            if (self.imageArr.count >= 9) {
                
                [MBProgressHUD alertHUDInView:[self viewController].view Text:@"最多选择9张图片"];
                
                return;
            }
            /** 选择上传方式 */
            [self chooseUpType];
        };
        
        return cell;
    } else {
        
        CRChooseImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
        
        cell.deleteBtn.hidden = self.cantEdit;
        
        if (indexPath.row < self.imageArr.count) {
 
            if ([self.imageArr[indexPath.row] isKindOfClass:[NSData class]]) {
                
                cell.imageV.image = [UIImage imageWithData:self.imageArr[indexPath.row]];
                
            } else {
                [cell.imageV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",EditImageURL,self.imageArr[indexPath.row]]]];
            }
        }
        
        cell.clickDeleteBtnBlock = ^(CRChooseImageCell *cell) {
            
            NSIndexPath *indexPathCell = [self.collectionView indexPathForCell:cell];
            
            ZLAlertView *alert = [[ZLAlertView alloc] initWithTitle:@"提示" message:@"是否删除？"];
            [alert addBtnTitle:@"保留" action:^{
                
            }];
            [alert addBtnTitle:@"删除" action:^{
                
//                if (self.imageArr.count == 1) {
//                    
//                    [self.imageArr removeAllObjects];
//                    
//                    [self.collectionView reloadData];
//                    
//                    self.deleteArray = [NSMutableArray array];
//                } else {
                
                    /** 防止越界 */
                    if (indexPathCell.row < self.imageArr.count) {
                        
                        
                        if (self.editType == 1) {
                            
                            if (![self.imageArr[indexPathCell.row] isKindOfClass:[NSData class]]) {
                            
                                [self.deleteArray addObject:self.editArray[indexPathCell.row]];
                            }
                        }
                        
                        [self.imageArr removeObjectAtIndex:indexPathCell.row];

                        [self.collectionView deleteItemsAtIndexPaths:@[indexPathCell]];
                        
                        [self.collectionView reloadData];
                        
                    }
//                }
                
            }];
            [alert showAlertWithSender:[self viewController]];
        };
        
        return cell;
    }
}

- (void)chooseUpType {
    
    UIAlertController *alertSheet = [UIAlertController alertControllerWithTitle:@"请您选择上传图片的来源？" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alertSheet addAction:[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self cameraButtonClickedPersonVC];
    }]];
    [alertSheet addAction:[UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self pickImageFromAlbumPersonVC];
    }]];
    [alertSheet addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [[self viewController] presentViewController:alertSheet animated:YES completion:nil];
}

- (void)pickImageFromAlbumPersonVC {
    
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        if (status != PHAuthorizationStatusAuthorized) return;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            CTAssetsPickerController *picker = [[CTAssetsPickerController alloc] init];
            picker.showsEmptyAlbums = NO;
            picker.showsSelectionIndex = YES;
            picker.assetCollectionSubtypes = @[@(PHAssetCollectionSubtypeAlbumRegular),@(PHAssetCollectionSubtypeSmartAlbumUserLibrary)];
            picker.delegate = self;
            
            [[self viewController] presentViewController:picker animated:YES completion:nil];
            
        });
    }];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(kScreenWidth* 0.25 - 10, kScreenWidth* 0.25 - 10);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(5 + self.headViewHeight, 5, 5, 5);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    // 1 初始化
    LLPhotoBrowser *photoBrowser = [[LLPhotoBrowser alloc]init];
    // 2 设置代理
    photoBrowser.delegate = self;
    // 3 设置当前图片
    photoBrowser.currentImageIndex = indexPath.item;
    // 4 设置图片的个数
    photoBrowser.imageCount = self.imageArr.count;
    // 5 设置图片的容器
    photoBrowser.sourceImagesContainerView = self.collectionView;
    // 6 展示
    [photoBrowser show];
}

// 代理方法 返回图片URL
//- (NSURL *)photoBrowser:(LLPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index{
//
//    NSURL *url = [NSURL URLWithString:self.photoArr[index]];
//
//    return url;
//}
// 代理方法返回缩略图
- (UIImage *)photoBrowser:(LLPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index{
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
    
    CRChooseImageCell *cell = (CRChooseImageCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    
    return cell.imageV.image;
    
}

#pragma mark - CTAssetsPickerControllerDelegate

- (BOOL)assetsPickerController:(CTAssetsPickerController *)picker shouldSelectAsset:(PHAsset *)asset {
    
    NSInteger max = 9;
    if (picker.selectedAssets.count < max) return YES;
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"注意" message:[NSString stringWithFormat:@"图片最多选择%zd张",max] preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil]];
    [picker presentViewController:alert animated:YES completion:nil];
    
    return NO;
}

- (void)assetsPickerController:(CTAssetsPickerController *)picker didFinishPickingAssets:(NSArray *)assets {
    
    [[self viewController] dismissViewControllerAnimated:YES completion:nil];
    
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.resizeMode = PHImageRequestOptionsResizeModeExact;
    options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    
    for (NSInteger i = 0; i < assets.count; i++) {
        
        PHAsset *asset = assets[i];
        
        CGFloat scale = [UIScreen mainScreen].scale;
        
        CGSize size = CGSizeMake(asset.pixelWidth/scale, asset.pixelHeight/scale);
        
        [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:size contentMode:PHImageContentModeDefault options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            
            if (self.imageArr.count >= 9) {
                
                [MBProgressHUD alertHUDInView:self Text:@"最多选择9张图片"];
                
                return;
            }
            
            NSData *data = [self changeImageWithImage:result];
            
//            [self.imageDataAry addObject:data];
            
            [self.imageArr addObject:data];
            
            [self.collectionView reloadData];
            
        }];
    }
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
        
        [[self viewController] presentViewController:imagePicker animated:YES completion:nil];
    }else{
        //如果没有提示用户
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"你没有摄像头" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }
}

//存到本地
- (void)saveImage:(UIImage*)currentImage withName:(NSString *)imageName{
    
    NSData *imageData = UIImageJPEGRepresentation(currentImage, 0.5);
    
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:imageName];
    
    [imageData writeToFile:fullPath atomically:NO];
    
}

//点击完成执行方法,储存图片
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    //NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
    
    //  UIImage *changeImage = [UIImage imageWithData:imageData];
    
    // [self.imageArr addObject:changeImage];
    
    //[self.collectionView reloadData];
    
    
    
    NSData *data = [self changeImageWithImage:image];
    
//    [self.imageDataAry addObject:data];
    
    [self.imageArr addObject:data];
    
    [self.collectionView reloadData];
    
    //    把图片展示
    //[self.nameImageView setImage:[UIImage imageWithData:dataimg]];
    
    
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

- (UICollectionView *)collectionView
{
    if (!_collectionView)
    {
        UICollectionViewFlowLayout *flowlayout = [[UICollectionViewFlowLayout alloc]init];
        //设置滚动方向
        [flowlayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        //左右间距
        flowlayout.minimumInteritemSpacing = 5;
        //上下间距
        flowlayout.minimumLineSpacing = 8;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowlayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView setBackgroundColor:[UIColor whiteColor]];
        
        //注册cell
        [_collectionView registerNib:[UINib nibWithNibName:@"CRChooseImageCell" bundle:nil] forCellWithReuseIdentifier:identifier];
        
        [_collectionView registerNib:[UINib nibWithNibName:@"CRChooseBtnCell" bundle:nil] forCellWithReuseIdentifier:identifier_btn];
        
        // [self setHeadView];
        
    }
    return _collectionView;
}

/**
 *  返回当前视图的控制器
 */
- (UIViewController *)viewController {
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}

@end
