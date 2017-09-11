//
//  TracyPicCollectionView.h
//  CarAutoRepair
//
//  Created by minfo019 on 17/6/5.
//  Copyright © 2017年 Tracy. All rights reserved.
//

#import <UIKit/UIKit.h>

//typedef void(^chooseImageBlock)(NSMutableArray *imageArr,NSMutableArray *fileArray,NSMutableArray *deleteArray);

@interface TracyPicCollectionView : UIView


@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray *imageArr;

@property (nonatomic, assign) BOOL cantEdit;
//@property (nonatomic, strong) NSMutableArray *imageDataAry;

@property (nonatomic, assign) NSInteger headViewHeight;/** 头视图高高度 */

@property (nonatomic, assign) NSInteger editType;

@property (nonatomic, strong) NSMutableArray *editArray;

@property (nonatomic, strong) NSMutableArray *deleteArray;


@end
