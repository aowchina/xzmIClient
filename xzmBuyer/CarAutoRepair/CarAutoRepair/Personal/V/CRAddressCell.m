//
//  CRAddressCell.m
//  CarAutoRepair
//
//  Created by Min-Fo-027 on 2017/6/1.
//  Copyright © 2017年 Tracy. All rights reserved.
//

#import "CRAddressCell.h"
#import "CRAddressListModel.h"

@interface CRAddressCell ()

@property (nonatomic, strong) UIImageView *bgimgView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *telePhonelabel;
@property (nonatomic, strong) UILabel *addressLabel;
@property (nonatomic, strong) UIButton *editBtn;
//删除按钮
@property (nonatomic, strong) UIButton *deleteBtn;

//手势
@property (nonatomic, strong) UISwipeGestureRecognizer *leftSwipeGestureRecognizer;
@property (nonatomic, strong) UISwipeGestureRecognizer *rightSwipeGestureRecognizer;

@end

@implementation CRAddressCell


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self buildSubView];
    }
    return self;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    
    self.contentView.backgroundColor = [UIColor clearColor];
    
    self.bgimgView.frame = CGRectMake(0, 0, kScreenWidth, 80);
    self.nameLabel.frame = CGRectMake(kScreenWidth*0.05, 0,kScreenWidth*0.3, 40);
    self.telePhonelabel.frame = CGRectMake(kScreenWidth*0.35, 0,kScreenWidth*0.4, 40);
    self.addressLabel.frame = CGRectMake(kScreenWidth*0.05, 40,kScreenWidth*0.9, 40);
    
}

- (void)buildSubView {
    
    
    self.leftSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipes:)];
    self.rightSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipes:)];
    
    self.leftSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    self.rightSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    
    [self.contentView addGestureRecognizer:self.leftSwipeGestureRecognizer];
    [self.contentView addGestureRecognizer:self.rightSwipeGestureRecognizer];
    
    //deleteBtn
    self.deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.deleteBtn setBackgroundImage:kImage(@"address_delete") forState:UIControlStateNormal];
    self.deleteBtn.frame = CGRectMake(kScreenWidth*0.8, 25, 23, 24);
//    self.deleteBtn.centerY = self.centerY;
    [self.deleteBtn addTarget:self action:@selector(delete_Btn:) forControlEvents:UIControlEventTouchDown];
    [self.contentView addSubview:self.deleteBtn];
    
    self.bgimgView = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.bgimgView.image = kImage(@"address_back");
    self.bgimgView.userInteractionEnabled = YES;
    [self.contentView addSubview:self.bgimgView];
    
    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.font = KFont(17);
    [self.bgimgView addSubview:self.nameLabel];
    
    self.telePhonelabel = [[UILabel alloc] init];
    self.telePhonelabel.font = KFont(17);
    [self.bgimgView addSubview:self.telePhonelabel];
    
    self.addressLabel = [[UILabel alloc] init];
    self.addressLabel.font = KFont(13);
    [self.bgimgView addSubview:self.addressLabel];

    self.yesImgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.yesImgBtn setBackgroundImage:kImage(@"qixiu_weixuanzhong_select") forState:UIControlStateNormal];
    [self.yesImgBtn setBackgroundImage:kImage(@"qixiu_xuanzhong_seleted") forState:UIControlStateSelected];
    self.yesImgBtn.frame = CGRectMake(kScreenWidth*0.85, 28, 18, 17);
//    self.yesImgBtn.centerY = self.centerY;
    [self.bgimgView addSubview:self.yesImgBtn];
}

- (void)reloadDataWithData:(CRAddressListModel *)data
{
    self.nameLabel.text = [NSString stringWithFormat:@"%@",data.user_name];
    
    self.telePhonelabel.text = [NSString stringWithFormat:@"%@",data.user_tel];
    
    self.addressLabel.text = [NSString stringWithFormat:@"%@",data.user_address];
    
    if ([data.isdefault isEqualToString:@"1"])
    {
        [self.yesImgBtn setBackgroundImage:kImage(@"qixiu_xuanzhong_seleted") forState:UIControlStateNormal];
    }
    else
    {
        [self.yesImgBtn setBackgroundImage:kImage(@"qixiu_weixuanzhong_select") forState:UIControlStateNormal];
    }
}


- (void)handleSwipes:(UISwipeGestureRecognizer *)sender
{
    if (sender.direction == UISwipeGestureRecognizerDirectionLeft)
    {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.2];
        self.bgimgView.frame = CGRectMake(-80, 0, kScreenWidth, 80);
        [UIView commitAnimations];
    }
    
    if (sender.direction == UISwipeGestureRecognizerDirectionRight)
    {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.2];
        self.bgimgView.frame = CGRectMake(0, 0, kScreenWidth, 80);
        [UIView commitAnimations];
    }
}


-(void)delete_Btn:(UIButton *)button
{
    _deleteblock(self);
}

-(void)deleteBlockWithData:(deleteBlock)deleteblock
{
    
    _deleteblock = deleteblock;
}

@end
